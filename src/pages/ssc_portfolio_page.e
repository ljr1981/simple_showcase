note
	description: "Portfolio page - Evidence of all libraries built"
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

	page_subtitle: STRING = "Everything built. Everything on GitHub. Everything tested."

	page_url: STRING = "/portfolio"

feature -- Content

	page_content: STRING
			-- Main page content
		do
			create Result.make (15000)

			-- Summary Stats
			Result.append ("<div class=%"grid grid-cols-2 md:grid-cols-4 gap-4 mb-12%">%N")
			Result.append (stat_box ("12", "libraries"))
			Result.append (stat_box ("900+", "tests"))
			Result.append (stat_box ("10", "days"))
			Result.append (stat_box ("1", "person"))
			Result.append ("</div>%N")
			Result.append (divider)

			-- The Libraries
			Result.append (section_heading ("The Libraries"))
			Result.append ("<div class=%"space-y-6%">%N")
			Result.append (library_card ("simple_json", "Full JSON parsing and serialization for Eiffel. Type-safe, contract-verified, production-ready.",
				"11,400", "215", <<
					"Parse JSON from strings or files",
					"Serialize Eiffel objects to JSON",
					"Type-safe accessors",
					"Friction-free helper patterns"
				>>))
			Result.append (library_card ("simple_sql", "SQLite wrapper with contract safety. Full query building, transactions, and result handling.",
				"17,200", "339", <<
					"Fluent query builder",
					"Transaction support",
					"Prepared statements",
					"Contract-verified operations"
				>>))
			Result.append (library_card ("simple_web", "HTTP client and server. Request/response handling, routing, middleware.",
				"8,000", "95", <<
					"HTTP client for API calls",
					"HTTP server with routing",
					"Request/response abstraction",
					"Middleware support"
				>>))
			Result.append (library_card ("simple_htmx", "Fluent HTML/HTMX builder. Type-safe element construction.",
				"4,200", "40", <<
					"Fluent interface design",
					"All HTMX attributes",
					"HTML escaping built-in",
					"Composable elements"
				>>))
			Result.append (library_card ("simple_alpine", "Alpine.js directive builder. Type-safe Alpine integration.",
				"3,200", "103", <<
					"All Alpine.js directives",
					"Layered on simple_htmx",
					"x-data, x-show, x-bind, etc.",
					"Transition support"
				>>))
			Result.append (library_card ("eiffel_sqlite_2025", "Modern SQLite3 wrapper with FTS5 and JSON1 extensions.",
				"25,000", "200", <<
					"Full-text search (FTS5)",
					"JSON functions (JSON1)",
					"Modern SQLite features",
					"Low-level and high-level APIs"
				>>))
			Result.append (library_card ("simple_ci", "Homebrew CI tool for Eiffel projects.",
				"1,600", "", <<
					"Build automation",
					"Test running",
					"Report generation"
				>>))
			Result.append (library_card ("simple_gui_designer", "Visual GUI specification designer. (WIP - in-house project, shared publicly)",
				"7,000", "10", <<
					"Visual layout editor",
					"Code generation",
					"Contract-based specs"
				>>))
			Result.append (library_card ("simple_process", "Process execution helper.",
				"500", "4", <<
					"Command execution",
					"Output capture",
					"Cross-platform"
				>>))
			Result.append (library_card ("simple_randomizer", "Random data generation.",
				"1,100", "27", <<
					"Random strings",
					"Random numbers",
					"Test data generation"
				>>))
			Result.append (library_card ("simple_ai_client", "AI API integration.",
				"", "", <<
					"Claude API support",
					"Message handling",
					"Response parsing"
				>>))
			Result.append (library_card ("reference_docs", "Living documentation for AI-assisted development.",
				"4,000", "", <<
					"Eiffel patterns",
					"Common gotchas",
					"Session management"
				>>))
			Result.append ("</div>%N")
			Result.append (divider)

			-- Timeline
			Result.append (section_heading ("Timeline"))
			Result.append (paragraph ("A velocity demonstration:"))
			Result.append ("<div class=%"space-y-4 mb-8%">%N")
			Result.append (timeline_entry ("Nov 11-14", "simple_json", "11,400 lines"))
			Result.append (timeline_entry ("Nov 30 - Dec 1", "simple_sql", "17,200 lines"))
			Result.append (timeline_entry ("Dec 2", "simple_web, simple_process, simple_randomizer", "Multiple libs"))
			Result.append (timeline_entry ("Dec 2", "simple_ci", "Build tool"))
			Result.append (timeline_entry ("Dec 2-3", "simple_gui_designer (WIP)", "7,000 lines"))
			Result.append (timeline_entry ("Dec 3", "simple_htmx", "4,200 lines"))
			Result.append (timeline_entry ("Dec 3", "simple_alpine", "3,200 lines"))
			Result.append ("</div>%N")
			Result.append (divider)

			-- Run Tests
			Result.append (section_heading ("Run the Tests Yourself"))
			Result.append (paragraph ("Don't take our word for it. Clone any repo, run the tests."))
			Result.append (code_block (
				"git clone https://github.com/ljr1981/simple_json%N" +
				"cd simple_json%N" +
				"# Follow README for test commands"))
			Result.append (paragraph ("Every test passes. Every contract verified."))
		ensure then
			has_libraries: Result.has_substring ("simple_json")
		end

feature {NONE} -- Related Pages

	related_pages: HASH_TABLE [STRING, STRING]
			-- Related pages for footer
		do
			create Result.make (3)
			Result.put ("Get Started", "get-started")
			Result.put ("Business Case", "business-case")
		end

feature {NONE} -- Content Helpers

	library_card (a_name, a_description, a_lines, a_tests: STRING; a_features: ARRAY [STRING]): STRING
			-- Generate a library card
		local
			l_github: STRING
		do
			l_github := "https://github.com/ljr1981/" + a_name
			create Result.make (800)
			Result.append ("<div class=%"card%">%N")
			Result.append ("  <h3 class=%"font-mono text-lg font-medium mb-2%">")
			Result.append (external_link (a_name, l_github))
			Result.append ("</h3>%N")
			Result.append ("  <p class=%"text-sm opacity-70 mb-4%">" + a_description + "</p>%N")
			if not a_lines.is_empty or not a_tests.is_empty then
				Result.append ("  <div class=%"flex gap-4 text-sm mb-4%">%N")
				if not a_lines.is_empty then
					Result.append ("    <span><span class=%"opacity-50%">Lines:</span> <strong>" + a_lines + "</strong></span>%N")
				end
				if not a_tests.is_empty then
					Result.append ("    <span><span class=%"opacity-50%">Tests:</span> <strong>" + a_tests + "</strong></span>%N")
				end
				Result.append ("  </div>%N")
			end
			Result.append ("  <ul class=%"text-sm opacity-80 space-y-1%">%N")
			across 1 |..| a_features.count as idx loop
				Result.append ("    <li>• " + a_features[idx.item] + "</li>%N")
			end
			Result.append ("  </ul>%N")
			Result.append ("</div>%N")
		end

	timeline_entry (a_date, a_project, a_details: STRING): STRING
			-- Generate a timeline entry
		do
			create Result.make (200)
			Result.append ("<div class=%"flex gap-4 items-baseline%">%N")
			Result.append ("  <span class=%"text-sm opacity-50 w-32%">" + a_date + "</span>%N")
			Result.append ("  <span class=%"font-mono%">" + a_project + "</span>%N")
			Result.append ("  <span class=%"text-sm opacity-70%">" + a_details + "</span>%N")
			Result.append ("</div>%N")
		end

end
