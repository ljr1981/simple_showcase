note
	description: "Test set for Simple Showcase"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_TEST_SET

inherit
	TEST_SET_BASE

feature -- Test routines

	test_hero_section_generates_html
			-- Test that hero section generates valid HTML
		local
			l_section: SSC_HERO_SECTION
			l_html: STRING
		do
			create l_section.make
			l_html := l_section.to_html
			assert ("not_empty", not l_html.is_empty)
			assert ("has_section_id", l_html.has_substring ("id=%"hero%""))
			assert ("has_headline", l_html.has_substring ("While others satisficed"))
		end

	test_recognition_section_generates_html
			-- Test that recognition section generates valid HTML
		local
			l_section: SSC_RECOGNITION_SECTION
			l_html: STRING
		do
			create l_section.make
			l_html := l_section.to_html
			assert ("not_empty", not l_html.is_empty)
			assert ("has_section_id", l_html.has_substring ("id=%"recognition%""))
			assert ("has_label", l_html.has_substring ("THE BEFORE"))
		end

	test_problem_section_has_citations
			-- Test that problem section includes research citations
		local
			l_section: SSC_PROBLEM_SECTION
			l_html: STRING
		do
			create l_section.make
			l_html := l_section.to_html
			assert ("has_uplevel", l_html.has_substring ("Uplevel 2024"))
			assert ("has_veracode", l_html.has_substring ("Veracode 2024"))
			assert ("has_stats", l_html.has_substring ("41%"))
		end

	test_unlock_section_has_code_example
			-- Test that unlock section includes code example
		local
			l_section: SSC_UNLOCK_SECTION
			l_html: STRING
		do
			create l_section.make
			l_html := l_section.to_html
			assert ("has_require", l_html.has_substring ("require"))
			assert ("has_ensure", l_html.has_substring ("ensure"))
			assert ("has_divide", l_html.has_substring ("divide"))
		end

	test_evidence_section_lists_projects
			-- Test that evidence section lists all projects
		local
			l_section: SSC_EVIDENCE_SECTION
			l_html: STRING
		do
			create l_section.make
			l_html := l_section.to_html
			assert ("has_simple_json", l_html.has_substring ("simple_json"))
			assert ("has_simple_sql", l_html.has_substring ("simple_sql"))
			assert ("has_simple_alpine", l_html.has_substring ("simple_alpine"))
		end

	test_invitation_section_has_three_paths
			-- Test that invitation section has three CTA paths
		local
			l_section: SSC_INVITATION_SECTION
			l_html: STRING
		do
			create l_section.make
			l_html := l_section.to_html
			assert ("has_team_path", l_html.has_substring ("I lead a team"))
			assert ("has_dev_path", l_html.has_substring ("I write code"))
			assert ("has_curious_path", l_html.has_substring ("I'm curious"))
		end

	test_landing_page_generates_complete_html
			-- Test that landing page generates complete HTML document
		local
			l_page: SSC_LANDING_PAGE
			l_html: STRING
		do
			create l_page.make
			l_html := l_page.to_html
			assert ("has_doctype", l_html.starts_with ("<!DOCTYPE html>"))
			assert ("has_head", l_html.has_substring ("<head>"))
			assert ("has_body", l_html.has_substring ("<body"))
			assert ("has_all_sections", l_html.has_substring ("id=%"invitation%""))
		end

	test_landing_page_includes_alpine_cdn
			-- Test that landing page includes Alpine.js CDN
		local
			l_page: SSC_LANDING_PAGE
			l_html: STRING
		do
			create l_page.make
			l_html := l_page.to_html
			assert ("has_alpine", l_html.has_substring ("alpinejs"))
			assert ("has_intersect", l_html.has_substring ("intersect"))
		end

	test_shared_colors_are_valid_hex
			-- Test that shared color constants are valid hex colors
		local
			l_shared: SSC_SHARED
		do
			create l_shared
			assert ("primary_dark_valid", l_shared.color_primary_dark.starts_with ("#") and l_shared.color_primary_dark.count = 7)
			assert ("primary_light_valid", l_shared.color_primary_light.starts_with ("#") and l_shared.color_primary_light.count = 7)
			assert ("accent_calm_valid", l_shared.color_accent_calm.starts_with ("#") and l_shared.color_accent_calm.count = 7)
		end

end
