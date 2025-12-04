note
	description: "[
		Simple Showcase HTTP Server.

		Serves the SSC website using simple_web's HTTP server.
		All pages are generated dynamically from Eiffel classes.

		Usage:
			Run the executable, then browse to http://localhost:8080
	]"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_SERVER

create
	make

feature {NONE} -- Initialization

	make
			-- Create and start the server
		do
			create server.make (8080)
			register_routes
			print ("%NSimple Showcase Server%N")
			print ("=======================%N")
			print ("Open browser to: http://localhost:8080%N%N")
			server.use_logging
			server.start
		end

feature -- Server

	server: SIMPLE_WEB_SERVER
			-- HTTP server instance

feature {NONE} -- Route Registration

	register_routes
			-- Register all page routes
		do
			-- Landing page
			server.on_get ("/", agent handle_landing)

			-- Sub-pages (as we add them)
			server.on_get ("/get-started", agent handle_get_started)
			server.on_get ("/portfolio", agent handle_portfolio)
			server.on_get ("/business-case", agent handle_business_case)

			-- Redirect .html extensions to clean URLs
			server.on_get ("/index.html", agent handle_redirect ("/"))
			server.on_get ("/get-started.html", agent handle_redirect ("/get-started"))
			server.on_get ("/portfolio.html", agent handle_redirect ("/portfolio"))
			server.on_get ("/business-case.html", agent handle_redirect ("/business-case"))
		end

feature {NONE} -- Route Handlers

	handle_landing (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the landing page
		local
			l_page: SSC_LANDING_PAGE
		do
			create l_page.make
			res.send_html (l_page.to_html)
		end

	handle_get_started (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the get started page (placeholder)
		do
			res.send_html (placeholder_page ("Get Started", "Coming soon..."))
		end

	handle_portfolio (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the portfolio page (placeholder)
		do
			res.send_html (placeholder_page ("Project Portfolio", "Coming soon..."))
		end

	handle_business_case (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Serve the business case page (placeholder)
		do
			res.send_html (placeholder_page ("Business Case", "Coming soon..."))
		end

	handle_redirect (a_target: STRING): PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE]
			-- Create redirect handler for clean URLs
		do
			Result := agent (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE; target: STRING)
				do
					res.send_redirect (target)
				end (?, ?, a_target)
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

end
