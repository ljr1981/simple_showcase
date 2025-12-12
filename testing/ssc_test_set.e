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
			assert ("has_stats", l_html.has_substring ("41%%"))
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

	test_evidence_section_has_layer_organization
			-- Test that evidence section shows layered architecture
		local
			l_section: SSC_EVIDENCE_SECTION
			l_html: STRING
		do
			create l_section.make
			l_html := l_section.to_html
			assert ("has_foundation_layer", l_html.has_substring ("Foundation Layer"))
			assert ("has_service_layer", l_html.has_substring ("Service Layer"))
			assert ("has_web_layer", l_html.has_substring ("Web Layer"))
			assert ("has_api_facades", l_html.has_substring ("API Facades"))
		end

	test_evidence_section_has_christmas_sprint_libs
			-- Test that evidence section includes Christmas Sprint libraries
		local
			l_section: SSC_EVIDENCE_SECTION
			l_html: STRING
		do
			create l_section.make
			l_html := l_section.to_html
			assert ("has_base64", l_html.has_substring ("simple_base64"))
			assert ("has_jwt", l_html.has_substring ("simple_jwt"))
			assert ("has_cache", l_html.has_substring ("simple_cache"))
			assert ("has_logger", l_html.has_substring ("simple_logger"))
		end

	test_portfolio_page_has_all_libraries
			-- Test that portfolio page lists all 25 libraries
		local
			l_page: SSC_PORTFOLIO_PAGE
			l_html: STRING
		do
			create l_page.make
			l_html := l_page.to_html
			-- Foundation layer
			assert ("has_json", l_html.has_substring ("simple_json"))
			assert ("has_base64", l_html.has_substring ("simple_base64"))
			assert ("has_hash", l_html.has_substring ("simple_hash"))
			-- Service layer
			assert ("has_sql", l_html.has_substring ("simple_sql"))
			assert ("has_jwt", l_html.has_substring ("simple_jwt"))
			assert ("has_logger", l_html.has_substring ("simple_logger"))
			-- Web layer
			assert ("has_web", l_html.has_substring ("simple_web"))
			assert ("has_htmx", l_html.has_substring ("simple_htmx"))
			assert ("has_alpine", l_html.has_substring ("simple_alpine"))
		end

	test_portfolio_page_has_christmas_sprint
			-- Test that portfolio page highlights Christmas Sprint
		local
			l_page: SSC_PORTFOLIO_PAGE
			l_html: STRING
		do
			create l_page.make
			l_html := l_page.to_html
			assert ("has_christmas_sprint", l_html.has_substring ("Christmas Sprint"))
			assert ("has_14_libraries", l_html.has_substring ("14 libraries"))
			assert ("has_2_days", l_html.has_substring ("2 days"))
			assert ("has_13x", l_html.has_substring ("13x"))
		end

	test_portfolio_page_has_documentation_links
			-- Test that portfolio page includes documentation links
		local
			l_page: SSC_PORTFOLIO_PAGE
			l_html: STRING
		do
			create l_page.make
			l_html := l_page.to_html
			assert ("has_github_pages_link", l_html.has_substring ("ljr1981.github.io"))
			assert ("has_documentation_text", l_html.has_substring ("Documentation"))
		end

	test_portfolio_page_has_apps_section
			-- Test that portfolio page separates libraries from apps
		local
			l_page: SSC_PORTFOLIO_PAGE
			l_html: STRING
		do
			create l_page.make
			l_html := l_page.to_html
			assert ("has_applications", l_html.has_substring ("Applications"))
			assert ("has_showcase", l_html.has_substring ("simple_showcase"))
			assert ("has_ci", l_html.has_substring ("simple_ci"))
		end

	test_analysis_page_has_christmas_sprint_case_study
			-- Test that analysis page includes Christmas Sprint case study
		local
			l_page: SSC_ANALYSIS_PAGE
			l_html: STRING
		do
			create l_page.make
			l_html := l_page.to_html
			assert ("has_case_study", l_html.has_substring ("Case Study"))
			assert ("has_christmas_sprint", l_html.has_substring ("Christmas Sprint"))
			assert ("has_original_plan", l_html.has_substring ("Original Plan"))
			assert ("has_actual_result", l_html.has_substring ("Actual Result"))
		end

	test_analysis_page_has_architecture_diagram
			-- Test that analysis page includes architecture diagram
		local
			l_page: SSC_ANALYSIS_PAGE
			l_html: STRING
		do
			create l_page.make
			l_html := l_page.to_html
			assert ("has_app_api", l_html.has_substring ("APP_API"))
			assert ("has_service_api", l_html.has_substring ("SERVICE_API"))
			assert ("has_foundation_api", l_html.has_substring ("FOUNDATION_API"))
		end

	test_analysis_page_has_productivity_table
			-- Test that analysis page includes productivity analysis table
		local
			l_page: SSC_ANALYSIS_PAGE
			l_html: STRING
		do
			create l_page.make
			l_html := l_page.to_html
			assert ("has_traditional_column", l_html.has_substring ("Traditional"))
			assert ("has_multiplier", l_html.has_substring ("Multiplier"))
			assert ("has_44_66x", l_html.has_substring ("44-66x"))
		end

	test_analysis_page_has_acknowledged_limitations
			-- Test that analysis page honestly acknowledges limitations
		local
			l_page: SSC_ANALYSIS_PAGE
			l_html: STRING
		do
			create l_page.make
			l_html := l_page.to_html
			assert ("has_limitations", l_html.has_substring ("Acknowledged Limitations"))
			assert ("has_ide_limitation", l_html.has_substring ("EiffelStudio"))
			assert ("has_community_limitation", l_html.has_substring ("Smaller community"))
		end

	test_business_case_has_updated_roi
			-- Test that business case has updated ROI figures
		local
			l_page: SSC_BUSINESS_CASE_PAGE
			l_html: STRING
		do
			create l_page.make
			l_html := l_page.to_html
			assert ("has_roi_section", l_html.has_substring ("ROI Analysis"))
			assert ("has_25_libraries", l_html.has_substring ("25 libraries"))
			assert ("has_traditional_estimate", l_html.has_substring ("595,000"))
		end

	test_business_case_has_christmas_sprint_roi
			-- Test that business case includes Christmas Sprint ROI highlight
		local
			l_page: SSC_BUSINESS_CASE_PAGE
			l_html: STRING
		do
			create l_page.make
			l_html := l_page.to_html
			assert ("has_christmas_highlight", l_html.has_substring ("Christmas Sprint"))
			assert ("has_13x", l_html.has_substring ("13x"))
			assert ("has_per_library_time", l_html.has_substring ("1.5h"))
		end

	test_landing_page_updated_description
			-- Test that landing page has updated stats in description
		local
			l_page: SSC_LANDING_PAGE
		do
			create l_page.make
			assert ("has_25_libraries", l_page.description.has_substring ("25"))
			assert ("has_1200_tests", l_page.description.has_substring ("1,200"))
			assert ("has_13_days", l_page.description.has_substring ("13"))
		end

end
