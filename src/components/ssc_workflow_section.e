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
				.text ("THE WORKFLOW")
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
				.text ("You're the pilot. AI is the co-pilot.")
			l_content.raw_html (l_headline.to_html)

			l_subhead := alpine.p
			l_subhead.class_ (font_body + " opacity-80 max-w-2xl mx-auto")
				.text ("Each brings what the other lacks. Together, they achieve what neither could alone.")
			l_content.raw_html (l_subhead.to_html)

			l_container.raw_html (l_content.to_html)

			-- Two-column comparison
			l_grid := alpine.div
			l_grid.class_ ("grid md:grid-cols-2 gap-12")

			-- Human column
			l_col := alpine.div
			l_col.class_ ("opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-600")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-x-[-20px]")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-x-0")

			l_col.raw_html ("<h3 class=%"text-2xl font-medium mb-6 text-center%">Human Brings</h3>")
			l_col.raw_html (role_item ("✓", "text-emerald-400", "Vision & direction"))
			l_col.raw_html (role_item ("✓", "text-emerald-400", "Domain expertise"))
			l_col.raw_html (role_item ("✓", "text-emerald-400", "Quality judgment"))
			l_col.raw_html (role_item ("✓", "text-emerald-400", "Strategic decisions"))
			l_col.raw_html (role_item ("✓", "text-emerald-400", "Course correction"))

			l_grid.raw_html (l_col.to_html)

			-- AI column
			l_col := alpine.div
			l_col.class_ ("opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-800")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-x-[20px]")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-x-0")

			l_col.raw_html ("<h3 class=%"text-2xl font-medium mb-6 text-center%">AI Brings</h3>")
			l_col.raw_html (role_item ("⚡", "text-blue-400", "Code generation at scale"))
			l_col.raw_html (role_item ("⚡", "text-blue-400", "Pattern application"))
			l_col.raw_html (role_item ("⚡", "text-blue-400", "Documentation"))
			l_col.raw_html (role_item ("⚡", "text-blue-400", "Test creation"))
			l_col.raw_html (role_item ("⚡", "text-blue-400", "Bulk operations"))

			l_grid.raw_html (l_col.to_html)

			l_container.raw_html (l_grid.to_html)

			Result.append (l_container.to_html)
		end

	role_item (a_icon, a_icon_class, a_text: STRING): STRING
			-- Generate a role list item HTML
		local
			l_item: ALPINE_DIV
		do
			l_item := alpine.div
			l_item.class_ ("flex items-center gap-3 mb-3")
				.raw_html ("<span class=%"" + a_icon_class + "%">" + a_icon + "</span>")
				.raw_html ("<span>" + a_text + "</span>")
			Result := l_item.to_html
		end

end
