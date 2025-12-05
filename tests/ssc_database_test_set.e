note
	description: "Tests for SSC_DATABASE - SSC-specific database operations"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_DATABASE_TEST_SET

inherit
	TEST_SET_BASE
		redefine
			on_prepare,
			on_clean
		end

feature -- Test setup/teardown

	on_prepare
			-- Setup before each test: ensure clean database state.
			-- Reuses database connection if already open, truncates tables for isolation.
		do
			if not attached database as l_db or else not l_db.db.is_open then
				-- First test or database was closed - create fresh
				create database.make (test_db_path)
			end

			-- Truncate all tables for a clean test state
			db.db.execute ("DELETE FROM analytics")
			db.db.execute ("DELETE FROM contacts")
			db.db.execute ("DELETE FROM sessions")
			-- Reset autoincrement counters
			db.db.execute ("DELETE FROM sqlite_sequence WHERE name IN ('analytics', 'contacts', 'sessions')")
		end

	on_clean
			-- Teardown after each test: keep database open for next test
		do
			-- Don't close - let on_prepare reuse the connection
			-- This avoids file lock issues on Windows
		end

feature -- Test routines: Database Initialization

	test_database_creates_schema
			-- Test that database creates all required tables on init
		local
			l_result: SIMPLE_SQL_RESULT
		do
			-- Verify SSC-specific tables exist
			l_result := db.db.query ("SELECT name FROM sqlite_master WHERE type='table' AND name='analytics'")
			assert ("analytics_table_exists", not l_result.rows.is_empty)

			l_result := db.db.query ("SELECT name FROM sqlite_master WHERE type='table' AND name='contacts'")
			assert ("contacts_table_exists", not l_result.rows.is_empty)

			l_result := db.db.query ("SELECT name FROM sqlite_master WHERE type='table' AND name='sessions'")
			assert ("sessions_table_exists", not l_result.rows.is_empty)
		end

feature -- Test routines: Analytics

	test_analytics_workflow
			-- Test complete analytics workflow: log requests, get counts
		local
			l_summary: TUPLE [total_requests: INTEGER; unique_paths: INTEGER; unique_ips: INTEGER]
		do
			-- Log some requests
			db.log_request ("/", "GET", "1.1.1.1", "Mozilla", "", 200, 10)
			db.log_request ("/about", "GET", "2.2.2.2", "Chrome", "", 200, 20)
			db.log_request ("/", "GET", "1.1.1.1", "Mozilla", "", 200, 15)

			-- Verify summary
			l_summary := db.get_analytics_summary
			assert ("total_3", l_summary.total_requests = 3)
			assert ("paths_2", l_summary.unique_paths = 2)
			assert ("ips_2", l_summary.unique_ips = 2)
		end

feature -- Test routines: Contact Form

	test_contact_workflow
			-- Test complete contact workflow: save, retrieve, mark read
		local
			l_id: INTEGER_64
			l_contacts: ARRAYED_LIST [TUPLE [id: INTEGER_64; name: STRING; email: STRING; subject: STRING; message: STRING; created_at: STRING; read_at: detachable STRING]]
		do
			-- Save contact
			l_id := db.save_contact ("John", "john@test.com", "Hello", "Test message", "127.0.0.1")
			assert ("id_positive", l_id > 0)
			assert ("one_unread", db.get_unread_contact_count = 1)

			-- Retrieve and verify
			l_contacts := db.get_contacts (10)
			assert ("one_contact", l_contacts.count = 1)
			assert ("name_correct", l_contacts.first.name.same_string ("John"))
			assert ("initially_unread", l_contacts.first.read_at = Void)

			-- Mark as read
			db.mark_contact_read (l_id)
			assert ("now_read", db.get_unread_contact_count = 0)
		end

feature -- Test routines: Sessions

	test_session_workflow
			-- Test complete session workflow: create, validate, delete
		do
			-- Create session
			assert ("session_created", db.create_session ("test-token", 24))

			-- Validate
			assert ("token_valid", db.validate_session ("test-token"))
			assert ("wrong_token_invalid", not db.validate_session ("wrong"))

			-- Delete (logout)
			db.delete_session ("test-token")
			assert ("deleted_invalid", not db.validate_session ("test-token"))
		end

feature {NONE} -- Implementation

	database: detachable SSC_DATABASE
			-- Database instance for current test

	db: SSC_DATABASE
			-- Attached database (use in tests after on_prepare)
		do
			check attached database as l_db then
				Result := l_db
			end
		end

	test_db_path: STRING = "test_showcase.db"
			-- Path for test database (relative to working directory)

end
