note
	description: "Base class for SSC landing page sections"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SSC_SECTION

inherit
	SSC_SHARED

feature -- Access

	section_number: INTEGER
			-- Position in the page (0 = hero)
		deferred
		ensure
			non_negative: Result >= 0
		end

	section_id: STRING
			-- HTML id attribute
		deferred
		ensure
			not_empty: not Result.is_empty
		end

	background_color: STRING
			-- Section background color (hex)
		do
			Result := color_primary_dark
		ensure
			valid_hex: Result.starts_with ("#") and Result.count = 7
		end

feature -- Factory

	alpine: ALPINE_FACTORY
			-- Factory for creating Alpine.js elements
		once
			create Result
		end

feature -- Generation

	to_html: STRING
			-- Generate section HTML
		do
			Result := build_section
		ensure
			not_empty: not Result.is_empty
		end

feature {NONE} -- Implementation

	build_section: STRING
			-- Build the section HTML structure
		local
			l_section: ALPINE_DIV
		do
			create Result.make (5000)
			l_section := alpine.div
			l_section.id (section_id)
				.class_ (section_classes)
				.style ("background-color: " + background_color)
				.x_data ("{ visible: false }")
				.attr_raw ("x-intersect:enter", "visible = true")
				.attr_raw ("x-intersect:leave", "visible = false")
				.raw_html (section_content)
				.do_nothing
			Result.append (l_section.to_html)
		end

	section_classes: STRING
			-- CSS classes for the section wrapper
		do
			Result := section_full_viewport + " snap-section relative"
		end

	section_content: STRING
			-- Inner content of section - implement in descendants
		deferred
		ensure
			not_empty: not Result.is_empty
		end

end
