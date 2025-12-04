note
	description: "The Workflow section - Human + AI partnership"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_WORKFLOW_SECTION

inherit
	SSC_SECTION

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize workflow section
		do
			-- Nothing needed
		end

feature -- Access

	section_number: INTEGER = 7

	section_id: STRING = "workflow"

feature {NONE} -- Content

	section_content: STRING
			-- Workflow section content with role comparison
		local
			l_container, l_label_wrap, l_content, l_grid, l_col: ALPINE_DIV
			l_label: ALPINE_SPAN
			l_headline: ALPINE_H2
			l_subhead: ALPINE_P
		do
			create Result.make (6000)

			-- Main container
			l_container := alpine.div
			l_container.class_ (container_wide).do_nothing

			-- Section label
			l_label_wrap := alpine.div
			l_label_wrap.class_ ("mb-8").do_nothing

			l_label := alpine.span
			l_label.class_ (font_section_label)
				.text ("THE WORKFLOW")
				.do_nothing
			l_label_wrap.raw_html (l_label.to_html).do_nothing
			l_container.raw_html (l_label_wrap.to_html).do_nothing

			-- Header
			l_content := alpine.div
			l_content.class_ ("text-center mb-16").do_nothing

			l_headline := alpine.h2
			l_headline.class_ (font_section_headline + " mb-6")
				.text ("You're the pilot. AI is the co-pilot.")
				.do_nothing
			l_content.raw_html (l_headline.to_html).do_nothing

			l_subhead := alpine.p
			l_subhead.class_ (font_body + " opacity-80 max-w-2xl mx-auto")
				.text ("The human steers. The AI assists. The contracts verify. Together, they fly.")
				.do_nothing
			l_content.raw_html (l_subhead.to_html).do_nothing

			l_container.raw_html (l_content.to_html).do_nothing

			-- Three-column comparison
			l_grid := alpine.div
			l_grid.class_ ("grid md:grid-cols-3 gap-8").do_nothing

			-- Human column
			l_col := alpine.div
			l_col.class_ ("card-animate card-delay-1")
				.x_intersect ("$el.classList.add('entered')")
				.do_nothing

			l_col.raw_html ("<h3 class=%"text-2xl font-medium mb-6 text-center%">Human Brings</h3>")
				.raw_html (role_item ("✓", "text-emerald-400", "Vision & direction"))
				.raw_html (role_item ("✓", "text-emerald-400", "Domain expertise"))
				.raw_html (role_item ("✓", "text-emerald-400", "Quality judgment"))
				.raw_html (role_item ("✓", "text-emerald-400", "Strategic decisions"))
				.raw_html (role_item ("✓", "text-emerald-400", "Course correction"))
				.do_nothing

			l_grid.raw_html (l_col.to_html).do_nothing

			-- AI column
			l_col := alpine.div
			l_col.class_ ("card-animate card-delay-2")
				.x_intersect ("$el.classList.add('entered')")
				.do_nothing

			l_col.raw_html ("<h3 class=%"text-2xl font-medium mb-6 text-center%">AI Brings</h3>")
				.raw_html (role_item ("⚡", "text-blue-400", "Code generation at scale"))
				.raw_html (role_item ("⚡", "text-blue-400", "Pattern application"))
				.raw_html (role_item ("⚡", "text-blue-400", "Documentation"))
				.raw_html (role_item ("⚡", "text-blue-400", "Test creation"))
				.raw_html (role_item ("⚡", "text-blue-400", "Bulk operations"))
				.do_nothing

			l_grid.raw_html (l_col.to_html).do_nothing

			-- DBC/Eiffel column (the airplane)
			l_col := alpine.div
			l_col.class_ ("card-animate card-delay-3")
				.x_intersect ("$el.classList.add('entered')")
				.do_nothing

			l_col.raw_html ("<h3 class=%"text-2xl font-medium mb-6 text-center%">DBC/Eiffel Provides</h3>")
				.raw_html (role_item ("✈", "text-amber-400", "The aircraft itself"))
				.raw_html (role_item ("✈", "text-amber-400", "Flight instruments (contracts)"))
				.raw_html (role_item ("✈", "text-amber-400", "Pre-flight checks (require)"))
				.raw_html (role_item ("✈", "text-amber-400", "Black box recorder (ensure)"))
				.raw_html (role_item ("✈", "text-amber-400", "Structural integrity (invariant)"))
				.do_nothing

			l_grid.raw_html (l_col.to_html).do_nothing

			l_container.raw_html (l_grid.to_html).do_nothing

			Result.append (l_container.to_html)
		end

	role_item (a_icon, a_icon_class, a_text: STRING): STRING
			-- Generate a role list item HTML
		require
			icon_not_empty: not a_icon.is_empty
			icon_class_not_empty: not a_icon_class.is_empty
			text_not_empty: not a_text.is_empty
		local
			l_item: ALPINE_DIV
		do
			l_item := alpine.div
			l_item.class_ ("flex items-center gap-3 mb-3")
				.raw_html ("<span class=%"" + a_icon_class + "%">" + a_icon + "</span>")
				.raw_html ("<span>" + a_text + "</span>")
				.do_nothing
			Result := l_item.to_html
		ensure
			not_empty: not Result.is_empty
			has_icon: Result.has_substring (a_icon)
			has_text: Result.has_substring (a_text)
		end

end
