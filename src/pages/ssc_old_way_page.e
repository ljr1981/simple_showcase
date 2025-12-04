note
	description: "Old Way page - Expanded pain points for recognition/empathy"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_OLD_WAY_PAGE

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

	page_title: STRING = "The Real Cost of the Old Way"

	page_subtitle: STRING = "The friction you've learned to live with."

	page_url: STRING = "/old-way"

feature -- Content

	page_content: STRING
			-- Main page content
		do
			create Result.make (10000)

			-- Dependency Hell
			Result.append (pain_section ("Dependency Hell",
				"%"npm install%" for a simple project. node_modules: 500 packages. You wrote 200 lines. You're responsible for 2 million.",
				<<
					"Then the security advisory:",
					"%"Critical vulnerability in left-pad-utils-helper-lite%"",
					"You've never heard of it.",
					"It's four dependencies deep.",
					"It's in production."
				>>))

			-- Ecosystem Fashion Cycles
			Result.append (pain_section ("Ecosystem Fashion Cycles",
				"The languages underneath are stable. C is still C. The churn is market-driven fashion, not technical necessity.",
				<<
					"2018: %"React Hooks change everything!%"",
					"2020: %"Server Components are the future!%"",
					"2022: %"Signals are the new paradigm!%"",
					"2024: %"AI-first frameworks are here!%""
				>>))
			Result.append (paragraph ("Every 18 months: Rewrite. Every 18 months: Relearn. The foundation didn't change—the fashion did."))
			Result.append (divider)

			-- Meetings That Should Be Code
			Result.append (pain_section ("Meetings That Should Be Code",
				"",
				<<
					"Week 1: %"Which database should we use?%"",
					"Week 2: %"Let's evaluate three ORMs.%"",
					"Week 3: %"We need to align on architecture.%"",
					"Week 4: %"Stakeholder review of the tech stack.%"",
					"Week 5: %"Let's revisit the database decision.%""
				>>))
			Result.append (paragraph ("<strong>Meanwhile: Nothing shipped.</strong>"))
			Result.append (divider)

			-- The Bug That "Shouldn't Have Happened"
			Result.append (pain_section ("The Bug That %"Shouldn't Have Happened%"",
				"",
				<<
					"The code looked right.",
					"The tests passed.",
					"Code review approved.",
					"",
					"Production: NullPointerException at 2 AM.",
					"",
					"%"But that should never be null there.%"",
					"%"The tests cover this.%"",
					"%"It worked in staging.%""
				>>))
			Result.append (paragraph ("<strong>Surprise. Hope isn't a strategy.</strong>"))
			Result.append (divider)

			-- The Cost Adds Up
			Result.append (section_heading ("The Cost Adds Up"))
			Result.append ("<div class=%"grid grid-cols-2 gap-4 mb-8%">%N")
			Result.append (cost_line ("Hours spent on dependency updates"))
			Result.append (cost_line ("Hours spent on framework migrations"))
			Result.append (cost_line ("Hours spent in decision meetings"))
			Result.append (cost_line ("Hours spent debugging %"impossible%" bugs"))
			Result.append ("</div>%N")
			Result.append (paragraph ("<strong>What could you have built instead?</strong>"))
			Result.append (divider)

			-- There's Another Way
			Result.append (section_heading ("There's Another Way"))
			Result.append ("<div class=%"grid grid-cols-2 md:grid-cols-4 gap-4 mb-8 text-center%">%N")
			Result.append (contrast_item ("Not hope.", "Proof."))
			Result.append (contrast_item ("Not dependencies.", "Ownership."))
			Result.append (contrast_item ("Not fashion.", "Foundations."))
			Result.append (contrast_item ("Not meetings.", "Building."))
			Result.append ("</div>%N")

			-- CTA
			Result.append ("<div class=%"mt-8 flex gap-4%">%N")
			Result.append (cta_button ("See What Got Built", "portfolio"))
			Result.append (cta_button ("Get Started", "get-started"))
			Result.append ("</div>%N")
		ensure then
			has_pain_points: Result.has_substring ("Dependency Hell")
		end

feature {NONE} -- Related Pages

	related_pages: HASH_TABLE [STRING, STRING]
			-- Related pages for footer
		do
			create Result.make (3)
			Result.put ("Portfolio", "portfolio")
			Result.put ("What AI Changes", "ai-changes")
		end

feature {NONE} -- Content Helpers

	pain_section (a_title, a_intro: STRING; a_items: ARRAY [STRING]): STRING
			-- Generate a pain point section
		do
			create Result.make (600)
			Result.append ("<div class=%"mb-8%">%N")
			Result.append ("  <h2 class=%"text-2xl font-medium mb-4 text-red-400%">" + a_title + "</h2>%N")
			if not a_intro.is_empty then
				Result.append ("  <p class=%"mb-4 opacity-90%">" + a_intro + "</p>%N")
			end
			Result.append ("  <div class=%"bg-[#1a1a1a] rounded-lg p-6 space-y-2%">%N")
			across 1 |..| a_items.count as idx loop
				if a_items[idx.item].is_empty then
					Result.append ("    <div class=%"h-4%"></div>%N")
				else
					Result.append ("    <div class=%"text-sm opacity-80%">" + a_items[idx.item] + "</div>%N")
				end
			end
			Result.append ("  </div>%N")
			Result.append ("</div>%N")
			Result.append (divider)
		end

	cost_line (a_text: STRING): STRING
			-- Generate a cost calculation line
		do
			create Result.make (150)
			Result.append ("<div class=%"card flex justify-between items-center%">%N")
			Result.append ("  <span class=%"text-sm opacity-70%">" + a_text + "</span>%N")
			Result.append ("  <span class=%"font-bold%">___</span>%N")
			Result.append ("</div>%N")
		end

	contrast_item (a_not, a_but: STRING): STRING
			-- Generate a contrast item
		do
			create Result.make (200)
			Result.append ("<div class=%"card%">%N")
			Result.append ("  <div class=%"text-sm opacity-50 line-through mb-1%">" + a_not + "</div>%N")
			Result.append ("  <div class=%"text-lg font-medium text-emerald-400%">" + a_but + "</div>%N")
			Result.append ("</div>%N")
		end

end
