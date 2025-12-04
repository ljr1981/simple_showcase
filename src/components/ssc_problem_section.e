note
	description: "The Problem section - AI alone isn't enough (with citations)"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_PROBLEM_SECTION

inherit
	SSC_SECTION
		redefine
			background_color
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize problem section
		do
			-- Nothing needed
		end

feature -- Access

	section_number: INTEGER = 3

	section_id: STRING = "problem"

	background_color: STRING
			-- Deep amber for warning/problem
		do
			Result := color_accent_warning
		end

feature {NONE} -- Content

	section_content: STRING
			-- Problem section with research citations
		local
			l_container, l_label_wrap, l_content, l_stats_grid: ALPINE_DIV
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
				.text ("THE PROBLEM")
				.do_nothing
			l_label_wrap.raw_html (l_label.to_html).do_nothing
			l_container.raw_html (l_label_wrap.to_html).do_nothing

			-- Headline and subhead
			l_content := alpine.div
			l_content.class_ ("mb-16").do_nothing

			l_headline := alpine.h2
			l_headline.class_ (font_section_headline + " mb-6")
				.text ("But there's a problem.")
				.do_nothing
			l_content.raw_html (l_headline.to_html).do_nothing

			l_subhead := alpine.p
			l_subhead.class_ (font_body + " opacity-80 max-w-3xl")
				.text ("AI generates probable code, not provable code. Without verification, you're just creating bugs faster.")
				.do_nothing
			l_content.raw_html (l_subhead.to_html).do_nothing

			l_container.raw_html (l_content.to_html).do_nothing

			-- Stats grid with research citations
			l_stats_grid := alpine.div
			l_stats_grid.class_ ("grid md:grid-cols-2 lg:grid-cols-4 gap-6").do_nothing

			l_stats_grid.raw_html (stat_card ("41%%", "more bugs with Copilot", "Uplevel 2024", "https://uplevelteam.com/blog/ai-for-developer-productivity", 1))
				.raw_html (stat_card ("45%%", "AI code has security flaws", "Veracode 2024", "https://www.veracode.com/blog/ai-generated-code-security-risks/", 2))
				.raw_html (stat_card ("33%%", "developers trust AI code", "Stack Overflow 2024", "https://survey.stackoverflow.co/2024/ai", 3))
				.raw_html (stat_card ("85%%", "Devin AI tasks failed", "Devin audit", "https://www.answer.ai/posts/2025-01-08-devin.html", 4))
				.do_nothing

			l_container.raw_html (l_stats_grid.to_html).do_nothing

			Result.append (l_container.to_html)
		end

	stat_card (a_number, a_label, a_source, a_url: STRING; a_index: INTEGER): STRING
			-- Generate a stat card HTML with linked source and entrance animation
		require
			number_not_empty: not a_number.is_empty
			label_not_empty: not a_label.is_empty
			source_not_empty: not a_source.is_empty
			url_not_empty: not a_url.is_empty
			index_positive: a_index > 0
		local
			l_card: ALPINE_DIV
			l_delay_class: STRING
		do
			l_delay_class := "card-delay-" + ((a_index - 1) \\ 4 + 1).out

			l_card := alpine.div
			l_card.class_ ("p-6 rounded-lg bg-white/10 text-center hover-lift card-animate " + l_delay_class)
				.x_intersect ("$el.classList.add('entered')")
				.raw_html ("<p class=%"text-5xl font-bold mb-2 stat-number%">" + a_number + "</p>")
				.raw_html ("<p class=%"text-sm opacity-80 mb-1%">" + a_label + "</p>")
				.raw_html ("<a href=%"" + a_url + "%" target=%"_blank%" class=%"text-xs text-blue-400 hover:underline%">" + a_source + " ↗</a>")
				.do_nothing
			Result := l_card.to_html
		ensure
			not_empty: not Result.is_empty
			has_number: Result.has_substring (a_number)
			has_label: Result.has_substring (a_label)
			has_source: Result.has_substring (a_source)
		end

end
