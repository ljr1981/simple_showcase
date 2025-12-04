note
	description: "The Revelation section - Eiffel was built for this"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_REVELATION_SECTION

inherit
	SSC_SECTION

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize revelation section
		do
			-- Nothing needed
		end

feature -- Access

	section_number: INTEGER = 6

	section_id: STRING = "revelation"

feature {NONE} -- Content

	section_content: STRING
			-- Revelation section content
		local
			l_container, l_label_wrap, l_content, l_timeline: ALPINE_DIV
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
				.text ("THE REVELATION")
				.do_nothing
			l_label_wrap.raw_html (l_label.to_html).do_nothing
			l_container.raw_html (l_label_wrap.to_html).do_nothing

			-- Content
			l_content := alpine.div
			l_content.class_ ("text-center mb-16").do_nothing

			l_headline := alpine.h2
			l_headline.class_ (font_section_headline + " mb-6")
				.text ("This technology exists.")
				.do_nothing
			l_content.raw_html (l_headline.to_html).do_nothing

			l_subhead := alpine.p
			l_subhead.class_ (font_body + " opacity-80 max-w-2xl mx-auto")
				.text ("Eiffel has had Design by Contract built-in since 1986. What the industry is now calling %"AI-assisted development%" becomes something more: AI-assisted, contract-verified development.")
				.do_nothing
			l_content.raw_html (l_subhead.to_html).do_nothing

			l_container.raw_html (l_content.to_html).do_nothing

			-- Timeline
			l_timeline := alpine.div
			l_timeline.class_ ("flex flex-wrap justify-center gap-8").do_nothing

			l_timeline.raw_html (timeline_item ("1986", "Eiffel created with DBC", 1))
				.raw_html (timeline_item ("1997", "OOSC published", 2))
				.raw_html (timeline_item ("2023", "Claude released", 3))
				.raw_html (timeline_item ("2025", "Paradigm convergence", 4))
				.do_nothing

			l_container.raw_html (l_timeline.to_html).do_nothing

			Result.append (l_container.to_html)
		end

	timeline_item (a_year, a_event: STRING; a_index: INTEGER): STRING
			-- Generate a timeline item HTML with entrance animation
		require
			year_not_empty: not a_year.is_empty
			event_not_empty: not a_event.is_empty
			index_positive: a_index > 0
		local
			l_item: ALPINE_DIV
			l_delay_class: STRING
		do
			l_delay_class := "card-delay-" + ((a_index - 1) \\ 4 + 1).out

			l_item := alpine.div
			l_item.class_ ("text-center card-animate " + l_delay_class)
				.x_intersect ("$el.classList.add('entered')")
				.raw_html ("<p class=%"text-3xl font-bold mb-1%">" + a_year + "</p>")
				.raw_html ("<p class=%"text-sm opacity-70%">" + a_event + "</p>")
				.do_nothing
			Result := l_item.to_html
		ensure
			not_empty: not Result.is_empty
			has_year: Result.has_substring (a_year)
			has_event: Result.has_substring (a_event)
		end

end
