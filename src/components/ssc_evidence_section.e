note
	description: "The Evidence section - Look what got built"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_EVIDENCE_SECTION

inherit
	SSC_SECTION
		redefine
			background_color
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize evidence section
		do
			-- Nothing needed
		end

feature -- Access

	section_number: INTEGER = 5

	section_id: STRING = "evidence"

	background_color: STRING
			-- Deep navy for evidence/proof
		do
			Result := color_accent_evidence
		end

feature {NONE} -- Content

	section_content: STRING
			-- Evidence section with project grid
		local
			l_container, l_label_wrap, l_header, l_grid, l_cta: ALPINE_DIV
			l_label: ALPINE_SPAN
			l_headline: ALPINE_H2
			l_subhead: ALPINE_P
		do
			create Result.make (8000)

			-- Main container
			l_container := alpine.div
			l_container.class_ (container_wide).do_nothing

			-- Section label
			l_label_wrap := alpine.div
			l_label_wrap.class_ ("mb-8").do_nothing

			l_label := alpine.span
			l_label.class_ (font_section_label)
				.text ("THE EVIDENCE")
				.do_nothing
			l_label_wrap.raw_html (l_label.to_html).do_nothing
			l_container.raw_html (l_label_wrap.to_html).do_nothing

			-- Header
			l_header := alpine.div
			l_header.class_ ("mb-12").do_nothing

			l_headline := alpine.h2
			l_headline.class_ (font_section_headline + " mb-4")
				.text ("This isn't theory.")
				.do_nothing
			l_header.raw_html (l_headline.to_html).do_nothing

			l_subhead := alpine.p
			l_subhead.class_ (font_body + " opacity-80")
				.text ("12 production libraries built in 10 calendar days. Every one contract-verified.")
				.do_nothing
			l_header.raw_html (l_subhead.to_html).do_nothing

			l_container.raw_html (l_header.to_html).do_nothing

			-- Project grid
			l_grid := alpine.div
			l_grid.class_ ("grid md:grid-cols-2 lg:grid-cols-3 gap-4").do_nothing

			l_grid.raw_html (project_card ("simple_json", "11,400", "215", "Zero-friction JSON parsing", 1))
				.raw_html (project_card ("simple_sql", "17,200", "339", "SQLite with contract safety", 2))
				.raw_html (project_card ("simple_web", "8,000", "95", "HTTP client + server", 3))
				.raw_html (project_card ("simple_htmx", "4,200", "40", "Fluent HTML/HTMX builder", 4))
				.raw_html (project_card ("simple_alpine", "3,200", "103", "Alpine.js directives", 5))
				.raw_html (project_card ("simple_ci", "1,600", "", "Homebrew CI tool", 6))
				.raw_html (project_card ("simple_gui_designer", "7,000", "10", "Visual GUI spec designer (WIP)", 7))
				.raw_html (project_card ("simple_process", "500", "4", "Process execution helper", 8))
				.raw_html (project_card ("simple_randomizer", "1,100", "27", "Random data generation", 9))
				.raw_html (project_card ("simple_ai_client", "", "", "AI API integration", 10))
				.raw_html (project_card ("eiffel_sqlite_2025", "25,000", "200", "Modern SQLite3 (FTS5, JSON1)", 11))
				.raw_html (project_card ("reference_docs", "4,000", "", "Living documentation", 12))
				.do_nothing

			l_container.raw_html (l_grid.to_html).do_nothing

			-- CTA
			l_cta := alpine.div
			l_cta.class_ ("mt-12 text-center")
				.raw_html ("<a href=%"portfolio%" class=%"inline-block px-6 py-3 bg-white/10 hover:bg-white/20 rounded-full text-sm transition-colors%">Explore the full portfolio →</a>")
				.do_nothing

			l_container.raw_html (l_cta.to_html).do_nothing

			Result.append (l_container.to_html)
		end

	project_card (a_name, a_lines, a_tests, a_desc: STRING; a_index: INTEGER): STRING
			-- Generate a project card HTML with GitHub link and entrance animation
		require
			name_not_empty: not a_name.is_empty
			desc_not_empty: not a_desc.is_empty
			index_positive: a_index > 0
		local
			l_card: ALPINE_DIV
			l_github_url: STRING
			l_delay_class: STRING
		do
			l_github_url := github_url (a_name)
			-- Stagger animation by cycling through delay classes
			l_delay_class := "card-delay-" + ((a_index - 1) \\ 4 + 1).out

			l_card := alpine.div
			l_card.class_ ("p-4 rounded-lg bg-white/5 hover:bg-white/10 hover-lift card-animate " + l_delay_class)
				.x_intersect ("$el.classList.add('entered')")
				.do_nothing

			l_card.raw_html ("<h3 class=%"font-mono text-sm font-medium mb-1%"><a href=%"" + l_github_url + "%" target=%"_blank%" class=%"hover:text-blue-400 transition-colors%">" + a_name + " ↗</a></h3>").do_nothing
			l_card.raw_html ("<p class=%"text-xs opacity-60 mb-2%">" + a_desc + "</p>").do_nothing
			if not a_lines.is_empty then
				l_card.raw_html ("<p class=%"text-xs%"><span class=%"opacity-50%">Lines:</span> <span class=%"font-bold%">" + a_lines + "</span></p>").do_nothing
			end
			if not a_tests.is_empty then
				l_card.raw_html ("<p class=%"text-xs%"><span class=%"opacity-50%">Tests:</span> <span class=%"font-bold%">" + a_tests + "</span></p>").do_nothing
			end
			Result := l_card.to_html
		ensure
			not_empty: not Result.is_empty
			has_name: Result.has_substring (a_name)
			has_github_link: Result.has_substring ("github.com")
		end

	github_url (a_project: STRING): STRING
			-- GitHub URL for project
		require
			project_not_empty: not a_project.is_empty
		do
			Result := "https://github.com/ljr1981/" + a_project
		ensure
			not_empty: not Result.is_empty
			is_github_url: Result.starts_with ("https://github.com/")
			has_project: Result.has_substring (a_project)
		end

end
