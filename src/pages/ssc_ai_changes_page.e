note
	description: "AI Changes page - Balanced view of AI capabilities and limitations"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_AI_CHANGES_PAGE

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

	page_title: STRING = "What AI Actually Changes"

	page_subtitle: STRING = "The real impact. Not the hype."

	page_url: STRING = "/ai-changes"

feature -- Content

	page_content: STRING
			-- Main page content
		do
			create Result.make (10000)

			-- What AI Does Well
			Result.append (section_heading ("What AI Does Well"))
			Result.append (capability_block ("Speed", <<
				"Boilerplate generation in seconds",
				"Pattern application across files",
				"Bulk operations that would take hours"
			>>, "text-emerald-400"))
			Result.append (capability_block ("Pattern recognition", <<
				"%"Make this look like that%"",
				"Consistent style across codebase",
				"Applying established conventions"
			>>, "text-emerald-400"))
			Result.append (capability_block ("Documentation", <<
				"README generation",
				"Code comments",
				"API documentation"
			>>, "text-emerald-400"))
			Result.append (capability_block ("Exploration", <<
				"%"How might I approach this?%"",
				"Rapid prototyping",
				"Trying multiple solutions quickly"
			>>, "text-emerald-400"))
			Result.append (divider)

			-- What AI Doesn't Do
			Result.append (section_heading ("What AI Doesn't Do"))
			Result.append (capability_block ("Guarantee correctness", <<
				"AI generates probable code, not proven code",
				"%"Looks right%" isn't %"is right%"",
				"Edge cases are often missed"
			>>, "text-red-400"))
			Result.append (capability_block ("Understand your business", <<
				"AI doesn't know your domain deeply",
				"Business rules need human specification",
				"Context matters, and AI has limited context"
			>>, "text-red-400"))
			Result.append (capability_block ("Replace judgment", <<
				"Architectural decisions need human wisdom",
				"Trade-offs require understanding consequences",
				"%"Should we do this?%" is a human question"
			>>, "text-red-400"))
			Result.append (divider)

			-- The Evidence of Limitations
			Result.append (section_heading ("The Evidence of Limitations"))
			Result.append ("<div class=%"grid grid-cols-2 md:grid-cols-4 gap-4 mb-8%">%N")
			Result.append (linked_stat_box ("41%%", "more bugs", "Uplevel 2024", "https://uplevelteam.com/blog/ai-for-developer-productivity"))
			Result.append (linked_stat_box ("45%%", "security flaws", "Veracode 2024", "https://www.veracode.com/blog/ai-generated-code-security-risks/"))
			Result.append (linked_stat_box ("33%%", "developer trust", "Stack Overflow 2024", "https://survey.stackoverflow.co/2024/ai"))
			Result.append (linked_stat_box ("85%%", "task failures", "Devin audit", "https://www.answer.ai/posts/2025-01-08-devin.html"))
			Result.append ("</div>%N")
			Result.append (paragraph ("<strong>AI is powerful. AI alone isn't enough.</strong>"))
			Result.append (divider)

			-- The Combination That Works
			Result.append (section_heading ("The Combination That Works"))
			Result.append ("<div class=%"bg-[#1a1a1a] rounded-lg p-8 text-center mb-8%">%N")
			Result.append ("  <div class=%"text-xl mb-4%">AI + Human judgment + Verification</div>%N")
			Result.append ("  <div class=%"grid grid-cols-3 gap-4 text-sm%">%N")
			Result.append ("    <div><div class=%"text-blue-400 font-medium%">AI</div><div class=%"opacity-70%">generates fast</div></div>%N")
			Result.append ("    <div><div class=%"text-emerald-400 font-medium%">Humans</div><div class=%"opacity-70%">direct and decide</div></div>%N")
			Result.append ("    <div><div class=%"text-purple-400 font-medium%">Contracts</div><div class=%"opacity-70%">verify automatically</div></div>%N")
			Result.append ("  </div>%N")
			Result.append ("  <div class=%"mt-6 pt-6 border-t border-white/10%">%N")
			Result.append ("    <div class=%"text-lg font-medium%">Speed x Wisdom x Proof = Shipping with confidence</div>%N")
			Result.append ("  </div>%N")
			Result.append ("</div>%N")

			-- CTA
			Result.append ("<div class=%"mt-8 flex gap-4%">%N")
			Result.append (cta_button ("How DBC Works", "design-by-contract"))
			Result.append (cta_button ("See the Evidence", "portfolio"))
			Result.append ("</div>%N")
		ensure then
			has_capabilities: Result.has_substring ("What AI Does Well")
		end

feature {NONE} -- Related Pages

	related_pages: HASH_TABLE [STRING, STRING]
			-- Related pages for footer
		do
			create Result.make (3)
			Result.put ("Design by Contract", "design-by-contract")
			Result.put ("Probable to Provable", "probable-to-provable")
		end

feature {NONE} -- Content Helpers

	capability_block (a_title: STRING; a_items: ARRAY [STRING]; a_color: STRING): STRING
			-- Generate a capability block
		do
			create Result.make (400)
			Result.append ("<div class=%"mb-6%">%N")
			Result.append ("  <h4 class=%"font-medium mb-3 " + a_color + "%">" + a_title + "</h4>%N")
			Result.append ("  <ul class=%"space-y-1 text-sm%">%N")
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
