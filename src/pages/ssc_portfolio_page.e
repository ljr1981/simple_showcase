note
	description: "Portfolio page - Evidence of all libraries and apps built"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_PORTFOLIO_PAGE

inherit
	SSC_SUB_PAGE
		redefine
			related_pages
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize page
		do
			-- Nothing needed
		end

feature -- Access

	page_title: STRING = "The Project Portfolio"

	page_subtitle: STRING = "25 libraries + 4 applications. All on GitHub. All documented. All tested."

	page_url: STRING = "/portfolio"

feature -- Content

	page_content: STRING
			-- Main page content
		do
			create Result.make (30000)

			-- Summary Stats
			Result.append ("<div class=%"grid grid-cols-2 md:grid-cols-4 gap-4 mb-12%">%N")
			Result.append (stat_box ("25", "libraries"))
			Result.append (stat_box ("4", "apps"))
			Result.append (stat_box ("1,200+", "tests"))
			Result.append (stat_box ("13", "days"))
			Result.append ("</div>%N")

			-- Christmas Sprint Highlight
			Result.append (christmas_sprint_section)
			Result.append (divider)

			-- Foundation Layer
			Result.append (layer_heading ("Foundation Layer", "Data encoding, hashing, validation, parsing"))
			Result.append ("<div class=%"grid md:grid-cols-2 lg:grid-cols-3 gap-4 mb-8%">%N")
			Result.append (library_card_with_docs ("simple_json", "Full JSON parsing and serialization. Type-safe, contract-verified.",
				"11,400", "215", "https://ljr1981.github.io/simple_json/"))
			Result.append (library_card_with_docs ("simple_base64", "RFC 4648 Base64 encoding and decoding.",
				"", "", "https://ljr1981.github.io/simple_base64/"))
			Result.append (library_card_with_docs ("simple_hash", "MD5, SHA-1, SHA-256, SHA-512 hashing algorithms.",
				"", "", "https://ljr1981.github.io/simple_hash/"))
			Result.append (library_card_with_docs ("simple_uuid", "UUID v4 generation with proper randomness.",
				"", "", "https://ljr1981.github.io/simple_uuid/"))
			Result.append (library_card_with_docs ("simple_csv", "CSV parsing and generation with proper escaping.",
				"", "", "https://ljr1981.github.io/simple_csv/"))
			Result.append (library_card_with_docs ("simple_markdown", "Markdown to HTML conversion.",
				"", "", "https://ljr1981.github.io/simple_markdown/"))
			Result.append (library_card_with_docs ("simple_validation", "Input validation rules and combinators.",
				"", "", "https://ljr1981.github.io/simple_validation/"))
			Result.append (library_card_with_docs ("simple_process", "Process execution and output capture.",
				"500", "4", "https://ljr1981.github.io/simple_process/"))
			Result.append (library_card_with_docs ("simple_randomizer", "Random data generation for testing.",
				"1,100", "27", "https://ljr1981.github.io/simple_randomizer/"))
			Result.append ("</div>%N")
			Result.append (divider)

			-- Service Layer
			Result.append (layer_heading ("Service Layer", "Authentication, database, web services, caching, logging"))
			Result.append ("<div class=%"grid md:grid-cols-2 lg:grid-cols-3 gap-4 mb-8%">%N")
			Result.append (library_card_with_docs ("simple_sql", "SQLite wrapper with fluent query builder and contract safety.",
				"17,200", "339", "https://ljr1981.github.io/simple_sql/"))
			Result.append (library_card_with_docs ("simple_jwt", "JWT token creation and verification.",
				"", "", "https://ljr1981.github.io/simple_jwt/"))
			Result.append (library_card_with_docs ("simple_smtp", "Email sending via SMTP.",
				"", "", "https://ljr1981.github.io/simple_smtp/"))
			Result.append (library_card_with_docs ("simple_cors", "CORS header handling for web APIs.",
				"", "", "https://ljr1981.github.io/simple_cors/"))
			Result.append (library_card_with_docs ("simple_rate_limiter", "Token bucket rate limiting.",
				"", "", "https://ljr1981.github.io/simple_rate_limiter/"))
			Result.append (library_card_with_docs ("simple_template", "Template rendering with variable substitution.",
				"", "", "https://ljr1981.github.io/simple_template/"))
			Result.append (library_card_with_docs ("simple_websocket", "WebSocket protocol implementation.",
				"", "", "https://ljr1981.github.io/simple_websocket/"))
			Result.append (library_card_with_docs ("simple_cache", "LRU cache with TTL support.",
				"", "", "https://ljr1981.github.io/simple_cache/"))
			Result.append (library_card_with_docs ("simple_logger", "Structured JSON logging with child loggers.",
				"", "", "https://ljr1981.github.io/simple_logger/"))
			Result.append ("</div>%N")
			Result.append (divider)

			-- Web Layer
			Result.append (layer_heading ("Web Layer", "HTTP server/client, HTML generation, frontend integration"))
			Result.append ("<div class=%"grid md:grid-cols-3 gap-4 mb-8%">%N")
			Result.append (library_card_with_docs ("simple_web", "HTTP client and server with routing and middleware.",
				"8,000", "95", "https://ljr1981.github.io/simple_web/"))
			Result.append (library_card_with_docs ("simple_htmx", "Fluent HTML/HTMX builder with type safety.",
				"4,200", "40", "https://ljr1981.github.io/simple_htmx/"))
			Result.append (library_card_with_docs ("simple_alpine", "Alpine.js directive builder.",
				"3,200", "103", "https://ljr1981.github.io/simple_alpine/"))
			Result.append ("</div>%N")
			Result.append (divider)

			-- API Facades
			Result.append (layer_heading ("API Facades", "Unified access to library layers"))
			Result.append ("<div class=%"grid md:grid-cols-3 gap-4 mb-8%">%N")
			Result.append (library_card_with_docs ("simple_foundation_api", "Unified access to all foundation libraries.",
				"", "", "https://ljr1981.github.io/simple_foundation_api/"))
			Result.append (library_card_with_docs ("simple_service_api", "Unified access to all service libraries.",
				"", "", "https://ljr1981.github.io/simple_service_api/"))
			Result.append (library_card_with_docs ("simple_app_api", "Unified access to entire simple_* stack.",
				"", "", "https://ljr1981.github.io/simple_app_api/"))
			Result.append ("</div>%N")
			Result.append (divider)

			-- Applications
			Result.append (layer_heading ("Applications", "Tools and showcase apps built with simple_* libraries"))
			Result.append ("<div class=%"grid md:grid-cols-2 gap-4 mb-8%">%N")
			Result.append (app_card ("simple_showcase", "This site! Documentation showcase for the simple_* ecosystem.",
				"https://ljr1981.github.io/simple_showcase/"))
			Result.append (app_card ("simple_ci", "CI/CD automation tool for Eiffel projects.",
				"https://ljr1981.github.io/simple_ci/"))
			Result.append (app_card ("simple_gui_designer", "Visual GUI specification designer.",
				"https://ljr1981.github.io/simple_gui_designer/"))
			Result.append (app_card ("simple_ai_client", "AI API client application.",
				""))
			Result.append ("</div>%N")
			Result.append (divider)

			-- Run Tests
			Result.append (section_heading ("Verify It Yourself"))
			Result.append (paragraph ("Don't take our word for it. Clone any repo, run the tests."))
			Result.append (code_block (
				"git clone https://github.com/ljr1981/simple_json%N" +
				"cd simple_json%N" +
				"# Set environment variables per README%N" +
				"# Run: ec.exe -batch -config simple_json.ecf -target simple_json_tests -c_compile"))
			Result.append (paragraph ("Every test passes. Every contract verified. Every library documented."))
		ensure then
			has_libraries: Result.has_substring ("simple_json")
			has_christmas: Result.has_substring ("Christmas")
		end

