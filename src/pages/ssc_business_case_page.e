note
	description: "Business Case page - CTO-focused ROI and risk analysis"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_BUSINESS_CASE_PAGE

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

	page_title: STRING = "The Business Case"

	page_subtitle: STRING = "For CTOs evaluating risk, cost, and capability."

	page_url: STRING = "/business-case"

feature -- Content

	page_content: STRING
			-- Main page content
		do
			create Result.make (12000)

			-- Executive Summary
			Result.append (section_heading ("Executive Summary"))
			Result.append ("<div class=%"grid grid-cols-2 md:grid-cols-4 gap-4 mb-8%">%N")
			Result.append (stat_box ("40-80x", "productivity"))
			Result.append (stat_box ("5 days", "training"))
			Result.append (stat_box ("0", "CVEs"))
			Result.append (stat_box ("100%%", "ownership"))
			Result.append ("</div>%N")
			Result.append (divider)

			-- The Cost Equation
			Result.append (section_heading ("The Cost Equation"))
			Result.append ("<div class=%"grid md:grid-cols-2 gap-6 mb-8%">%N")
			Result.append (approach_box ("Traditional Approach", <<
				"Hire experienced developers ($150-200K+ each)",
				"Months to find qualified candidates",
				"Ongoing dependency management",
				"Framework upgrade cycles",
				"Bug discovery in production"
			>>, "text-red-400"))
			Result.append (approach_box ("Eiffel + AI Approach", <<
				"Train existing developers (5 days)",
				"Tiered library strategy (see below)",
				"You control your own evolution (not chasing external fashion)",
				"Contract verification catches bugs early"
			>>, "text-emerald-400"))
			Result.append ("</div>%N")
			Result.append (library_tiers_section)
			Result.append (divider)

			-- ROI Analysis
			Result.append (section_heading ("ROI Analysis"))
			Result.append (paragraph ("Case study: 25 libraries + 4 apps built in 13 days"))
			Result.append ("<div class=%"bg-[#1a1a1a] rounded-lg p-6 mb-8%">%N")
			Result.append ("  <div class=%"grid grid-cols-2 gap-8%">%N")
			Result.append ("    <div>%N")
			Result.append ("      <div class=%"text-sm opacity-60 mb-1%">Traditional Estimate</div>%N")
			Result.append ("      <div class=%"text-2xl font-bold%">$595,000 - $935,000</div>%N")
			Result.append ("    </div>%N")
			Result.append ("    <div>%N")
			Result.append ("      <div class=%"text-sm opacity-60 mb-1%">Actual Cost</div>%N")
			Result.append ("      <div class=%"text-2xl font-bold text-emerald-400%">~$10,000</div>%N")
			Result.append ("    </div>%N")
			Result.append ("  </div>%N")
			Result.append ("  <div class=%"mt-6 pt-6 border-t border-white/10%">%N")
			Result.append ("    <div class=%"text-sm opacity-60 mb-1%">ROI</div>%N")
			Result.append ("    <div class=%"text-3xl font-bold%">5,850%% - 9,250%%</div>%N")
			Result.append ("    <div class=%"text-sm opacity-70 mt-2%">For every $1 invested: $59-$94 in value</div>%N")
			Result.append ("  </div>%N")
			Result.append ("</div>%N")
			Result.append (christmas_sprint_roi)
			Result.append (divider)

			-- Risk Analysis
			Result.append (section_heading ("Risk Analysis"))
			Result.append (paragraph ("Perceived risks (and reality):"))
			Result.append (risk_item ("%"Can't hire Eiffel developers%"",
				"Reality: Existing community (dozens to hundreds) + 5-day onboarding for OOP developers"))
			Result.append (risk_item ("%"No library ecosystem%"",
				"Reality: Tiered approach—stable core, community libs, and fast custom builds"))
			Result.append (risk_item ("%"Single point of failure%"",
				"Reality: Reference docs capture institutional knowledge"))
			Result.append (risk_item ("%"Unproven approach%"",
				"Reality: Eiffel is 40 years old. DBC is battle-tested."))
			Result.append (divider)

			-- Security Advantage
			Result.append (section_heading ("Security Advantage"))
			Result.append (paragraph ("Industry data on AI-generated code:"))
			Result.append (bullet_list (<<
				"45%% contains security flaws (" + external_link ("Veracode 2024", "https://www.veracode.com/blog/ai-generated-code-security-risks/") + ")",
				"10,000+ new security findings/month (" + external_link ("Apiiro 2025", "https://apiiro.com/blog/4x-velocity-10x-vulnerabilities-ai-coding-assistants-are-shipping-more-risks/") + ")"
			>>))
			Result.append (paragraph ("With Design by Contract:"))
			Result.append (bullet_list (<<
				"Preconditions validate all inputs",
				"Postconditions verify all outputs",
				"Invariants ensure consistent state",
				"Violations caught at runtime, not production"
			>>))
			Result.append (divider)

			-- Next Steps
			Result.append (section_heading ("Next Steps"))
			Result.append ("<div class=%"space-y-4%">%N")
			Result.append (next_step ("1", "Read the full competitive analysis", "analysis"))
			Result.append (next_step ("2", "Review the project portfolio", "portfolio"))
			Result.append (next_step ("3", "Try it yourself", "get-started"))
			Result.append ("</div>%N")
		ensure then
			has_roi: Result.has_substring ("ROI")
		end

feature {NONE} -- Related Pages

	related_pages: HASH_TABLE [STRING, STRING]
			-- Related pages for footer
		do
			create Result.make (3)
			Result.put ("Competitive Analysis", "analysis")
			Result.put ("Portfolio", "portfolio")
		end

feature {NONE} -- Content Helpers

	approach_box (a_title: STRING; a_items: ARRAY [STRING]; a_color: STRING): STRING
			-- Generate an approach comparison box
		do
			create Result.make (400)
			Result.append ("<div class=%"card%">%N")
			Result.append ("  <h4 class=%"font-medium mb-4 " + a_color + "%">" + a_title + "</h4>%N")
			Result.append ("  <ul class=%"space-y-2 text-sm%">%N")
			across 1 |..| a_items.count as idx loop
				Result.append ("    <li class=%"opacity-80%">• " + a_items[idx.item] + "</li>%N")
			end
			Result.append ("  </ul>%N")
			Result.append ("</div>%N")
		end

	risk_item (a_risk, a_reality: STRING): STRING
			-- Generate a risk/reality item
		do
			create Result.make (300)
			Result.append ("<div class=%"mb-6%">%N")
			Result.append ("  <div class=%"font-medium text-amber-400 mb-1%">" + a_risk + "</div>%N")
			Result.append ("  <div class=%"text-sm opacity-80%">" + a_reality + "</div>%N")
			Result.append ("</div>%N")
		end

	next_step (a_number, a_text, a_url: STRING): STRING
			-- Generate a next step item
		do
			create Result.make (200)
			Result.append ("<div class=%"flex items-center gap-4%">%N")
			Result.append ("  <span class=%"text-2xl font-bold opacity-30%">" + a_number + "</span>%N")
			Result.append ("  <a href=%"" + a_url + "%" class=%"hover:text-blue-400 transition-colors%">" + a_text + " →</a>%N")
			Result.append ("</div>%N")
		end

	christmas_sprint_roi: STRING
			-- Christmas Sprint ROI highlight
		do
			create Result.make (800)
			Result.append ("<div class=%"bg-emerald-900/20 border border-emerald-500/30 rounded-lg p-6 mb-8%">%N")
			Result.append ("  <h4 class=%"font-medium text-emerald-400 mb-4%">Christmas Sprint Highlight</h4>%N")
			Result.append ("  <p class=%"text-sm opacity-80 mb-4%">11 libraries built in 3 days (traditional: 5-11 months)</p>%N")
			Result.append ("  <div class=%"grid grid-cols-3 gap-4 text-center%">%N")
			Result.append ("    <div><div class=%"text-xl font-bold%">13x</div><div class=%"text-xs opacity-60%">faster</div></div>%N")
			Result.append ("    <div><div class=%"text-xl font-bold%">~1.5h</div><div class=%"text-xs opacity-60%">per library</div></div>%N")
			Result.append ("    <div><div class=%"text-xl font-bold%">100%%</div><div class=%"text-xs opacity-60%">complete</div></div>%N")
			Result.append ("  </div>%N")
			Result.append ("</div>%N")
		end

	library_tiers_section: STRING
			-- The tiered library strategy explanation
		do
			create Result.make (1500)
			Result.append ("<div class=%"mt-8%">%N")
			Result.append ("  <h3 class=%"text-xl font-medium mb-4%">The Library Reality</h3>%N")
			Result.append ("  <p class=%"mb-4 opacity-80 text-sm%">Eiffel has a real library ecosystem—it's just different:</p>%N")
			Result.append ("  <div class=%"space-y-4%">%N")
			-- Tier 1
			Result.append ("    <div class=%"card%">%N")
			Result.append ("      <div class=%"flex items-start gap-3%">%N")
			Result.append ("        <span class=%"text-emerald-400 font-bold%">1</span>%N")
			Result.append ("        <div>%N")
			Result.append ("          <h4 class=%"font-medium text-emerald-400%">Stable Core Libraries</h4>%N")
			Result.append ("          <p class=%"text-sm opacity-70%">EiffelBase, EiffelNet, WEL—foundation-layer stable like C/C++, not fashion-layer volatile.</p>%N")
			Result.append ("        </div>%N")
			Result.append ("      </div>%N")
			Result.append ("    </div>%N")
			-- Tier 2
			Result.append ("    <div class=%"card%">%N")
			Result.append ("      <div class=%"flex items-start gap-3%">%N")
			Result.append ("        <span class=%"text-blue-400 font-bold%">2</span>%N")
			Result.append ("        <div>%N")
			Result.append ("          <h4 class=%"font-medium text-blue-400%">Community Libraries</h4>%N")
			Result.append ("          <p class=%"text-sm opacity-70%">GitHub projects like simple_* libraries. Fork, fix, contribute—with AI acceleration.</p>%N")
			Result.append ("        </div>%N")
			Result.append ("      </div>%N")
			Result.append ("    </div>%N")
			-- Tier 3
			Result.append ("    <div class=%"card%">%N")
			Result.append ("      <div class=%"flex items-start gap-3%">%N")
			Result.append ("        <span class=%"text-purple-400 font-bold%">3</span>%N")
			Result.append ("        <div>%N")
			Result.append ("          <h4 class=%"font-medium text-purple-400%">Build What You Need</h4>%N")
			Result.append ("          <p class=%"text-sm opacity-70%">When nothing fits, build it in hours/days—not weeks/months. AI makes this viable.</p>%N")
			Result.append ("        </div>%N")
			Result.append ("      </div>%N")
			Result.append ("    </div>%N")
			Result.append ("  </div>%N")
			Result.append ("  <p class=%"mt-4 text-sm opacity-70%"><strong>Key insight:</strong> You're not avoiding change—you're controlling it. See value in a market trend? Capture it quickly in your own library. You <em>can</em> use external libraries if you find and trust them—but you don't <em>have to</em>. That's optionality, not dependency.</p>%N")
			Result.append ("</div>%N")
		end

end
