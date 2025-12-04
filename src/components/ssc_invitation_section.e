note
	description: "The Invitation section - Come build (final CTA)"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_INVITATION_SECTION

inherit
	SSC_SECTION

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize invitation section
		do
			-- Nothing needed
		end

feature -- Access

	section_number: INTEGER = 8

	section_id: STRING = "invitation"

feature {NONE} -- Content

	section_content: STRING
			-- Invitation section with three paths
		local
			l_container, l_label_wrap, l_content, l_paths: ALPINE_DIV
			l_label: ALPINE_SPAN
			l_headline: ALPINE_H2
			l_subhead: ALPINE_P
		do
			create Result.make (5000)

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
				.text ("THE INVITATION")
			l_label_wrap.raw_html (l_label.to_html)
			l_container.raw_html (l_label_wrap.to_html)

			-- Header
			l_content := alpine.div
			l_content.class_ ("text-center mb-16 opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-400")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-y-8")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-y-0")

			l_headline := alpine.h2
			l_headline.class_ (font_section_headline + " mb-6")
				.text ("Ready to stop debating and start building?")
			l_content.raw_html (l_headline.to_html)

			l_subhead := alpine.p
			l_subhead.class_ (font_body + " opacity-80 max-w-2xl mx-auto")
				.text ("Choose your path. All roads lead to shipping.")
			l_content.raw_html (l_subhead.to_html)

			l_container.raw_html (l_content.to_html)

			-- Three paths
			l_paths := alpine.div
			l_paths.class_ ("grid md:grid-cols-3 gap-8")

			l_paths.raw_html (path_card ("I lead a team", "See the business case for contract-verified AI development.", "View Business Case", "/business-case", 1))
			l_paths.raw_html (path_card ("I write code", "Get started with your first contract-verified project today.", "Start Building", "/get-started", 2))
			l_paths.raw_html (path_card ("I'm curious", "Explore the evidence and decide for yourself.", "Explore Evidence", "/portfolio", 3))

			l_container.raw_html (l_paths.to_html)

			-- Final tagline
			l_content := alpine.div
			l_content.class_ ("mt-16 text-center opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-[1200ms]")
				.attr_raw ("x-transition:enter-start", "opacity-0")
				.attr_raw ("x-transition:enter-end", "opacity-100")

			l_subhead := alpine.p
			l_subhead.class_ ("text-sm opacity-50")
				.text ("This site was built with the same paradigm it describes.")
			l_content.raw_html (l_subhead.to_html)

			l_container.raw_html (l_content.to_html)

			Result.append (l_container.to_html)
		end

	path_card (a_title, a_desc, a_cta, a_link: STRING; a_index: INTEGER): STRING
			-- Generate a path card HTML
		local
			l_path: ALPINE_DIV
		do
			l_path := alpine.div
			l_path.class_ ("p-8 rounded-lg bg-white/5 hover:bg-white/10 transition-all text-center opacity-0 group")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-500 delay-[" + (600 + (a_index * 150)).out + "ms]")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-y-8")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-y-0")

			l_path.raw_html ("<h3 class=%"text-xl font-medium mb-4%">" + a_title + "</h3>")
			l_path.raw_html ("<p class=%"opacity-70 mb-6%">" + a_desc + "</p>")
			l_path.raw_html ("<a href=%"" + a_link + "%" class=%"inline-block px-6 py-3 bg-white/10 group-hover:bg-white/20 rounded-full text-sm transition-colors%">" + a_cta + " →</a>")
			Result := l_path.to_html
		end

end