feature {NONE} -- Related Pages

	related_pages: HASH_TABLE [STRING, STRING]
			-- Related pages for footer
		do
			create Result.make (3)
			Result.put ("Get Started", "get-started")
			Result.put ("Business Case", "business-case")
			Result.put ("Competitive Analysis", "analysis")
		end

feature {NONE} -- Content Helpers

	christmas_sprint_section: STRING
			-- The Christmas Sprint highlight
		do
			create Result.make (1500)
			Result.append ("<div class=%"bg-emerald-900/20 border border-emerald-500/30 rounded-lg p-6 mb-8%">%N")
			Result.append ("  <h3 class=%"text-xl font-medium text-emerald-400 mb-4%">The Christmas Sprint</h3>%N")
			Result.append ("  <p class=%"mb-4 opacity-90%">December 5-6, 2025: <strong>14 libraries built in 2 days</strong>.</p>%N")
			Result.append ("  <p class=%"mb-4 opacity-80 text-sm%">11 libraries, ~12,850 lines in 3 days. Traditional estimate: 5-11 months. Multiplier: 40-85x.</p>%N")
			Result.append ("  <div class=%"grid grid-cols-2 md:grid-cols-4 gap-3 mt-4%">%N")
			Result.append ("    <div class=%"text-center%"><div class=%"text-2xl font-bold%">14</div><div class=%"text-xs opacity-60%">libraries</div></div>%N")
			Result.append ("    <div class=%"text-center%"><div class=%"text-2xl font-bold%">2</div><div class=%"text-xs opacity-60%">days</div></div>%N")
			Result.append ("    <div class=%"text-center%"><div class=%"text-2xl font-bold%">13x</div><div class=%"text-xs opacity-60%">faster</div></div>%N")
			Result.append ("    <div class=%"text-center%"><div class=%"text-2xl font-bold%">~1.5h</div><div class=%"text-xs opacity-60%">per library</div></div>%N")
			Result.append ("  </div>%N")
			Result.append ("  <p class=%"mt-4 text-sm opacity-70%">Libraries built: base64, hash, uuid, csv, jwt, smtp, cors, rate_limiter, markdown, template, validation, websocket, cache, logger</p>%N")
			Result.append ("</div>%N")
		end

	layer_heading (a_title, a_description: STRING): STRING
			-- Generate a layer section heading
		require
			title_not_empty: not a_title.is_empty
		do
			create Result.make (300)
			Result.append ("<div class=%"mb-6%">%N")
			Result.append ("  <h3 class=%"text-xl font-medium mb-2%">" + a_title + "</h3>%N")
			if not a_description.is_empty then
				Result.append ("  <p class=%"text-sm opacity-60%">" + a_description + "</p>%N")
			end
			Result.append ("</div>%N")
		end

	library_card_with_docs (a_name, a_description, a_lines, a_tests, a_docs_url: STRING): STRING
			-- Generate a library card with documentation link
		local
			l_github: STRING
		do
			l_github := "https://github.com/ljr1981/" + a_name
			create Result.make (800)
			Result.append ("<div class=%"card%">%N")
			Result.append ("  <h4 class=%"font-mono text-sm font-medium mb-2%">")
			Result.append (external_link (a_name, l_github))
			Result.append ("</h4>%N")
			Result.append ("  <p class=%"text-xs opacity-70 mb-3%">" + a_description + "</p>%N")
			if not a_lines.is_empty or not a_tests.is_empty then
				Result.append ("  <div class=%"flex gap-4 text-xs mb-3%">%N")
				if not a_lines.is_empty then
					Result.append ("    <span><span class=%"opacity-50%">Lines:</span> <strong>" + a_lines + "</strong></span>%N")
				end
				if not a_tests.is_empty then
					Result.append ("    <span><span class=%"opacity-50%">Tests:</span> <strong>" + a_tests + "</strong></span>%N")
				end
				Result.append ("  </div>%N")
			end
			if not a_docs_url.is_empty then
				Result.append ("  <a href=%"" + a_docs_url + "%" target=%"_blank%" class=%"text-xs text-blue-400 hover:underline%">Documentation ↗</a>%N")
			end
			Result.append ("</div>%N")
		end

	app_card (a_name, a_description, a_docs_url: STRING): STRING
			-- Generate an application card
		local
			l_github: STRING
		do
			l_github := "https://github.com/ljr1981/" + a_name
			create Result.make (500)
			Result.append ("<div class=%"card border-l-4 border-purple-500/50%">%N")
			Result.append ("  <h4 class=%"font-mono text-sm font-medium mb-2%">")
			Result.append (external_link (a_name, l_github))
			Result.append ("</h4>%N")
			Result.append ("  <p class=%"text-xs opacity-70 mb-3%">" + a_description + "</p>%N")
			if not a_docs_url.is_empty then
				Result.append ("  <a href=%"" + a_docs_url + "%" target=%"_blank%" class=%"text-xs text-blue-400 hover:underline%">Documentation ↗</a>%N")
			end
			Result.append ("</div>%N")
		end

end
