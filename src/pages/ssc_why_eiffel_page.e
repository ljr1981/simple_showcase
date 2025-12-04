note
	description: "Why Eiffel page - Deep dive on the language"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_WHY_EIFFEL_PAGE

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

	page_title: STRING = "Why Eiffel?"

	page_subtitle: STRING = "The language built for correctness. Now paired with AI."

	page_url: STRING = "/why-eiffel"

feature -- Content

	page_content: STRING
			-- Main page content
		do
			create Result.make (10000)

			-- The Origin
			Result.append (section_heading ("The Origin"))
			Result.append (paragraph ("Eiffel was created by Bertrand Meyer in 1986. One core principle: software should be correct by design."))
			Result.append (paragraph ("Not correct by testing. Not correct by code review. <strong>Correct by design.</strong>"))
			Result.append (paragraph ("Design by Contract was built into the language from day one. Not added later. Not a library. The language itself."))
			Result.append (divider)

			-- What Makes Eiffel Different
			Result.append (section_heading ("What Makes Eiffel Different"))
			Result.append (feature_block ("Contracts as first-class citizens", <<
				"<code>require</code>, <code>ensure</code>, <code>invariant</code> are language keywords",
				"Every feature can have preconditions and postconditions",
				"Every class can have invariants",
				"Runtime checks are automatic"
			>>))
			Result.append (feature_block ("Void safety", <<
				"No null pointer exceptions",
				"The type system prevents void calls",
				"%"The billion dollar mistake%" — solved"
			>>))
			Result.append (feature_block ("Multiple inheritance done right", <<
				"Inherit from multiple classes",
				"Rename, redefine, select to resolve conflicts",
				"Powerful composition patterns"
			>>))
			Result.append (feature_block ("Foundation-layer stability", <<
				"Eiffel operates at the C/C++ layer, not the React layer",
				"Code from 20 years ago still compiles",
				"No ecosystem fashion cycles to chase",
				"You escape framework churn by not depending on frameworks"
			>>))
			Result.append (divider)

			-- Honest Trade-offs
			Result.append (section_heading ("Honest Trade-offs"))
			Result.append (paragraph ("We believe in honesty. Here's what you're trading:"))
			Result.append (tradeoff_block ("Smaller community", <<
				"Stack Overflow won't have answers",
				"Fewer blog posts and tutorials",
				"You may need to figure things out yourself",
				"AI assistance + reference docs help significantly"
			>>))
			Result.append (tradeoff_block ("IDE lock-in", <<
				"EiffelStudio is the primary IDE",
				"No VS Code, no JetBrains (for now)",
				"AI-assisted workflow reduces IDE dependency"
			>>))
			Result.append (tradeoff_block ("Commercial perception", <<
				"%"Eiffel? Is that still around?%"",
				"May need to justify the choice",
				"Evidence and results speak louder than perception"
			>>))
			Result.append (divider)

			-- Why Now?
			Result.append (section_heading ("Why Now?"))
			Result.append (paragraph ("Eiffel has been excellent for 40 years. So why now?"))
			Result.append (paragraph ("<strong>AI changes the equation:</strong>"))
			Result.append (bullet_list (<<
				"AI generates code fast, but not verified",
				"DBC verifies code automatically",
				"The combination: speed + correctness"
			>>))
			Result.append (paragraph ("<strong>Reference documentation changes the equation:</strong>"))
			Result.append (bullet_list (<<
				"AI can be taught Eiffel patterns",
				"Institutional knowledge compounds",
				"The %"small community%" disadvantage shrinks"
			>>))
			Result.append (paragraph ("<strong>The moment is now.</strong>"))

			-- CTA
			Result.append ("<div class=%"mt-8 flex gap-4%">%N")
			Result.append (cta_button ("Get Started", "get-started"))
			Result.append (cta_button ("How DBC Works", "design-by-contract"))
			Result.append ("</div>%N")
		ensure then
			has_origin: Result.has_substring ("1986")
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

	feature_block (a_title: STRING; a_items: ARRAY [STRING]): STRING
			-- Generate a feature explanation block
		do
			create Result.make (400)
			Result.append ("<div class=%"mb-8%">%N")
			Result.append ("  <h4 class=%"font-medium mb-3 text-emerald-400%">" + a_title + "</h4>%N")
			Result.append ("  <ul class=%"space-y-1 text-sm%">%N")
			across 1 |..| a_items.count as idx loop
				Result.append ("    <li class=%"opacity-80%">• " + a_items[idx.item] + "</li>%N")
			end
			Result.append ("  </ul>%N")
			Result.append ("</div>%N")
		end

	tradeoff_block (a_title: STRING; a_items: ARRAY [STRING]): STRING
			-- Generate a tradeoff explanation block
		do
			create Result.make (400)
			Result.append ("<div class=%"mb-8%">%N")
			Result.append ("  <h4 class=%"font-medium mb-3 text-amber-400%">" + a_title + "</h4>%N")
			Result.append ("  <ul class=%"space-y-1 text-sm%">%N")
			across 1 |..| a_items.count as idx loop
				Result.append ("    <li class=%"opacity-80%">• " + a_items[idx.item] + "</li>%N")
			end
			Result.append ("  </ul>%N")
			Result.append ("</div>%N")
		end

end
