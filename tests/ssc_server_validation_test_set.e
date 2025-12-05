note
	description: "Tests for SSC_SERVER input validation, sanitization, and rate limiting"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_SERVER_VALIDATION_TEST_SET

inherit
	TEST_SET_BASE

feature -- Test routines: Email Validation

	test_email_validation_accepts_valid
			-- Test that valid emails are accepted (exercises is_valid_email contract)
		do
			assert ("simple", server.is_valid_email ("user@example.com"))
			assert ("with_subdomain", server.is_valid_email ("user@mail.example.com"))
			assert ("with_plus", server.is_valid_email ("user+tag@example.com"))
			assert ("with_underscore", server.is_valid_email ("user_name@example.com"))
			assert ("with_dots", server.is_valid_email ("first.last@example.com"))
		end

	test_email_validation_rejects_invalid
			-- Test that invalid emails are rejected
		do
			assert ("empty", not server.is_valid_email (""))
			assert ("no_at", not server.is_valid_email ("userexample.com"))
			assert ("no_domain", not server.is_valid_email ("user@"))
			assert ("no_local", not server.is_valid_email ("@example.com"))
			assert ("too_short", not server.is_valid_email ("a@b"))
			assert ("no_dot_in_domain", not server.is_valid_email ("user@example"))
			assert ("dot_at_end", not server.is_valid_email ("user@example."))
		end

