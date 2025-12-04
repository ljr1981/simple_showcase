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
			l_container.class_ (container_wide).do_nothing

			-- Section label
			l_label_wrap := alpine.div
			l_label_wrap.class_ ("mb-8").do_nothing

			l_label := alpine.span
			l_label.class_ (font_section_label)
				.text ("THE INVITATION")
				.do_nothing
			l_label_wrap.raw_html (l_label.to_html).do_nothing
			l_container.raw_html (l_label_wrap.to_html).do_nothing

			-- Header
			l_content := alpine.div
			l_content.class_ ("text-center mb-16").do_nothing

			l_headline := alpine.h2
			l_headline.class_ (font_section_headline + " mb-6")
				.text ("Ready to stop debating and start building?")
				.do_nothing
			l_content.raw_html (l_headline.to_html).do_nothing

			l_subhead := alpine.p
			l_subhead.class_ (font_body + " opacity-80 max-w-2xl mx-auto")
				.text ("Choose your path. All roads lead to shipping.")
				.do_nothing
			l_content.raw_html (l_subhead.to_html).do_nothing

			l_container.raw_html (l_content.to_html).do_nothing

			-- Three paths
			l_paths := alpine.div
			l_paths.class_ ("grid md:grid-cols-3 gap-8").do_nothing

			l_paths.raw_html (path_card ("I lead a team", "See the business case for contract-verified AI development.", "View Business Case", "business-case", 1))
				.raw_html (path_card ("I write code", "Get started with your first contract-verified project today.", "Start Building", "get-started", 2))
				.raw_html (path_card ("I'm curious", "Explore the evidence and decide for yourself.", "Explore Evidence", "portfolio", 3))
				.do_nothing

			l_container.raw_html (l_paths.to_html).do_nothing

			-- Final tagline - the meta proof
			l_content := alpine.div
			l_content.class_ ("mt-16 pt-8 border-t border-white/10 text-center").do_nothing

			l_content.raw_html ("<p class=%"text-sm opacity-50 mb-2%">This site is built with the approach it describes.</p>")
				.raw_html ("<p class=%"text-xs opacity-40 mb-3%">No frameworks. No bundlers. No node_modules. Just Eiffel + AI + Design by Contract.</p>")
				.raw_html ("<p class=%"text-xs%"><a href=%"https://github.com/ljr1981/simple_showcase%" target=%"_blank%" class=%"text-blue-400 opacity-60 hover:opacity-100 hover:underline transition-opacity%">View the source on GitHub ↗</a></p>")
				.do_nothing

			l_container.raw_html (l_content.to_html).do_nothing

			Result.append (l_container.to_html)
		end

	path_card (a_title, a_desc, a_cta, a_link: STRING; a_index: INTEGER): STRING
			-- Generate a path card HTML
		require
			title_not_empty: not a_title.is_empty
			desc_not_empty: not a_desc.is_empty
			cta_not_empty: not a_cta.is_empty
			link_not_empty: not a_link.is_empty
			index_positive: a_index > 0
		local
			l_path: ALPINE_DIV
		do
			l_path := alpine.div
			l_path.class_ ("p-8 rounded-lg bg-white/5 hover:bg-white/10 transition-all text-center group")
				.raw_html ("<h3 class=%"text-xl font-medium mb-4%">" + a_title + "</h3>")
				.raw_html ("<p class=%"opacity-70 mb-6%">" + a_desc + "</p>")
				.raw_html ("<a href=%"" + a_link + "%" class=%"inline-block px-6 py-3 bg-white/10 group-hover:bg-white/20 rounded-full text-sm transition-colors%">" + a_cta + " →</a>")
				.do_nothing
			Result := l_path.to_html
		ensure
			not_empty: not Result.is_empty
			has_title: Result.has_substring (a_title)
			has_cta: Result.has_substring (a_cta)
			has_link: Result.has_substring (a_link)
		end

end
