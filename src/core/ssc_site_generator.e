note
	description: "[
		Static site generator for GitHub Pages deployment.

		Generates all pages as static HTML files to the /docs folder.
		GitHub Pages can then serve these files directly.

		Usage:
			Run the generate_site target, then push /docs to GitHub.
			Enable GitHub Pages from /docs folder in repo settings.
	]"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_SITE_GENERATOR

inherit
	SSC_LOGGER

create
	make

feature {NONE} -- Initialization

	make
			-- Generate all pages to /docs folder
		do
			print ("%N========================================%N")
			print ("   SSC STATIC SITE GENERATOR%N")
			print ("========================================%N%N")

			create_output_directories
			generate_all_pages

			print ("%N========================================%N")
			print ("   SITE GENERATION COMPLETE%N")
			print ("========================================%N")
			print ("Output folder: docs/%N")
			print ("Next steps:%N")
			print ("  1. git add docs%N")
			print ("  2. git commit -m %"Generate static site%"%N")
			print ("  3. git push%N")
			print ("  4. Enable GitHub Pages from /docs in repo settings%N")
			print ("  5. Access at: https://ljr1981.github.io/simple_showcase%N%N")
		end

feature {NONE} -- Generation

	create_output_directories
			-- Create docs folder and subdirectories
		local
			l_dir: DIRECTORY
		do
			print ("Creating output directories...%N")

			-- Main docs folder
			create l_dir.make_with_path (create {PATH}.make_from_string ("docs"))
			if not l_dir.exists then
				l_dir.create_dir
			end

			-- Subdirectories for each page (GitHub Pages uses /page/index.html pattern)
			across page_directories as dir loop
				create l_dir.make_with_path (create {PATH}.make_from_string ("docs/" + dir))
				if not l_dir.exists then
					l_dir.create_dir
				end
			end

			print ("  Created " + (page_directories.count + 1).out + " directories%N")
		end

	generate_all_pages
			-- Generate all HTML pages
		do
			print ("%NGenerating pages...%N")

			-- Landing page -> docs/index.html
			generate_landing_page

			-- Sub-pages -> docs/{page}/index.html
			generate_get_started_page
			generate_portfolio_page
			generate_dbc_page
			generate_workflow_page
			generate_analysis_page
			generate_business_case_page
			generate_why_eiffel_page
			generate_probable_page
			generate_old_way_page
			generate_ai_changes_page

			print ("%N  Generated 11 pages%N")
		end

feature {NONE} -- Page Generation

	generate_landing_page
			-- Generate landing page
		local
			l_page: SSC_LANDING_PAGE
		do
			create l_page.make
			write_file ("docs/index.html", l_page.to_html)
			print ("  [OK] / -> docs/index.html%N")
		end

	generate_get_started_page
			-- Generate get started page
		local
			l_page: SSC_GET_STARTED_PAGE
		do
			create l_page.make
			write_file ("docs/get-started/index.html", l_page.to_html)
			print ("  [OK] /get-started -> docs/get-started/index.html%N")
		end

	generate_portfolio_page
			-- Generate portfolio page
		local
			l_page: SSC_PORTFOLIO_PAGE
		do
			create l_page.make
			write_file ("docs/portfolio/index.html", l_page.to_html)
			print ("  [OK] /portfolio -> docs/portfolio/index.html%N")
		end

	generate_dbc_page
			-- Generate design by contract page
		local
			l_page: SSC_DBC_PAGE
		do
			create l_page.make
			write_file ("docs/design-by-contract/index.html", l_page.to_html)
			print ("  [OK] /design-by-contract -> docs/design-by-contract/index.html%N")
		end

	generate_workflow_page
			-- Generate workflow page
		local
			l_page: SSC_WORKFLOW_PAGE
		do
			create l_page.make
			write_file ("docs/workflow/index.html", l_page.to_html)
			print ("  [OK] /workflow -> docs/workflow/index.html%N")
		end

	generate_analysis_page
			-- Generate analysis page
		local
			l_page: SSC_ANALYSIS_PAGE
		do
			create l_page.make
			write_file ("docs/analysis/index.html", l_page.to_html)
			print ("  [OK] /analysis -> docs/analysis/index.html%N")
		end

	generate_business_case_page
			-- Generate business case page
		local
			l_page: SSC_BUSINESS_CASE_PAGE
		do
			create l_page.make
			write_file ("docs/business-case/index.html", l_page.to_html)
			print ("  [OK] /business-case -> docs/business-case/index.html%N")
		end

	generate_why_eiffel_page
			-- Generate why eiffel page
		local
			l_page: SSC_WHY_EIFFEL_PAGE
		do
			create l_page.make
			write_file ("docs/why-eiffel/index.html", l_page.to_html)
			print ("  [OK] /why-eiffel -> docs/why-eiffel/index.html%N")
		end

	generate_probable_page
			-- Generate probable to provable page
		local
			l_page: SSC_PROBABLE_PAGE
		do
			create l_page.make
			write_file ("docs/probable-to-provable/index.html", l_page.to_html)
			print ("  [OK] /probable-to-provable -> docs/probable-to-provable/index.html%N")
		end

	generate_old_way_page
			-- Generate old way page
		local
			l_page: SSC_OLD_WAY_PAGE
		do
			create l_page.make
			write_file ("docs/old-way/index.html", l_page.to_html)
			print ("  [OK] /old-way -> docs/old-way/index.html%N")
		end

	generate_ai_changes_page
			-- Generate AI changes page
		local
			l_page: SSC_AI_CHANGES_PAGE
		do
			create l_page.make
			write_file ("docs/ai-changes/index.html", l_page.to_html)
			print ("  [OK] /ai-changes -> docs/ai-changes/index.html%N")
		end

feature {NONE} -- File Operations

	write_file (a_path, a_content: STRING)
			-- Write content to file
		require
			path_not_empty: not a_path.is_empty
			content_not_empty: not a_content.is_empty
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_open_write (a_path)
			l_file.put_string (a_content)
			l_file.close
		end

feature {NONE} -- Constants

	page_directories: ARRAY [STRING]
			-- Subdirectories to create for each page
		once
			Result := <<"get-started", "portfolio", "design-by-contract", "workflow",
				"analysis", "business-case", "why-eiffel", "probable-to-provable",
				"old-way", "ai-changes">>
		ensure
			ten_directories: Result.count = 10
		end

end
