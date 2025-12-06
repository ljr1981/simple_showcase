note
	description: "Base class for SSC landing page sections"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SSC_SECTION

inherit
	SSC_SHARED

	SSC_LOGGER

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

feature -- API Facade

	api: APP_API
			-- Unified API facade for all library access
		once
			create Result.make
		ensure
			result_exists: Result /= Void
		end

	alpine: ALPINE_FACTORY
			-- Factory for creating Alpine.js elements (via APP_API)
		do
			Result := api.alpine
		ensure
			result_exists: Result /= Void
		end

feature -- Generation

	to_html: STRING
			-- Generate section HTML
		do
			log_enter ("SSC_SECTION.to_html[" + section_id + "]")
			log_info ("section", "Generating section #" + section_number.out + " (" + section_id + ")")
			Result := build_section
			log_html_size ("Section[" + section_id + "]", Result)
			log_exit ("SSC_SECTION.to_html[" + section_id + "]")
		ensure
			not_empty: not Result.is_empty
		end

feature {NONE} -- Implementation

	build_section: STRING
			-- Build the section HTML structure
		local
			l_section, l_content_wrapper: ALPINE_DIV
			l_content: STRING
		do
			log_debug ("build", "Building section wrapper for: " + section_id)
			create Result.make (5000)
			l_section := alpine.div
			l_section.id (section_id)
				.class_ (section_classes)
				.style ("background-color: " + background_color)
				.do_nothing

			log_debug ("build", "Calling section_content for: " + section_id)
			l_content := section_content
			log_html_size ("section_content[" + section_id + "]", l_content)

			-- Wrap content for scroll-based fade animation
			l_content_wrapper := alpine.div
			l_content_wrapper.class_ ("section-content")
				.raw_html (l_content)
				.do_nothing

			l_section.raw_html (l_content_wrapper.to_html).do_nothing
			Result.append (l_section.to_html)
			log_debug ("build", "Section wrapper complete for: " + section_id)
		ensure
			not_empty: not Result.is_empty
			has_section_id: Result.has_substring (section_id)
		end

	section_classes: STRING
			-- CSS classes for the section wrapper
		do
			Result := section_full_viewport + " snap-section relative"
		ensure
			not_empty: not Result.is_empty
			has_snap_section: Result.has_substring ("snap-section")
		end

	section_content: STRING
			-- Inner content of section - implement in descendants
		deferred
		ensure
			not_empty: not Result.is_empty
		end

end
