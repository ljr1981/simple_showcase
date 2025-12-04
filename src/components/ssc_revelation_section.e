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
				.text ("THE REVELATION")
			l_label_wrap.raw_html (l_label.to_html)
			l_container.raw_html (l_label_wrap.to_html)

			-- Content
			l_content := alpine.div
			l_content.class_ ("text-center mb-16 opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-400")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-y-8")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-y-0")

			l_headline := alpine.h2
			l_headline.class_ (font_section_headline + " mb-6")
				.text ("This technology exists.")
			l_content.raw_html (l_headline.to_html)

			l_subhead := alpine.p
			l_subhead.class_ (font_body + " opacity-80 max-w-2xl mx-auto")
				.text ("Eiffel has had Design by Contract built-in since 1986. What the industry is now calling %"AI-assisted development%" becomes something more: AI-assisted, contract-verified development.")
			l_content.raw_html (l_subhead.to_html)

			l_container.raw_html (l_content.to_html)

			-- Timeline
			l_timeline := alpine.div
			l_timeline.class_ ("flex flex-wrap justify-center gap-8")

			l_timeline.raw_html (timeline_item ("1986", "Eiffel created with DBC", 1))
			l_timeline.raw_html (timeline_item ("1997", "OOSC published", 2))
			l_timeline.raw_html (timeline_item ("2023", "Claude released", 3))
			l_timeline.raw_html (timeline_item ("2025", "Paradigm convergence", 4))

			l_container.raw_html (l_timeline.to_html)

			Result.append (l_container.to_html)
		end

	timeline_item (a_year, a_event: STRING; a_index: INTEGER): STRING
			-- Generate a timeline item HTML
		local
			l_item: ALPINE_DIV
		do
			l_item := alpine.div
			l_item.class_ ("text-center opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-500 delay-[" + (600 + (a_index * 200)).out + "ms]")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-y-4")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-y-0")
				.raw_html ("<p class=%"text-3xl font-bold mb-1%">" + a_year + "</p>")
				.raw_html ("<p class=%"text-sm opacity-70%">" + a_event + "</p>")
			Result := l_item.to_html
		end

end
