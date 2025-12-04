note
	description: "Recognition section - The Before (old way pain points)"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_RECOGNITION_SECTION

inherit
	SSC_SECTION
		redefine
			background_color
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize recognition section
		do
			-- Nothing needed
		end

feature -- Access

	section_number: INTEGER = 1

	section_id: STRING = "recognition"

	background_color: STRING
			-- Slightly warmer to evoke frustration
		do
			Result := "#0f0c0b"
		end

feature {NONE} -- Content

	section_content: STRING
			-- Recognition section content
		local
			l_container, l_label_wrap, l_headline_wrap, l_cards: ALPINE_DIV
			l_label: ALPINE_SPAN
			l_headline: ALPINE_H2
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
				.text ("THE BEFORE")
			l_label_wrap.raw_html (l_label.to_html)
			l_container.raw_html (l_label_wrap.to_html)

			-- Headline
			l_headline_wrap := alpine.div
			l_headline_wrap.class_ ("mb-16 opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-400")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-y-8")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-y-0")

			l_headline := alpine.h2
			l_headline.class_ (font_section_headline)
				.text ("You know this feeling.")
			l_headline_wrap.raw_html (l_headline.to_html)
			l_container.raw_html (l_headline_wrap.to_html)

			-- Pain point cards
			l_cards := alpine.div
			l_cards.class_ ("grid md:grid-cols-2 gap-6")

			l_cards.raw_html (pain_card ("The dependency maze", "Every new library means a dozen transitive dependencies you didn't ask for.", 1))
			l_cards.raw_html (pain_card ("The framework churn", "By the time you master one, the community has moved to the next.", 2))
			l_cards.raw_html (pain_card ("The hiring scramble", "Finding developers who know your stack. Hoping they stay.", 3))
			l_cards.raw_html (pain_card ("The debugging black box", "When it breaks at 3am, you're reading someone else's minified code.", 4))

			l_container.raw_html (l_cards.to_html)

			Result.append (l_container.to_html)
		end

	pain_card (a_title, a_desc: STRING; a_index: INTEGER): STRING
			-- Generate a pain point card HTML
		local
			l_card: ALPINE_DIV
		do
			l_card := alpine.div
			l_card.class_ ("p-6 rounded-lg bg-white/5 opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-500 delay-[" + (400 + (a_index * 200)).out + "ms]")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-y-4")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-y-0")
				.raw_html ("<h3 class=%"text-xl font-medium mb-2%">" + a_title + "</h3>")
				.raw_html ("<p class=%"opacity-70%">" + a_desc + "</p>")
			Result := l_card.to_html
		end

end