feature -- Test routines: Sanitization (exercises contracts)

	test_sanitize_email_removes_dangerous_chars
			-- Test that sanitize_email_address removes non-whitelisted characters
		local
			l_result: STRING
		do
			-- Normal email should pass through
			l_result := server.sanitize_email_address ("user@example.com")
			assert ("normal_unchanged", l_result.same_string ("user@example.com"))

			-- Shell injection attempts should be stripped
			l_result := server.sanitize_email_address ("user$(whoami)@example.com")
			assert ("dollar_removed", not l_result.has ('$'))
			assert ("parens_removed", not l_result.has ('(') and not l_result.has (')'))

			-- Backticks removed
			l_result := server.sanitize_email_address ("user`id`@example.com")
			assert ("backtick_removed", not l_result.has ('`'))

			-- Quotes removed
			l_result := server.sanitize_email_address ("user'test@example.com")
			assert ("single_quote_removed", not l_result.has ('%''))

			-- Semicolons and pipes removed
			l_result := server.sanitize_email_address ("user;ls|cat@example.com")
			assert ("semicolon_removed", not l_result.has (';'))
			assert ("pipe_removed", not l_result.has ('|'))
		end

	test_sanitize_for_email_removes_header_injection
			-- Test that sanitize_for_email prevents email header injection
		local
			l_result: STRING
		do
			-- Newlines (header injection) should be converted to spaces
			l_result := server.sanitize_for_email ("Hello%NBcc: attacker@evil.com")
			assert ("newline_removed", not l_result.has ('%N'))

			-- Carriage return also removed
			l_result := server.sanitize_for_email ("Hello%RWorld")
			assert ("cr_removed", not l_result.has ('%R'))
		end

	test_sanitize_for_email_removes_shell_chars
			-- Test that sanitize_for_email removes shell metacharacters
		local
			l_result: STRING
		do
			-- All dangerous shell chars removed
			l_result := server.sanitize_for_email ("test'%"`$\|&;<>")
			assert ("single_quote_gone", not l_result.has ('%''))
			assert ("double_quote_gone", not l_result.has ('%"'))
			assert ("backtick_gone", not l_result.has ('`'))
			assert ("dollar_gone", not l_result.has ('$'))
			assert ("pipe_gone", not l_result.has ('|'))
			assert ("ampersand_gone", not l_result.has ('&'))
			assert ("semicolon_gone", not l_result.has (';'))
			assert ("less_than_gone", not l_result.has ('<'))
			assert ("greater_than_gone", not l_result.has ('>'))
		end

	test_remove_control_chars
			-- Test that dangerous control characters are removed
		local
			l_input, l_result: STRING
		do
			-- Create string with control characters
			create l_input.make (20)
			l_input.append ("Hello")
			l_input.append_character ('%U') -- NULL (0x00)
			l_input.append ("World")

			l_result := server.remove_control_chars (l_input)
			assert ("null_removed", not l_result.has ('%U'))
			assert ("text_preserved", l_result.has_substring ("Hello") and l_result.has_substring ("World"))

			-- Tab, newline, CR should be preserved
			l_input := "Line1%TTabbed%NLine2%REnd"
			l_result := server.remove_control_chars (l_input)
			assert ("tab_preserved", l_result.has ('%T'))
			assert ("newline_preserved", l_result.has ('%N'))
			assert ("cr_preserved", l_result.has ('%R'))
		end

	test_has_dangerous_control_chars_helper
			-- Test the contract helper function
		do
			-- Safe strings
			assert ("normal_safe", not server.has_dangerous_control_chars ("Hello World"))
			assert ("with_tab_safe", not server.has_dangerous_control_chars ("Hello%TWorld"))
			assert ("with_newline_safe", not server.has_dangerous_control_chars ("Hello%NWorld"))
			assert ("with_cr_safe", not server.has_dangerous_control_chars ("Hello%RWorld"))

			-- Dangerous strings (would need to construct with control chars)
			-- NULL character
			assert ("null_dangerous", server.has_dangerous_control_chars ("Hello%UWorld"))
		end

	test_is_safe_email_char_helper
			-- Test the email character whitelist helper
		do
			-- Safe characters
			assert ("alpha_safe", server.is_safe_email_char ('a'))
			assert ("digit_safe", server.is_safe_email_char ('5'))
			assert ("at_safe", server.is_safe_email_char ('@'))
			assert ("dot_safe", server.is_safe_email_char ('.'))
			assert ("underscore_safe", server.is_safe_email_char ('_'))
			assert ("hyphen_safe", server.is_safe_email_char ('-'))
			assert ("plus_safe", server.is_safe_email_char ('+'))

			-- Unsafe characters
			assert ("space_unsafe", not server.is_safe_email_char (' '))
			assert ("dollar_unsafe", not server.is_safe_email_char ('$'))
			assert ("backtick_unsafe", not server.is_safe_email_char ('`'))
			assert ("semicolon_unsafe", not server.is_safe_email_char (';'))
			assert ("pipe_unsafe", not server.is_safe_email_char ('|'))
		end

feature -- Test routines: Rate Limiting Logic

	test_rate_limit_allows_under_threshold
			-- Test submissions under threshold are allowed
		local
			l_tracker: HASH_TABLE [ARRAYED_LIST [INTEGER_64], STRING]
			l_timestamps: ARRAYED_LIST [INTEGER_64]
			l_now: INTEGER_64
		do
			create l_tracker.make (10)
			l_now := current_unix_timestamp

			-- 4 recent submissions (under 5 limit)
			create l_timestamps.make (5)
			l_timestamps.extend (l_now - 100)
			l_timestamps.extend (l_now - 200)
			l_timestamps.extend (l_now - 300)
			l_timestamps.extend (l_now - 400)
			l_tracker.force (l_timestamps, "192.168.1.1")

			assert ("allowed", not is_rate_limited (l_tracker, "192.168.1.1", l_now))
		end

	test_rate_limit_blocks_at_threshold
			-- Test reaching threshold blocks submissions
		local
			l_tracker: HASH_TABLE [ARRAYED_LIST [INTEGER_64], STRING]
			l_timestamps: ARRAYED_LIST [INTEGER_64]
			l_now: INTEGER_64
		do
			create l_tracker.make (10)
			l_now := current_unix_timestamp

			-- 5 recent submissions (at limit)
			create l_timestamps.make (5)
			l_timestamps.extend (l_now - 100)
			l_timestamps.extend (l_now - 200)
			l_timestamps.extend (l_now - 300)
			l_timestamps.extend (l_now - 400)
			l_timestamps.extend (l_now - 500)
			l_tracker.force (l_timestamps, "192.168.1.1")

			assert ("blocked", is_rate_limited (l_tracker, "192.168.1.1", l_now))
		end

	test_rate_limit_ignores_expired
			-- Test expired entries don't count toward limit
		local
			l_tracker: HASH_TABLE [ARRAYED_LIST [INTEGER_64], STRING]
			l_timestamps: ARRAYED_LIST [INTEGER_64]
			l_now: INTEGER_64
		do
			create l_tracker.make (10)
			l_now := current_unix_timestamp

			-- All submissions over 1 hour ago
			create l_timestamps.make (5)
			l_timestamps.extend (l_now - 4000)
			l_timestamps.extend (l_now - 4500)
			l_timestamps.extend (l_now - 5000)
			l_timestamps.extend (l_now - 5500)
			l_timestamps.extend (l_now - 6000)
			l_tracker.force (l_timestamps, "192.168.1.1")

			assert ("expired_ignored", not is_rate_limited (l_tracker, "192.168.1.1", l_now))
		end

	test_rate_limit_new_ip_allowed
			-- Test new IPs are not limited
		local
			l_tracker: HASH_TABLE [ARRAYED_LIST [INTEGER_64], STRING]
		do
			create l_tracker.make (10)
			assert ("new_ip_allowed", not is_rate_limited (l_tracker, "10.0.0.1", current_unix_timestamp))
		end

feature {NONE} -- Test fixtures

	server: SSC_SERVER
			-- Server instance for testing validation functions.
			-- Uses make_for_testing to avoid starting the blocking server.
		once
			create Result.make_for_testing ("config.test.json")
		end

feature {NONE} -- Test helpers (rate limiting logic - mirrors SSC_SERVER)

	current_unix_timestamp: INTEGER_64
			-- Current time as Unix timestamp
		local
			l_now: DATE_TIME
			l_epoch: DATE_TIME
		do
			create l_now.make_now
			create l_epoch.make (1970, 1, 1, 0, 0, 0)
			Result := l_now.definite_duration (l_epoch).seconds_count
		end

	is_rate_limited (a_tracker: HASH_TABLE [ARRAYED_LIST [INTEGER_64], STRING]; a_ip: STRING; a_now: INTEGER_64): BOOLEAN
			-- Check if IP is rate limited (mirrors SSC_SERVER logic for isolated testing)
		local
			l_timestamps: detachable ARRAYED_LIST [INTEGER_64]
			l_cutoff: INTEGER_64
			l_recent_count: INTEGER
		do
			l_cutoff := a_now - 3600 -- 1 hour window
			l_timestamps := a_tracker.item (a_ip)
			if attached l_timestamps then
				across l_timestamps as ts loop
					if ts > l_cutoff then
						l_recent_count := l_recent_count + 1
					end
				end
				Result := l_recent_count >= 5
			end
		end

end
