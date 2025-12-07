note
	description: "[
		Simple Showcase HTTP Server.

		Serves the SSC website using simple_web's HTTP server.
		All pages are generated dynamically from Eiffel classes.

		Usage:
			Run the executable, then browse to configured URL.
			Default: http://localhost:8080

		Configuration:
			Reads from config.json in current directory.
			Use config.production.json for deployment.
	]"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_SERVER

inherit
	SSC_LOGGER

create
	make,
	make_with_config,
	make_for_testing

feature {NONE} -- Initialization

	make
			-- Create and start the server with default config
		do
			make_with_config ("config.json")
		end

	make_with_config (a_config_path: STRING)
			-- Create and start the server with config from `a_config_path`
		require
			path_not_empty: not a_config_path.is_empty
		do
			create config.make (a_config_path)

			if config.verbose_logging then
				print ("%N========================================%N")
				print ("   SSC SERVER - " + config.mode.as_upper + " MODE%N")
				print ("========================================%N%N")
				io.output.flush
			end

			log_info ("server", "=== Simple Showcase Server Starting ===")
			log_info ("server", "Mode: " + config.mode)

			-- Initialize database
			create database.make (config.db_path)
			log_info ("server", "Database initialized: " + config.db_path)

			create server.make (config.port)
			log_info ("server", "Server created on port " + config.port.out)

			register_routes
			log_info ("server", "Routes registered")

			print ("%NSimple Showcase Server%N")
			print ("=======================%N")
			print ("Mode: " + config.mode + "%N")
			print ("Open browser to: " + config.base_url + "%N%N")

			-- NOTE: Analytics middleware uses per-request DB connections to avoid
			-- cross-thread SQLite issues (worker pool threads vs main thread).
			server.use_middleware (create {SSC_ANALYTICS_MIDDLEWARE}.make (config.db_path))
			log_info ("server", "Analytics middleware enabled")

			server.use_logging
			log_info ("server", "Logging middleware enabled")
			log_info ("server", "Calling server.start (blocking)...")
			server.start
		end

	make_for_testing (a_config_path: STRING)
			-- Create server for testing WITHOUT starting it (non-blocking).
			-- Use this in test fixtures to access validation functions.
		require
			path_not_empty: not a_config_path.is_empty
		do
			create config.make (a_config_path)
			create database.make (config.db_path)
			create server.make (config.port)
			-- Note: Does NOT call register_routes, use_middleware, or server.start
		end

feature -- Server

	server: SIMPLE_WEB_SERVER
			-- HTTP server instance

	config: SSC_CONFIG
			-- Server configuration

	database: SSC_DATABASE
			-- SQLite database for analytics, contacts, sessions

feature {NONE} -- Route Registration

	register_routes
			-- Register all page routes
		do
			log_debug ("routes", "Registering page routes...")

			-- Landing page
			server.on_get ("/", agent handle_landing)
			log_debug ("routes", "  GET / -> handle_landing")

			-- Sub-pages
			server.on_get ("/get-started", agent handle_get_started)
			server.on_get ("/portfolio", agent handle_portfolio)
			server.on_get ("/design-by-contract", agent handle_dbc)
			server.on_get ("/workflow", agent handle_workflow)
			server.on_get ("/analysis", agent handle_analysis)
			server.on_get ("/business-case", agent handle_business_case)
			server.on_get ("/why-eiffel", agent handle_why_eiffel)
			server.on_get ("/probable-to-provable", agent handle_probable)
			server.on_get ("/old-way", agent handle_old_way)
			server.on_get ("/ai-changes", agent handle_ai_changes)
			server.on_get ("/contact", agent handle_contact)
			server.on_get ("/full-report", agent handle_full_report)
			log_debug ("routes", "  Registered 12 sub-page routes")

			-- Redirect .html extensions to clean URLs
			server.on_get ("/index.html", agent handle_redirect_home)
			server.on_get ("/get-started.html", agent handle_redirect_get_started)
			server.on_get ("/portfolio.html", agent handle_redirect_portfolio)
			server.on_get ("/design-by-contract.html", agent handle_redirect_dbc)
			server.on_get ("/workflow.html", agent handle_redirect_workflow)
			server.on_get ("/analysis.html", agent handle_redirect_analysis)
			server.on_get ("/business-case.html", agent handle_redirect_business_case)
			server.on_get ("/why-eiffel.html", agent handle_redirect_why_eiffel)
			server.on_get ("/probable-to-provable.html", agent handle_redirect_probable)
			server.on_get ("/old-way.html", agent handle_redirect_old_way)
			server.on_get ("/ai-changes.html", agent handle_redirect_ai_changes)
			server.on_get ("/contact.html", agent handle_redirect_contact)
			server.on_get ("/full-report.html", agent handle_redirect_full_report)
			log_debug ("routes", "  Registered .html redirect routes")

			-- Static files
			server.on_get ("/logo-5.png", agent handle_logo)
			server.on_get ("/favicon.ico", agent handle_favicon)
			log_debug ("routes", "  Registered static file routes")

			-- API routes
			server.on_post ("/api/contact", agent handle_contact_submit)
			log_debug ("routes", "  Registered API routes")
		end

