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
			l_container.class_ (container_wide)

			-- Section label
			l_label_wrap := alpine.div
			l_label_wrap.class_ ("mb-8 opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-500 delay-200")
				.attr_raw ("x-transition:enter-start", "opacity-0")
				.attr_raw ("x-transition:enter-end", "opacity-100")

			l_label := alpine.span
			l_label.class_ (font_section_label)
				.text ("THE EVIDENCE")
			l_label_wrap.raw_html (l_label.to_html)
			l_container.raw_html (l_label_wrap.to_html)

			-- Header
			l_header := alpine.div
			l_header.class_ ("mb-12 opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-400")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-y-8")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-y-0")

			l_headline := alpine.h2
			l_headline.class_ (font_section_headline + " mb-4")
				.text ("This isn't theory.")
			l_header.raw_html (l_headline.to_html)

			l_subhead := alpine.p
			l_subhead.class_ (font_body + " opacity-80")
				.text ("11 production libraries built in 10 calendar days. Every one contract-verified.")
			l_header.raw_html (l_subhead.to_html)

			l_container.raw_html (l_header.to_html)

			-- Project grid
			l_grid := alpine.div
			l_grid.class_ ("grid md:grid-cols-2 lg:grid-cols-3 gap-4")

			l_grid.raw_html (project_card ("simple_json", "11,400", "215", "Zero-friction JSON parsing", 1))
			l_grid.raw_html (project_card ("simple_sql", "17,200", "339", "SQLite with contract safety", 2))
			l_grid.raw_html (project_card ("simple_web", "8,000", "95", "HTTP client + server", 3))
			l_grid.raw_html (project_card ("simple_htmx", "4,200", "40", "Fluent HTML/HTMX builder", 4))
			l_grid.raw_html (project_card ("simple_alpine", "3,200", "103", "Alpine.js directives", 5))
			l_grid.raw_html (project_card ("simple_ci", "1,600", "", "Homebrew CI tool", 6))
			l_grid.raw_html (project_card ("simple_gui_designer", "7,000", "10", "Visual GUI spec designer", 7))
			l_grid.raw_html (project_card ("simple_process", "500", "4", "Process execution helper", 8))
			l_grid.raw_html (project_card ("simple_randomizer", "1,100", "27", "Random data generation", 9))
			l_grid.raw_html (project_card ("simple_ai_client", "", "", "AI API integration", 10))
			l_grid.raw_html (project_card ("reference_docs", "4,000", "", "Living documentation", 11))

			l_container.raw_html (l_grid.to_html)

			-- CTA
			l_cta := alpine.div
			l_cta.class_ ("mt-12 text-center opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-500 delay-[1500ms]")
				.attr_raw ("x-transition:enter-start", "opacity-0")
				.attr_raw ("x-transition:enter-end", "opacity-100")
				.raw_html ("<a href=%"/portfolio%" class=%"inline-block px-6 py-3 bg-white/10 hover:bg-white/20 rounded-full text-sm transition-colors%">Explore the full portfolio →</a>")

			l_container.raw_html (l_cta.to_html)

			Result.append (l_container.to_html)
		end

	project_card (a_name, a_lines, a_tests, a_desc: STRING; a_index: INTEGER): STRING
			-- Generate a project card HTML
		local
			l_card: ALPINE_DIV
		do
			l_card := alpine.div
			l_card.class_ ("p-4 rounded-lg bg-white/5 hover:bg-white/10 transition-colors opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-400 delay-[" + (500 + (a_index * 80)).out + "ms]")
				.attr_raw ("x-transition:enter-start", "opacity-0 scale-95")
				.attr_raw ("x-transition:enter-end", "opacity-100 scale-100")

			l_card.raw_html ("<h3 class=%"font-mono text-sm font-medium mb-1%">" + a_name + "</h3>")
			l_card.raw_html ("<p class=%"text-xs opacity-60 mb-2%">" + a_desc + "</p>")
			if not a_lines.is_empty then
				l_card.raw_html ("<p class=%"text-xs%"><span class=%"opacity-50%">Lines:</span> <span class=%"font-bold%">" + a_lines + "</span></p>")
			end
			if not a_tests.is_empty then
				l_card.raw_html ("<p class=%"text-xs%"><span class=%"opacity-50%">Tests:</span> <span class=%"font-bold%">" + a_tests + "</span></p>")
			end
			Result := l_card.to_html
		end

end
