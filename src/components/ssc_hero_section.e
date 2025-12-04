note
	description: "Hero section - Opening impact statement"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_HERO_SECTION

inherit
	SSC_SECTION

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize hero section
		do
			-- Nothing needed
		end

feature -- Access

	section_number: INTEGER = 0

	section_id: STRING = "hero"

feature {NONE} -- Content

	section_content: STRING
			-- Hero section content with staggered animation
		local
			l_container, l_headline_wrap, l_subhead, l_scroll_indicator: ALPINE_DIV
			l_line1, l_line2: ALPINE_P
			l_stats: ALPINE_P
			l_arrow: ALPINE_SPAN
		do
			create Result.make (3000)

			-- Noise overlay
			l_container := alpine.div
			l_container.class_ ("fixed inset-0 pointer-events-none noise-overlay z-0").do_nothing
			Result.append (l_container.to_html)

			-- Main container
			l_container := alpine.div
			l_container.class_ (container_centered + " relative z-10").do_nothing

			-- Headline wrapper
			l_headline_wrap := alpine.div
			l_headline_wrap.class_ ("mb-12").do_nothing

			-- Line 1: "While others satisficed,"
			l_line1 := alpine.p
			l_line1.class_ (font_hero_headline + " opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-300")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-y-8")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-y-0")
				.text ("While others satisficed,")
				.do_nothing
			l_headline_wrap.raw_html (l_line1.to_html).do_nothing

			-- Line 2: "we were building."
			l_line2 := alpine.p
			l_line2.class_ (font_hero_headline + " opacity-0 text-white/90")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-500")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-y-8")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-y-0")
				.text ("we were building.")
				.do_nothing
			l_headline_wrap.raw_html (l_line2.to_html).do_nothing

			l_container.raw_html (l_headline_wrap.to_html).do_nothing

			-- Subhead with stats
			l_subhead := alpine.div
			l_subhead.class_ ("space-y-4 opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-1000")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-y-8")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-y-0")
				.do_nothing

			l_stats := alpine.p
			l_stats.class_ (font_body + " " + font_stats)
				.raw_html ("<span class=%"text-2xl%">11</span> libraries. ")
				.raw_html ("<span class=%"text-2xl%">900+</span> tests. ")
				.raw_html ("<span class=%"text-2xl%">10</span> days. ")
				.raw_html ("<span class=%"text-2xl%">One</span> person.")
				.do_nothing
			l_subhead.raw_html (l_stats.to_html).do_nothing

			l_stats := alpine.p
			l_stats.class_ (font_body + " opacity-70")
				.text ("AI-assisted. Contract-verified. Production-ready.")
				.do_nothing
			l_subhead.raw_html (l_stats.to_html).do_nothing

			l_container.raw_html (l_subhead.to_html).do_nothing

			-- Scroll indicator
			l_scroll_indicator := alpine.div
			l_scroll_indicator.class_ ("absolute bottom-12 left-1/2 -translate-x-1/2 opacity-0 cursor-pointer")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-[1500ms]")
				.attr_raw ("x-transition:enter-start", "opacity-0")
				.attr_raw ("x-transition:enter-end", "opacity-60")
				.attr_raw ("@click", "document.getElementById('recognition').scrollIntoView({ behavior: 'smooth' })")
				.do_nothing

			l_arrow := alpine.span
			l_arrow.class_ (anim_scroll_indicator + " inline-block")
				.text ("v")
				.do_nothing
			l_scroll_indicator.raw_html ("<p class=%"text-sm mb-2%">Scroll to see how</p>")
				.raw_html (l_arrow.to_html)
				.do_nothing

			l_container.raw_html (l_scroll_indicator.to_html).do_nothing

			Result.append (l_container.to_html)
		end

end