feature {NONE} -- Route Handlers

	handle_landing (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the landing page
		local
			l_page: SSC_LANDING_PAGE
			l_html: STRING
		do
			log_enter ("handle_landing")
			log_info ("handler", "Request for landing page from " + req.path.to_string_8)

			log_debug ("handler", "Creating SSC_LANDING_PAGE...")
			create l_page.make
			log_debug ("handler", "SSC_LANDING_PAGE created, calling to_html...")

			l_html := l_page.to_html
			log_info ("handler", "Landing page generated: " + l_html.count.out + " bytes")

			log_debug ("handler", "Sending HTML response...")
			res.send_html (l_html)
			log_exit ("handle_landing")
		end

	handle_get_started (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the get started page
		local
			l_page: SSC_GET_STARTED_PAGE
		do
			log_info ("handler", "Request for /get-started")
			create l_page.make
			res.send_html (l_page.to_html)
		end

	handle_portfolio (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the portfolio page
		local
			l_page: SSC_PORTFOLIO_PAGE
		do
			log_info ("handler", "Request for /portfolio")
			create l_page.make
			res.send_html (l_page.to_html)
		end

	handle_dbc (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the design by contract page
		local
			l_page: SSC_DBC_PAGE
		do
			log_info ("handler", "Request for /design-by-contract")
			create l_page.make
			res.send_html (l_page.to_html)
		end

	handle_workflow (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the workflow page
		local
			l_page: SSC_WORKFLOW_PAGE
		do
			log_info ("handler", "Request for /workflow")
			create l_page.make
			res.send_html (l_page.to_html)
		end

	handle_analysis (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the competitive analysis page
		local
			l_page: SSC_ANALYSIS_PAGE
			l_html: STRING
		do
			log_info ("handler", "Request for /analysis")
			log_debug ("handler", "  Creating SSC_ANALYSIS_PAGE...")
			create l_page.make
			log_debug ("handler", "  Calling to_html...")
			l_html := l_page.to_html
			log_debug ("handler", "  Generated " + l_html.count.out + " bytes")
			res.send_html (l_html)
		ensure
			-- Contract: handler completed (if we get here, it worked)
		end

	handle_business_case (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the business case page
		local
			l_page: SSC_BUSINESS_CASE_PAGE
		do
			log_info ("handler", "Request for /business-case")
			create l_page.make
			res.send_html (l_page.to_html)
		end

	handle_why_eiffel (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the why eiffel page
		local
			l_page: SSC_WHY_EIFFEL_PAGE
		do
			log_info ("handler", "Request for /why-eiffel")
			create l_page.make
			res.send_html (l_page.to_html)
		end

	handle_probable (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the probable to provable page
		local
			l_page: SSC_PROBABLE_PAGE
		do
			log_info ("handler", "Request for /probable-to-provable")
			create l_page.make
			res.send_html (l_page.to_html)
		end

	handle_old_way (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the old way page
		local
			l_page: SSC_OLD_WAY_PAGE
		do
			log_info ("handler", "Request for /old-way")
			create l_page.make
			res.send_html (l_page.to_html)
		end

	handle_ai_changes (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the AI changes page
		local
			l_page: SSC_AI_CHANGES_PAGE
		do
			log_info ("handler", "Request for /ai-changes")
			create l_page.make
			res.send_html (l_page.to_html)
		end

	handle_contact (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the contact page
		local
			l_page: SSC_CONTACT_PAGE
		do
			log_info ("handler", "Request for /contact")
			create l_page.make
			res.send_html (l_page.to_html)
		end

	handle_full_report (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the full competitive analysis report page
		local
			l_page: SSC_FULL_REPORT_PAGE
		do
			log_info ("handler", "Request for /full-report")
			create l_page.make
			res.send_html (l_page.to_html)
		end

feature {NONE} -- Static File Handlers

	handle_logo (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the logo-5.png file
		do
			log_info ("static", "Request for /logo-5.png")
			serve_png_file ("logo-5.png", res)
		end

	handle_favicon (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve favicon (using logo-5.png as PNG favicon)
		do
			log_info ("static", "Request for /favicon.ico")
			serve_png_file ("logo-5.png", res)
		end

	serve_png_file (a_filename: STRING; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve a PNG file from deploy folder or docs folder
		local
			l_file: RAW_FILE
			l_content: STRING
			l_paths: ARRAY [STRING]
			l_found: BOOLEAN
		do
			-- Try multiple paths: deploy folder (production), docs folder (dev), current dir
			l_paths := <<"deploy/" + a_filename, a_filename, "docs/" + a_filename>>
			across l_paths as l_path until l_found loop
				create l_file.make_with_name (l_path)
				if l_file.exists and then l_file.is_readable then
					l_file.open_read
					create l_content.make (l_file.count)
					l_file.read_stream (l_file.count)
					l_content := l_file.last_string
					l_file.close
					res.send_binary (l_content, "image/png")
					l_found := True
					log_debug ("static", "Served " + a_filename + " from " + l_path)
				end
			end
			if not l_found then
				res.send_not_found ("File not found: " + a_filename)
				log_info ("static", "File not found: " + a_filename)
			end
		end

feature {NONE} -- Redirect Handlers

	handle_redirect_home (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Redirect to home
		do
			log_debug ("redirect", "/index.html -> /")
			res.send_redirect ("/")
		end

	handle_redirect_get_started (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Redirect to get-started
		do
			log_debug ("redirect", "/get-started.html -> /get-started")
			res.send_redirect ("/get-started")
		end

	handle_redirect_portfolio (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Redirect to portfolio
		do
			log_debug ("redirect", "/portfolio.html -> /portfolio")
			res.send_redirect ("/portfolio")
		end

	handle_redirect_dbc (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Redirect to design-by-contract
		do
			log_debug ("redirect", "/design-by-contract.html -> /design-by-contract")
			res.send_redirect ("/design-by-contract")
		end

	handle_redirect_workflow (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Redirect to workflow
		do
			log_debug ("redirect", "/workflow.html -> /workflow")
			res.send_redirect ("/workflow")
		end

	handle_redirect_analysis (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Redirect to analysis
		do
			log_debug ("redirect", "/analysis.html -> /analysis")
			res.send_redirect ("/analysis")
		end

	handle_redirect_business_case (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Redirect to business-case
		do
			log_debug ("redirect", "/business-case.html -> /business-case")
			res.send_redirect ("/business-case")
		end

	handle_redirect_why_eiffel (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Redirect to why-eiffel
		do
			log_debug ("redirect", "/why-eiffel.html -> /why-eiffel")
			res.send_redirect ("/why-eiffel")
		end

	handle_redirect_probable (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Redirect to probable-to-provable
		do
			log_debug ("redirect", "/probable-to-provable.html -> /probable-to-provable")
			res.send_redirect ("/probable-to-provable")
		end

	handle_redirect_old_way (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Redirect to old-way
		do
			log_debug ("redirect", "/old-way.html -> /old-way")
			res.send_redirect ("/old-way")
		end

	handle_redirect_ai_changes (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Redirect to ai-changes
		do
			log_debug ("redirect", "/ai-changes.html -> /ai-changes")
			res.send_redirect ("/ai-changes")
		end

	handle_redirect_contact (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Redirect to contact
		do
			log_debug ("redirect", "/contact.html -> /contact")
			res.send_redirect ("/contact")
		end

	handle_redirect_full_report (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Redirect to full-report
		do
			log_debug ("redirect", "/full-report.html -> /full-report")
			res.send_redirect ("/full-report")
		end

feature {NONE} -- API Handlers

	handle_contact_submit (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Handle contact form submission with rate limiting and database storage.
		local
			l_json: SIMPLE_JSON
			l_body: detachable SIMPLE_JSON_VALUE
			l_name, l_email, l_subject, l_message, l_ip: STRING
			l_body_32: STRING_32
			l_contact_id: INTEGER_64
		do
			log_info ("api", "Contact form submission received")
			log_debug ("api", "Body length: " + req.body.count.out)

			-- Extract client IP for rate limiting and logging
			l_ip := extract_client_ip (req)

			-- Check rate limit (5 submissions per hour per IP)
			if is_rate_limited (l_ip) then
				log_info ("api", "Rate limited: " + l_ip)
				res.set_status (429) -- Too Many Requests
				res.send_json ("{%"success%": false, %"error%": %"Too many submissions. Please try again later.%"}")
			elseif req.body.is_empty then
				log_info ("api", "Empty request body")
				res.send_json ("{%"success%": false, %"error%": %"Empty request body%"}")
			else
				create l_json
				create l_body_32.make_from_string (req.body)
				l_body := l_json.parse (l_body_32)

				if attached l_body as l_val and then l_val.is_object then
					if attached l_val.as_object as l_obj then
						-- Extract and sanitize form fields
						l_name := extract_and_sanitize_field (l_obj, "name", 100)
						l_email := extract_and_sanitize_email (l_obj, "email", 254)
						l_subject := extract_and_sanitize_field (l_obj, "subject", 100)
						l_message := extract_and_sanitize_field (l_obj, "message", 5000)

						-- Validate required fields
						if l_name.is_empty or l_email.is_empty or l_message.is_empty then
							res.send_json ("{%"success%": false, %"error%": %"Name, email, and message are required.%"}")
						elseif not is_valid_email (l_email) then
							res.send_json ("{%"success%": false, %"error%": %"Please provide a valid email address.%"}")
						else
							-- Default subject if empty
							if l_subject.is_empty then
								l_subject := "general"
							end

							-- Save to database first (durable storage)
							l_contact_id := database.save_contact (l_name, l_email, l_subject, l_message, l_ip)
							log_info ("contact", "Saved to database with ID: " + l_contact_id.out)

							-- Record submission for rate limiting
							record_submission (l_ip)

							-- Send email notification (best effort)
							if send_contact_email (l_name, l_email, l_subject, l_message) then
								log_info ("contact", "Email sent successfully")
							else
								log_info ("contact", "Email sending failed, but form data saved to database")
							end

							-- Always return success if saved to database
							res.send_json ("{%"success%": true, %"message%": %"Thank you for your message!%"}")
						end
					else
						res.send_json ("{%"success%": false, %"error%": %"Invalid request format%"}")
					end
				else
					log_info ("api", "Failed to parse contact form body")
					res.send_json ("{%"success%": false, %"error%": %"Invalid JSON%"}")
				end
			end
		end

feature {NONE} -- Helpers

	placeholder_page (a_title, a_message: STRING): STRING
			-- Generate a simple placeholder page
		do
			create Result.make (500)
			Result.append ("<!DOCTYPE html><html><head>")
			Result.append ("<title>" + a_title + " | simple_showcase</title>")
			Result.append ("<script src=%"https://cdn.tailwindcss.com%"></script>")
			Result.append ("</head><body class=%"bg-[#0c0b0b] text-[#fdfcfa] min-h-screen flex items-center justify-center%">")
			Result.append ("<div class=%"text-center%">")
			Result.append ("<h1 class=%"text-4xl font-light mb-4%">" + a_title + "</h1>")
			Result.append ("<p class=%"opacity-60%">" + a_message + "</p>")
			Result.append ("<p class=%"mt-8%"><a href=%"/%" class=%"text-blue-400 hover:underline%">← Back to home</a></p>")
			Result.append ("</div></body></html>")
		end

feature {NONE} -- Email

	send_contact_email (a_name, a_email, a_subject, a_message: STRING): BOOLEAN
			-- Send contact form notification via SMTP using curl.
			-- Tries each configured endpoint in order until one succeeds.
			-- Returns True if email was sent successfully.
		local
			l_subject_line: STRING
			l_safe_name, l_safe_email, l_safe_subject, l_safe_message: STRING
		do
			-- Check if SMTP password is configured
			if config.smtp_password.is_empty or config.smtp_password.same_string ("YOUR_APP_PASSWORD_HERE") then
				log_info ("email", "SMTP password not configured, skipping email")
				Result := False
			else
				-- Sanitize all user input
				l_safe_name := sanitize_for_email (a_name)
				l_safe_email := sanitize_email_address (a_email)
				l_safe_subject := sanitize_for_email (a_subject)
				l_safe_message := a_message  -- Message body is in here-string, less risky

				-- Build email subject
				l_subject_line := "[Simple Showcase Contact] " + l_safe_subject + " from " + l_safe_name

				log_debug ("email", "Attempting to send email via " + config.smtp_endpoints.count.out + " configured endpoints...")

				-- Try each endpoint until one succeeds
				across config.smtp_endpoints as l_endpoint until Result loop
					Result := try_send_email (
						l_endpoint.host,
						l_endpoint.port,
						l_endpoint.protocol,
						l_endpoint.ssl_reqd,
						l_subject_line,
						l_safe_name,
						l_safe_email,
						l_safe_subject,
						l_safe_message
					)
				end

				if not Result then
					log_info ("email", "All SMTP endpoints failed")
				end
			end
		end

	try_send_email (a_host: STRING; a_port: INTEGER; a_protocol: STRING; a_ssl_reqd: BOOLEAN;
			a_subject_line, a_safe_name, a_safe_email, a_safe_subject, a_safe_message: STRING): BOOLEAN
			-- Try to send email via a single SMTP endpoint.
			-- Returns True if successful.
		local
			l_process: SIMPLE_PROCESS_HELPER
			l_cmd: STRING_32
			l_output: STRING_32
			l_url: STRING
		do
			-- Build SMTP URL
			l_url := a_protocol + "://" + a_host + ":" + a_port.out
			log_debug ("email", "Trying endpoint: " + l_url)

			-- Execute curl with email body piped via PowerShell
			-- Using here-string for body to minimize injection risk
			create l_cmd.make (1000)
			l_cmd.append ("powershell -Command %"")
			l_cmd.append ("$body = @'%N")
			l_cmd.append ("From: " + config.contact_email + "%N")
			l_cmd.append ("To: " + config.contact_email + "%N")
			l_cmd.append ("Subject: " + a_subject_line + "%N")
			l_cmd.append ("Reply-To: " + a_safe_email + "%N")
			l_cmd.append ("%N")
			l_cmd.append ("Contact from: " + a_safe_name + " <" + a_safe_email + ">%N")
			l_cmd.append ("Subject: " + a_safe_subject + "%N")
			l_cmd.append ("%N")
			l_cmd.append (escape_for_powershell (a_safe_message) + "%N")
			l_cmd.append ("'@%N")
			l_cmd.append ("$body | & './curl.exe' --silent --show-error ")
			l_cmd.append ("--url '" + l_url + "' ")
			if a_ssl_reqd then
				l_cmd.append ("--ssl-reqd ")
			end
			l_cmd.append ("--mail-from '" + config.contact_email + "' ")
			l_cmd.append ("--mail-rcpt '" + config.contact_email + "' ")
			l_cmd.append ("--user '" + config.contact_email + ":" + config.smtp_password + "' ")
			l_cmd.append ("-T -%"")

			-- Note: Not logging full command to avoid exposing SMTP password
			log_debug ("email", "Executing curl to " + l_url)

			create l_process
			l_output := l_process.output_of_command (l_cmd, Void)

			log_debug ("email", "Output length: " + l_output.count.out)
			if not l_output.is_empty then
				log_debug ("email", "Output: " + l_output.to_string_8)
			end

			if l_output.is_empty then
				log_info ("email", "Email sent successfully via " + l_url)
				Result := True
			else
				log_debug ("email", "Endpoint " + l_url + " failed: " + l_output.to_string_8)
				Result := False
			end
		end

	escape_for_powershell (a_text: STRING): STRING
			-- Escape special characters for PowerShell here-string
		do
			create Result.make_from_string (a_text)
			-- Here-strings in PowerShell don't need much escaping,
			-- but we should handle any edge cases
			Result.replace_substring_all ("'@", "'`@")  -- Escape potential here-string terminator
		end

feature {NONE} -- Rate Limiting

	submission_tracker: HASH_TABLE [ARRAYED_LIST [INTEGER_64], STRING]
			-- Track submission timestamps by IP address
			-- Key: IP address, Value: List of Unix timestamps
		once
			create Result.make (100)
		end

	rate_limit_max_submissions: INTEGER = 5
			-- Maximum submissions per rate limit window

	rate_limit_window_seconds: INTEGER = 3600
			-- Rate limit window: 1 hour

	is_rate_limited (a_ip: STRING): BOOLEAN
			-- Check if IP has exceeded rate limit
		local
			l_timestamps: detachable ARRAYED_LIST [INTEGER_64]
			l_now: INTEGER_64
			l_cutoff: INTEGER_64
			l_recent_count: INTEGER
		do
			l_now := current_unix_timestamp
			l_cutoff := l_now - rate_limit_window_seconds

			l_timestamps := submission_tracker.item (a_ip)
			if attached l_timestamps then
				-- Count submissions within window
				across l_timestamps as ts loop
					if ts > l_cutoff then
						l_recent_count := l_recent_count + 1
					end
				end
				Result := l_recent_count >= rate_limit_max_submissions
			end
		end

	record_submission (a_ip: STRING)
			-- Record a submission for rate limiting
		local
			l_timestamps: ARRAYED_LIST [INTEGER_64]
			l_now: INTEGER_64
			l_cutoff: INTEGER_64
		do
			l_now := current_unix_timestamp
			l_cutoff := l_now - rate_limit_window_seconds

			if attached submission_tracker.item (a_ip) as l_existing then
				-- Prune old entries and add new one
				from l_existing.start until l_existing.after loop
					if l_existing.item <= l_cutoff then
						l_existing.remove
					else
						l_existing.forth
					end
				end
				l_existing.extend (l_now)
			else
				-- New IP
				create l_timestamps.make (10)
				l_timestamps.extend (l_now)
				submission_tracker.force (l_timestamps, a_ip)
			end
		end

	current_unix_timestamp: INTEGER_64
			-- Current time as Unix timestamp (seconds since epoch)
		local
			l_now: DATE_TIME
			l_epoch: DATE_TIME
		do
			create l_now.make_now
			create l_epoch.make (1970, 1, 1, 0, 0, 0)
			Result := l_now.definite_duration (l_epoch).seconds_count
		end

feature -- Form Validation (public for testing)

	extract_and_sanitize_field (a_obj: SIMPLE_JSON_OBJECT; a_field: STRING; a_max_length: INTEGER): STRING
			-- Extract and sanitize a JSON string field
		require
			obj_attached: a_obj /= Void
			field_not_empty: not a_field.is_empty
			max_positive: a_max_length > 0
		do
			if attached a_obj.item (a_field) as l_val and then l_val.is_string then
				Result := l_val.as_string_32.to_string_8
				-- Truncate if needed
				if Result.count > a_max_length then
					Result := Result.substring (1, a_max_length)
				end
				-- Remove control characters
				Result := remove_control_chars (Result)
			else
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
			within_limit: Result.count <= a_max_length
		end

	extract_and_sanitize_email (a_obj: SIMPLE_JSON_OBJECT; a_field: STRING; a_max_length: INTEGER): STRING
			-- Extract and sanitize an email field (more restrictive)
		require
			obj_attached: a_obj /= Void
			field_not_empty: not a_field.is_empty
			max_positive: a_max_length > 0
		do
			Result := extract_and_sanitize_field (a_obj, a_field, a_max_length)
			Result := sanitize_email_address (Result)
		ensure
			result_attached: Result /= Void
		end

	remove_control_chars (a_string: STRING): STRING
			-- Remove control characters (0x00-0x1F except tab/newline/CR)
		local
			i: INTEGER
			c: CHARACTER
		do
			create Result.make (a_string.count)
			from i := 1 until i > a_string.count loop
				c := a_string.item (i)
				-- Allow printable chars, tab (%T = 9), newline (%N = 10), carriage return (%R = 13)
				if c.code >= 32 or c.code = 9 or c.code = 10 or c.code = 13 then
					Result.append_character (c)
				end
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
			no_dangerous_control_chars: not has_dangerous_control_chars (Result)
			length_not_increased: Result.count <= a_string.count
		end

	is_valid_email (a_email: STRING): BOOLEAN
			-- Basic email format validation.
			-- Checks: length 5-254, has @, has . after @, local part exists, domain exists
		local
			l_at_pos, l_dot_pos: INTEGER
		do
			if a_email.count >= 5 and a_email.count <= 254 then
				l_at_pos := a_email.index_of ('@', 1)
				if l_at_pos > 1 and l_at_pos < a_email.count - 1 then
					l_dot_pos := a_email.last_index_of ('.', a_email.count)
					Result := l_dot_pos > l_at_pos + 1 and l_dot_pos < a_email.count
				end
			end
		ensure
			-- Definition: Result implies all structural requirements met
			valid_implies_has_at: Result implies a_email.has ('@')
			valid_implies_has_dot_after_at: Result implies
				a_email.last_index_of ('.', a_email.count) > a_email.index_of ('@', 1)
			valid_implies_length_ok: Result implies (a_email.count >= 5 and a_email.count <= 254)
		end

feature -- Sanitization (exported for testing)

	sanitize_for_email (a_text: STRING): STRING
			-- Sanitize text to prevent email header injection and command injection.
			-- Removes newlines (header injection) and shell metacharacters.
		do
			create Result.make_from_string (a_text)
			Result.replace_substring_all ("%N", " ")
			Result.replace_substring_all ("%R", " ")
			Result.replace_substring_all ("'", "")
			Result.replace_substring_all ("%"", "")
			Result.replace_substring_all ("`", "")
			Result.replace_substring_all ("$", "")
			Result.replace_substring_all ("\", "")
			Result.replace_substring_all ("|", "")
			Result.replace_substring_all ("&", "")
			Result.replace_substring_all (";", "")
			Result.replace_substring_all ("<", "")
			Result.replace_substring_all (">", "")
		ensure
			result_attached: Result /= Void
			no_newlines: not Result.has ('%N') and not Result.has ('%R')
			no_shell_single_quote: not Result.has ('%'')
			no_shell_double_quote: not Result.has ('%"')
			no_shell_backtick: not Result.has ('`')
			no_shell_dollar: not Result.has ('$')
			no_shell_pipe: not Result.has ('|')
			no_shell_ampersand: not Result.has ('&')
			no_shell_semicolon: not Result.has (';')
			no_shell_angle_brackets: not Result.has ('<') and not Result.has ('>')
		end

	sanitize_email_address (a_email: STRING): STRING
			-- Sanitize email address - only allow valid email characters.
			-- Whitelist approach: only alphanumeric, @, ., _, -, +
		local
			i: INTEGER
			c: CHARACTER
		do
			create Result.make (a_email.count)
			from i := 1 until i > a_email.count loop
				c := a_email.item (i)
				if is_safe_email_char (c) then
					Result.append_character (c)
				end
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
			only_safe_chars: across Result as ic all is_safe_email_char (ic) end
			length_not_increased: Result.count <= a_email.count
		end

feature -- Contract helpers (exported for testing)

	has_dangerous_control_chars (a_string: STRING): BOOLEAN
			-- Does string contain dangerous control characters (0x00-0x08, 0x0B, 0x0C, 0x0E-0x1F)?
			-- Allows: tab (9), newline (10), carriage return (13)
		local
			i, c: INTEGER
		do
			from i := 1 until i > a_string.count or Result loop
				c := a_string.item (i).code
				if c >= 0 and c <= 8 then
					Result := True
				elseif c = 11 or c = 12 then -- vertical tab, form feed
					Result := True
				elseif c >= 14 and c <= 31 then
					Result := True
				end
				i := i + 1
			end
		end

	is_safe_email_char (a_char: CHARACTER): BOOLEAN
			-- Is character safe for email addresses?
		do
			Result := a_char.is_alpha or a_char.is_digit or
				a_char = '@' or a_char = '.' or a_char = '_' or a_char = '-' or a_char = '+'
		end

feature {NONE} -- IP Extraction

	extract_client_ip (a_request: SIMPLE_WEB_SERVER_REQUEST): STRING
			-- Extract client IP, checking for proxy headers (Cloudflare)
		local
			l_forwarded: detachable STRING_8
		do
			-- Check X-Forwarded-For first (Cloudflare/proxy)
			l_forwarded := a_request.header ("X-Forwarded-For")
			if attached l_forwarded and then not l_forwarded.is_empty then
				-- X-Forwarded-For can contain multiple IPs: "client, proxy1, proxy2"
				if l_forwarded.has (',') then
					Result := l_forwarded.split (',').first
					Result.left_adjust
					Result.right_adjust
				else
					Result := l_forwarded
				end
			elseif attached a_request.header ("X-Real-IP") as l_real_ip and then not l_real_ip.is_empty then
				Result := l_real_ip
			else
				-- Fall back to direct connection IP
				if not a_request.is_mock and then attached a_request.wsf_request as l_wsf then
					if attached l_wsf.remote_addr as l_addr then
						Result := l_addr.to_string_8
					else
						Result := "unknown"
					end
				else
					Result := "unknown"
				end
			end
		ensure
			result_attached: Result /= Void
		end

end
