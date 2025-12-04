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
			l_container.class_ (container_wide).do_nothing

			-- Section label
			l_label_wrap := alpine.div
			l_label_wrap.class_ ("mb-8").do_nothing

			l_label := alpine.span
			l_label.class_ (font_section_label)
				.text ("THE BEFORE")
				.do_nothing
			l_label_wrap.raw_html (l_label.to_html).do_nothing
			l_container.raw_html (l_label_wrap.to_html).do_nothing

			-- Headline
			l_headline_wrap := alpine.div
			l_headline_wrap.class_ ("mb-16").do_nothing

			l_headline := alpine.h2
			l_headline.class_ (font_section_headline)
				.text ("You know this feeling.")
				.do_nothing
			l_headline_wrap.raw_html (l_headline.to_html).do_nothing
			l_container.raw_html (l_headline_wrap.to_html).do_nothing

			-- Pain point cards
			l_cards := alpine.div
			l_cards.class_ ("grid md:grid-cols-2 gap-6").do_nothing

			l_cards.raw_html (pain_card ("The dependency maze", "Every new library means a dozen transitive dependencies you didn't ask for.", 1))
				.raw_html (pain_card ("The ecosystem fashion cycles", "The language is stable. The churn is market-driven fashion, not technical necessity.", 2))
				.raw_html (pain_card ("The hiring scramble", "Finding developers who know your stack. Hoping they stay.", 3))
				.raw_html (pain_card ("The debugging black box", "When it breaks at 3am, you're reading someone else's minified code.", 4))
				.do_nothing

			l_container.raw_html (l_cards.to_html).do_nothing

			Result.append (l_container.to_html)
		end

	pain_card (a_title, a_desc: STRING; a_index: INTEGER): STRING
			-- Generate a pain point card HTML with entrance animation
		local
			l_card: ALPINE_DIV
			l_delay_class: STRING
		do
			l_delay_class := "card-delay-" + ((a_index - 1) \\ 4 + 1).out

			l_card := alpine.div
			l_card.class_ ("p-6 rounded-lg bg-white/5 hover-lift card-animate " + l_delay_class)
				.x_intersect ("$el.classList.add('entered')")
				.raw_html ("<h3 class=%"text-xl font-medium mb-2%">" + a_title + "</h3>")
				.raw_html ("<p class=%"opacity-70%">" + a_desc + "</p>")
				.do_nothing
			Result := l_card.to_html
		end

end
