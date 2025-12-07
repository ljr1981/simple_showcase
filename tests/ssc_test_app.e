note
	description: "Test application for simple_showcase with console output"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run all test sets and display results
		local
			ssc_tests: SSC_TEST_SET
			db_tests: SSC_DATABASE_TEST_SET
			val_tests: SSC_SERVER_VALIDATION_TEST_SET
		do
			print ("========================================%N")
			print ("SIMPLE_SHOWCASE Test Suite%N")
			print ("========================================%N%N")

			passed := 0
			failed := 0

			-- SSC Core Tests
			print ("Running SSC_TEST_SET...%N")
			create ssc_tests

			run_test (agent ssc_tests.test_hero_section_generates_html, "test_hero_section_generates_html")
			run_test (agent ssc_tests.test_recognition_section_generates_html, "test_recognition_section_generates_html")
			run_test (agent ssc_tests.test_problem_section_has_citations, "test_problem_section_has_citations")
			run_test (agent ssc_tests.test_unlock_section_has_code_example, "test_unlock_section_has_code_example")
			run_test (agent ssc_tests.test_evidence_section_lists_projects, "test_evidence_section_lists_projects")
			run_test (agent ssc_tests.test_invitation_section_has_three_paths, "test_invitation_section_has_three_paths")
			run_test (agent ssc_tests.test_landing_page_generates_complete_html, "test_landing_page_generates_complete_html")
			run_test (agent ssc_tests.test_landing_page_includes_alpine_cdn, "test_landing_page_includes_alpine_cdn")
			run_test (agent ssc_tests.test_shared_colors_are_valid_hex, "test_shared_colors_are_valid_hex")

			-- New Christmas Sprint tests
			run_test (agent ssc_tests.test_evidence_section_has_layer_organization, "test_evidence_section_has_layer_organization")
			run_test (agent ssc_tests.test_evidence_section_has_christmas_sprint_libs, "test_evidence_section_has_christmas_sprint_libs")
			run_test (agent ssc_tests.test_portfolio_page_has_all_libraries, "test_portfolio_page_has_all_libraries")
			run_test (agent ssc_tests.test_portfolio_page_has_christmas_sprint, "test_portfolio_page_has_christmas_sprint")
			run_test (agent ssc_tests.test_portfolio_page_has_documentation_links, "test_portfolio_page_has_documentation_links")
			run_test (agent ssc_tests.test_portfolio_page_has_apps_section, "test_portfolio_page_has_apps_section")
			run_test (agent ssc_tests.test_analysis_page_has_christmas_sprint_case_study, "test_analysis_page_has_christmas_sprint_case_study")
			run_test (agent ssc_tests.test_analysis_page_has_architecture_diagram, "test_analysis_page_has_architecture_diagram")
			run_test (agent ssc_tests.test_analysis_page_has_productivity_table, "test_analysis_page_has_productivity_table")
			run_test (agent ssc_tests.test_analysis_page_has_acknowledged_limitations, "test_analysis_page_has_acknowledged_limitations")
			run_test (agent ssc_tests.test_business_case_has_updated_roi, "test_business_case_has_updated_roi")
			run_test (agent ssc_tests.test_business_case_has_christmas_sprint_roi, "test_business_case_has_christmas_sprint_roi")
			run_test (agent ssc_tests.test_landing_page_updated_description, "test_landing_page_updated_description")

			-- Database Tests
			print ("%NRunning SSC_DATABASE_TEST_SET...%N")
			create db_tests

			run_test (agent db_tests.test_database_creates_schema, "test_database_creates_schema")
			run_test (agent db_tests.test_analytics_workflow, "test_analytics_workflow")
			run_test (agent db_tests.test_contact_workflow, "test_contact_workflow")
			run_test (agent db_tests.test_session_workflow, "test_session_workflow")

			-- Validation Tests
			print ("%NRunning SSC_SERVER_VALIDATION_TEST_SET...%N")
			create val_tests

			run_test (agent val_tests.test_email_validation_accepts_valid, "test_email_validation_accepts_valid")
			run_test (agent val_tests.test_email_validation_rejects_invalid, "test_email_validation_rejects_invalid")
			run_test (agent val_tests.test_sanitize_email_removes_dangerous_chars, "test_sanitize_email_removes_dangerous_chars")
			run_test (agent val_tests.test_sanitize_for_email_removes_header_injection, "test_sanitize_for_email_removes_header_injection")
			run_test (agent val_tests.test_sanitize_for_email_removes_shell_chars, "test_sanitize_for_email_removes_shell_chars")
			run_test (agent val_tests.test_remove_control_chars, "test_remove_control_chars")
			run_test (agent val_tests.test_has_dangerous_control_chars_helper, "test_has_dangerous_control_chars_helper")
			run_test (agent val_tests.test_is_safe_email_char_helper, "test_is_safe_email_char_helper")
			run_test (agent val_tests.test_rate_limit_allows_under_threshold, "test_rate_limit_allows_under_threshold")
			run_test (agent val_tests.test_rate_limit_blocks_at_threshold, "test_rate_limit_blocks_at_threshold")
			run_test (agent val_tests.test_rate_limit_ignores_expired, "test_rate_limit_ignores_expired")
			run_test (agent val_tests.test_rate_limit_new_ip_allowed, "test_rate_limit_new_ip_allowed")

			-- Summary
			print ("%N========================================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")
			print ("========================================%N")

			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Implementation

	passed: INTEGER
	failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Run a single test and update counters.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			print ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

end
