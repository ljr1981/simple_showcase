note
	description: "The Shift section - AI arrived"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_SHIFT_SECTION

inherit
	SSC_SECTION
		redefine
			background_color
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize shift section
		do
			-- Nothing needed
		end

feature -- Access

	section_number: INTEGER = 2

	section_id: STRING = "shift"

	background_color: STRING
			-- Deep purple for energy/excitement
		do
			Result := color_accent_energy
		end

feature {NONE} -- Content

	section_content: STRING
			-- Shift section content
		local
			l_container, l_label_wrap, l_content: ALPINE_DIV
			l_label: ALPINE_SPAN
			l_headline: ALPINE_H2
			l_subhead: ALPINE_P
		do
			create Result.make (3000)

			-- Main container
			l_container := alpine.div
			l_container.class_ (container_centered)

			-- Section label
			l_label_wrap := alpine.div
			l_label_wrap.class_ ("mb-8 opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-500 delay-200")
				.attr_raw ("x-transition:enter-start", "opacity-0")
				.attr_raw ("x-transition:enter-end", "opacity-100")

			l_label := alpine.span
			l_label.class_ (font_section_label)
				.text ("THE SHIFT")
			l_label_wrap.raw_html (l_label.to_html)
			l_container.raw_html (l_label_wrap.to_html)

			-- Content
			l_content := alpine.div
			l_content.class_ ("space-y-8 opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-400")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-y-8")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-y-0")

			l_headline := alpine.h2
			l_headline.class_ (font_section_headline)
				.text ("Then AI changed everything.")
			l_content.raw_html (l_headline.to_html)

			l_subhead := alpine.p
			l_subhead.class_ (font_body + " opacity-80 max-w-2xl mx-auto")
				.text ("Suddenly, a single developer could write 10,000 lines in a day. Libraries that took months could be built in hours. The velocity was intoxicating.")
			l_content.raw_html (l_subhead.to_html)

			l_container.raw_html (l_content.to_html)

			Result.append (l_container.to_html)
		end

end
