note
	description: "Competitive Analysis page - Full paper formatted for web"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_ANALYSIS_PAGE

inherit
	SSC_SUB_PAGE
		redefine
			related_pages
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize page
		do
			-- Nothing needed
		end

feature -- Access

	page_title: STRING = "The Competitive Analysis"

	page_subtitle: STRING = "Eiffel + AI: Challenging Conventional Wisdom About Language Choice"

	page_url: STRING = "/analysis"

feature -- Content

	page_content: STRING
			-- Main page content
		do
			create Result.make (15000)

			-- Meta
			Result.append ("<p class=%"text-sm opacity-60 mb-8%">December 2025 | Larry Rix and Claude (Anthropic)</p>%N")
			Result.append (divider)

			-- Executive Summary
			Result.append (section_heading ("Executive Summary"))
			Result.append (paragraph ("This analysis examines how AI-assisted development combined with Design by Contract challenges traditional assumptions about language choice in software development."))
			Result.append (paragraph ("Key findings:"))
			Result.append (bullet_list (<<
				"<strong>40-80x productivity multiplier</strong> demonstrated in real-world library development",
				"<strong>5-day training</strong> sufficient for experienced developers to become productive",
				"<strong>Zero dependency vulnerabilities</strong> when you own all your code",
				"<strong>Runtime contract verification</strong> catches AI errors before production"
			>>))
			Result.append (divider)

			-- The Developer Reality
			Result.append (section_heading ("The Developer Reality"))
			Result.append (paragraph ("The conventional wisdom: %"You can't hire Eiffel developers.%""))
			Result.append (paragraph ("The reality:"))
			Result.append (bullet_list (<<
				"<strong>Existing community:</strong> Dozens to hundreds of experienced Eiffel developers worldwide",
				"<strong>Fast onboarding:</strong> Any OOP developer can learn Eiffel syntax in days",
				"<strong>Transferable concepts:</strong> DBC principles transfer from other paradigms",
				"<strong>AI acceleration:</strong> Reference docs + AI dramatically flatten the learning curve"
			>>))
			Result.append (paragraph ("Not millions like Java or JavaScript—but you don't need millions. You need the right few."))
			Result.append (divider)

			-- The Library Reality
			Result.append (section_heading ("The Library Reality"))
			Result.append (paragraph ("The conventional wisdom: %"There's no library ecosystem.%""))
			Result.append (paragraph ("The reality—a tiered approach:"))
			Result.append (bullet_list (<<
				"<strong>Tier 1:</strong> Stable core libraries (EiffelBase, EiffelNet, WEL)—foundation-layer stable like C/C++",
				"<strong>Tier 2:</strong> Community libraries on GitHub—fork, fix, contribute with AI acceleration",
				"<strong>Tier 3:</strong> Build what you need in hours/days when nothing fits"
			>>))
			Result.append (paragraph ("Stale community library? Clone it and fix it yourself with AI help—like we did with eiffel_sqlite."))
			Result.append (paragraph ("<strong>The real shift:</strong> From dependency to optionality. You <em>can</em> use external libraries—but you don't <em>have to</em>. See value in a market trend? Capture it yourself in hours, not months."))
			Result.append (divider)

			-- The Cost Analysis
			Result.append (section_heading ("The Cost Analysis"))
			Result.append (paragraph ("Traditional estimate for equivalent functionality:"))
			Result.append ("<div class=%"grid md:grid-cols-2 gap-6 mb-8%">%N")
			Result.append (cost_comparison ("Traditional Approach", <<
				"4-8 developers needed",
				"6-12 months development",
				"$400,000 - $800,000 cost",
				"Ongoing dependency management"
			>>))
			Result.append (cost_comparison ("Eiffel + AI Approach", <<
				"1 developer (+ AI)",
				"10 days development",
				"~$7,500 cost",
				"Zero external dependencies"
			>>))
			Result.append ("</div>%N")
			Result.append (paragraph ("<strong>ROI: 6,133%% - 10,100%%</strong>"))
			Result.append (divider)

			-- The Quality Factor
			Result.append (section_heading ("The Quality Factor"))
			Result.append (paragraph ("Industry data on AI-generated code:"))
			Result.append ("<div class=%"grid grid-cols-2 md:grid-cols-4 gap-4 mb-8%">%N")
			Result.append (linked_stat_box ("41%%", "more bugs", "Uplevel 2024", "https://uplevelteam.com/blog/ai-for-developer-productivity"))
			Result.append (linked_stat_box ("45%%", "security flaws", "Veracode 2024", "https://www.veracode.com/blog/ai-generated-code-security-risks/"))
			Result.append (linked_stat_box ("33%%", "developer trust", "Stack Overflow", "https://survey.stackoverflow.co/2024/ai"))
			Result.append (linked_stat_box ("85%%", "task failures", "Devin audit", "https://www.answer.ai/posts/2025-01-08-devin.html"))
			Result.append ("</div>%N")
			Result.append (paragraph ("With Design by Contract, AI errors are caught at compile-time or first execution—not in production."))
			Result.append (divider)

			-- The Methodology
			Result.append (section_heading ("The Methodology"))
			Result.append (paragraph ("How results were measured:"))
			Result.append (bullet_list (<<
				"Lines of code counted via standard tooling",
				"Test counts from EiffelStudio AutoTest",
				"Calendar days tracked from first commit to release",
				"All code available on GitHub for verification"
			>>))
			Result.append (paragraph ("All claims are verifiable. Clone the repos. Run the tests."))
			Result.append (divider)

			-- Implications
			Result.append (section_heading ("Implications for Decision Makers"))
			Result.append (paragraph ("For CTOs and technical leaders evaluating language choices:"))
			Result.append (bullet_list (<<
				"The %"safe choice%" may be the riskier choice",
				"Developer availability matters less than developer productivity",
				"Dependency management is a hidden cost",
				"Runtime verification changes the AI reliability equation"
			>>))

			-- CTA
			Result.append ("<div class=%"mt-8 flex gap-4%">%N")
			Result.append (cta_button ("View the Business Case", "business-case"))
			Result.append (cta_button ("See the Portfolio", "portfolio"))
			Result.append ("</div>%N")
		ensure then
			has_summary: Result.has_substring ("Executive Summary")
		end

feature {NONE} -- Related Pages

	related_pages: HASH_TABLE [STRING, STRING]
			-- Related pages for footer
		do
			create Result.make (3)
			Result.put ("Business Case", "business-case")
			Result.put ("Portfolio", "portfolio")
		end

feature {NONE} -- Content Helpers

	cost_comparison (a_title: STRING; a_items: ARRAY [STRING]): STRING
			-- Generate a cost comparison box
		do
			create Result.make (300)
			Result.append ("<div class=%"card%">%N")
			Result.append ("  <h4 class=%"font-medium mb-4%">" + a_title + "</h4>%N")
			Result.append ("  <ul class=%"space-y-2 text-sm%">%N")
			across 1 |..| a_items.count as idx loop
				Result.append ("    <li class=%"opacity-80%">• " + a_items[idx.item] + "</li>%N")
			end
			Result.append ("  </ul>%N")
			Result.append ("</div>%N")
		end

	linked_stat_box (a_number, a_label, a_source, a_url: STRING): STRING
			-- Generate a stat box with linked source
		do
			create Result.make (350)
			Result.append ("<div class=%"stat-box%">%N")
			Result.append ("  <div class=%"stat-number%">" + a_number + "</div>%N")
			Result.append ("  <div class=%"stat-label%">" + a_label + "</div>%N")
			Result.append ("  <a href=%"" + a_url + "%" target=%"_blank%" class=%"text-xs text-blue-400 hover:underline mt-2 block%">" + a_source + " ↗</a>%N")
			Result.append ("</div>%N")
		end

end
