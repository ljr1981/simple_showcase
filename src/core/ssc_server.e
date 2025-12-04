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
	make_with_config

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

			create server.make (config.port)
			log_info ("server", "Server created on port " + config.port.out)

			register_routes
			log_info ("server", "Routes registered")

			print ("%NSimple Showcase Server%N")
			print ("=======================%N")
			print ("Mode: " + config.mode + "%N")
			print ("Open browser to: " + config.base_url + "%N%N")

			server.use_logging
			log_info ("server", "Logging middleware enabled")
			log_info ("server", "Calling server.start (blocking)...")
			server.start
		end

feature -- Server

	server: SIMPLE_WEB_SERVER
			-- HTTP server instance

	config: SSC_CONFIG
			-- Server configuration

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
			log_debug ("routes", "  Registered 11 sub-page routes")

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
			log_debug ("routes", "  Registered .html redirect routes")

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
		do
			log_info ("handler", "Request for /analysis")
			create l_page.make
			res.send_html (l_page.to_html)
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

feature {NONE} -- API Handlers

	handle_contact_submit (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Handle contact form submission.
			-- TODO: Add rate limiting for production deployment to prevent spam/DoS.
			-- Consider: IP-based throttling (e.g., 5 requests per minute per IP)
			-- or CAPTCHA integration for high-traffic scenarios.
		local
			l_json: SIMPLE_JSON
			l_body: detachable SIMPLE_JSON_VALUE
			l_name, l_email, l_subject, l_message: STRING
			l_body_32: STRING_32
		do
			log_info ("api", "Contact form submission received")
			log_debug ("api", "Body length: " + req.body.count.out)
			-- Note: Not logging full body to avoid exposing user PII in logs

			if req.body.is_empty then
				log_info ("api", "Empty request body")
				res.send_json ("{%"success%": false, %"error%": %"Empty request body%"}")
			else
				create l_json
				create l_body_32.make_from_string (req.body)
				l_body := l_json.parse (l_body_32)

				if attached l_body as l_val and then l_val.is_object then
					if attached l_val.as_object as l_obj then
						-- Extract form fields
						if attached l_obj.item ("name") as l_n and then l_n.is_string then
							l_name := l_n.as_string_32.to_string_8
						else
							l_name := ""
						end
						if attached l_obj.item ("email") as l_e and then l_e.is_string then
							l_email := l_e.as_string_32.to_string_8
						else
							l_email := ""
						end
						if attached l_obj.item ("subject") as l_s and then l_s.is_string then
							l_subject := l_s.as_string_32.to_string_8
						else
							l_subject := "general"
						end
						if attached l_obj.item ("message") as l_m and then l_m.is_string then
							l_message := l_m.as_string_32.to_string_8
						else
							l_message := ""
						end

						-- Server-side length validation (defense in depth)
						if l_name.count > 100 then
							l_name := l_name.substring (1, 100)
						end
						if l_email.count > 254 then
							l_email := l_email.substring (1, 254)
						end
						if l_subject.count > 100 then
							l_subject := l_subject.substring (1, 100)
						end
						if l_message.count > 5000 then
							l_message := l_message.substring (1, 5000)
						end

						-- Log the submission (minimal info to avoid PII in logs)
						log_info ("contact", "Submission received, subject: " + l_subject)

						-- Send email notification
						if send_contact_email (l_name, l_email, l_subject, l_message) then
							log_info ("contact", "Email sent successfully")
							res.send_json ("{%"success%": true, %"message%": %"Thank you for your message!%"}")
						else
							log_info ("contact", "Email sending failed, but form data logged")
							-- Still return success since we logged the message
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

	sanitize_for_email (a_text: STRING): STRING
			-- Sanitize text to prevent email header injection and command injection
		do
			create Result.make_from_string (a_text)
			-- Remove newlines (prevent header injection)
			Result.replace_substring_all ("%N", " ")
			Result.replace_substring_all ("%R", " ")
			-- Remove shell metacharacters
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
		end

	sanitize_email_address (a_email: STRING): STRING
			-- Sanitize email address - only allow valid email characters
		local
			i: INTEGER
			c: CHARACTER
		do
			create Result.make (a_email.count)
			from i := 1 until i > a_email.count loop
				c := a_email.item (i)
				-- Only allow alphanumeric, @, ., _, -, +
				if c.is_alpha or c.is_digit or c = '@' or c = '.' or c = '_' or c = '-' or c = '+' then
					Result.append_character (c)
				end
				i := i + 1
			end
		end

end
