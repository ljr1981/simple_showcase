note
	description: "Design by Contract page - Technical explainer for developers"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_DBC_PAGE

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

	page_title: STRING = "How Design by Contract Works"

	page_subtitle: STRING = "The code tells you what it guarantees. The runtime enforces those guarantees. Automatically."

	page_url: STRING = "/design-by-contract"

feature -- Content

	page_content: STRING
			-- Main page content
		do
			create Result.make (15000)

			-- The Core Idea
			Result.append (section_heading ("The Core Idea"))
			Result.append (paragraph ("Every feature (method) is a contract between caller and implementation:"))
			Result.append ("<div class=%"space-y-4 mb-8%">%N")
			Result.append (contract_type_box ("PRECONDITIONS", "require",
				"What must be true before the feature runs",
				"%"I require these conditions to do my job.%""))
			Result.append (contract_type_box ("POSTCONDITIONS", "ensure",
				"What will be true after the feature runs",
				"%"I guarantee these results when I'm done.%""))
			Result.append (contract_type_box ("INVARIANTS", "invariant",
				"What's always true about an object",
				"%"This is always true about me, before and after every call.%""))
			Result.append ("</div>%N")
			Result.append (divider)

			-- A Real Example
			Result.append (section_heading ("A Real Example"))
			Result.append (paragraph ("Let's build a bank account:"))
			Result.append (code_block (bank_account_example))
			Result.append (paragraph ("What this guarantees:"))
			Result.append (bullet_list (<<
				"You can't withdraw zero or negative amounts",
				"You can't withdraw more than you have",
				"After withdrawal, balance is exactly what you expect",
				"Balance can never go negative, ever"
			>>))
			Result.append (paragraph ("<strong>Try to violate any of these?</strong> Runtime exception with exact location."))
			Result.append (divider)

			-- What Happens When AI Writes Code
			Result.append (section_heading ("What Happens When AI Writes Code"))
			Result.append ("<div class=%"grid md:grid-cols-2 gap-6 mb-8%">%N")
			Result.append (comparison_box ("Without Contracts", <<
				"AI writes withdraw function",
				"Maybe it checks for sufficient funds, maybe not",
				"Maybe there's a bug in the calculation",
				"You find out in production. Or you don't."
			>>, "text-red-400"))
			Result.append (comparison_box ("With Contracts", <<
				"AI writes withdraw function with contracts",
				"First test run: %"POSTCONDITION VIOLATION: balance_reduced%"",
				"Bug found instantly. Exact location. Exact expectation.",
				"AI fixes it. Contracts pass. Ship with confidence."
			>>, "text-emerald-400"))
			Result.append ("</div>%N")
			Result.append (paragraph ("The contracts are the specification. The runtime is the verifier. AI mistakes don't reach production."))
			Result.append (divider)

			-- Types of Contracts
			Result.append (section_heading ("Types of Contracts"))
			Result.append (contract_detail ("Preconditions (require)",
				"Guard inputs before execution. The caller's responsibility.",
				"require%N    positive_amount: amount > 0%N    sufficient_funds: amount <= balance"))
			Result.append (contract_detail ("Postconditions (ensure)",
				"Verify outputs after execution. The feature's promise.",
				"ensure%N    balance_reduced: balance = old balance - amount%N    non_negative: balance >= 0"))
			Result.append (contract_detail ("Class Invariants (invariant)",
				"Always true for the object. Checked after every public call.",
				"invariant%N    non_negative_balance: balance >= 0%N    valid_account_number: account_number.count = 10"))
			Result.append (contract_detail ("Check Assertions",
				"Mid-execution checks for debugging and documentation.",
				"check%N    valid_state: is_initialized%Nend"))
			Result.append (divider)

			-- The "old" Keyword
			Result.append (section_heading ("The %"old%" Keyword"))
			Result.append (paragraph ("One of the most powerful features: comparing before and after."))
			Result.append (code_block ("ensure%N    count_increased: items.count = old items.count + 1"))
			Result.append (paragraph ("<code>old items.count</code> captures the value BEFORE the feature ran. This lets you specify exactly how state should change."))
			Result.append (divider)

			-- Contracts vs Tests
			Result.append (section_heading ("Contracts vs. Tests"))
			Result.append ("<div class=%"grid md:grid-cols-2 gap-6 mb-8%">%N")
			Result.append ("<div class=%"card%">%N")
			Result.append ("  <h4 class=%"font-medium mb-2%">Tests</h4>%N")
			Result.append ("  <p class=%"text-sm opacity-70%">%"Here are some examples that should work.%"</p>%N")
			Result.append ("  <p class=%"text-sm opacity-70 mt-2%">Check specific cases.</p>%N")
			Result.append ("</div>%N")
			Result.append ("<div class=%"card%">%N")
			Result.append ("  <h4 class=%"font-medium mb-2%">Contracts</h4>%N")
			Result.append ("  <p class=%"text-sm opacity-70%">%"Here is what must ALWAYS be true.%"</p>%N")
			Result.append ("  <p class=%"text-sm opacity-70 mt-2%">Check every execution.</p>%N")
			Result.append ("</div>%N")
			Result.append ("</div>%N")
			Result.append (paragraph ("Tests are valuable. Contracts are comprehensive. Use both. But contracts catch what tests miss."))
			Result.append (divider)

			-- Why This Matters for AI
			Result.append (section_heading ("Why This Matters for AI"))
			Result.append (paragraph ("AI generates statistically likely code. %"Likely%" isn't %"correct.%""))
			Result.append (paragraph ("Contracts turn %"I hope this works%" into %"This is proven to work.%""))
			Result.append (paragraph ("<strong>That's the unlock.</strong>"))

			-- CTA
			Result.append ("<div class=%"mt-8 flex gap-4%">%N")
			Result.append (cta_button ("Get Started", "get-started"))
			Result.append (cta_button ("See the Evidence", "portfolio"))
			Result.append ("</div>%N")
		ensure then
			has_examples: Result.has_substring ("BANK_ACCOUNT")
		end

feature {NONE} -- Related Pages

	related_pages: HASH_TABLE [STRING, STRING]
			-- Related pages for footer
		do
			create Result.make (3)
			Result.put ("Probable to Provable", "probable-to-provable")
			Result.put ("The Workflow", "workflow")
		end

feature {NONE} -- Content Helpers

	bank_account_example: STRING
			-- Bank account DBC example
		do
			create Result.make (800)
			Result.append ("class BANK_ACCOUNT%N%N")
			Result.append ("feature -- Access%N%N")
			Result.append ("    balance: DECIMAL%N")
			Result.append ("        -- Current account balance%N%N")
			Result.append ("feature -- Operations%N%N")
			Result.append ("    withdraw (amount: DECIMAL)%N")
			Result.append ("        -- Withdraw amount from account%N")
			Result.append ("        <span class=%"text-amber-400%">require</span>%N")
			Result.append ("            positive_amount: amount > 0%N")
			Result.append ("            sufficient_funds: amount <= balance%N")
			Result.append ("        <span class=%"text-blue-400%">do</span>%N")
			Result.append ("            balance := balance - amount%N")
			Result.append ("        <span class=%"text-emerald-400%">ensure</span>%N")
			Result.append ("            balance_reduced: balance = old balance - amount%N")
			Result.append ("        <span class=%"text-blue-400%">end</span>%N%N")
			Result.append ("<span class=%"text-purple-400%">invariant</span>%N")
			Result.append ("    non_negative_balance: balance >= 0%N%N")
			Result.append ("end")
		end

	contract_type_box (a_title, a_keyword, a_description, a_quote: STRING): STRING
			-- Generate a contract type explanation box
		do
			create Result.make (300)
			Result.append ("<div class=%"card%">%N")
			Result.append ("  <h4 class=%"font-medium mb-1%">" + a_title + " (<code>" + a_keyword + "</code>)</h4>%N")
			Result.append ("  <p class=%"text-sm opacity-70 mb-2%">" + a_description + "</p>%N")
			Result.append ("  <p class=%"text-sm italic opacity-60%">" + a_quote + "</p>%N")
			Result.append ("</div>%N")
		end

	comparison_box (a_title: STRING; a_items: ARRAY [STRING]; a_color: STRING): STRING
			-- Generate a comparison box
		do
			create Result.make (400)
			Result.append ("<div class=%"card%">%N")
			Result.append ("  <h4 class=%"font-medium mb-4 " + a_color + "%">" + a_title + "</h4>%N")
			Result.append ("  <ul class=%"text-sm space-y-2%">%N")
			across 1 |..| a_items.count as idx loop
				Result.append ("    <li class=%"opacity-80%">• " + a_items[idx.item] + "</li>%N")
			end
			Result.append ("  </ul>%N")
			Result.append ("</div>%N")
		end

	contract_detail (a_title, a_description, a_example: STRING): STRING
			-- Generate a detailed contract explanation
		do
			create Result.make (400)
			Result.append ("<div class=%"mb-6%">%N")
			Result.append ("  <h4 class=%"font-medium mb-2%">" + a_title + "</h4>%N")
			Result.append ("  <p class=%"text-sm opacity-80 mb-3%">" + a_description + "</p>%N")
			Result.append (code_block (a_example))
			Result.append ("</div>%N")
		end

end
