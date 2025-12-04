note
	description: "Workflow page - Detailed explanation of human + AI collaboration"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_WORKFLOW_PAGE

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

	page_title: STRING = "The Human-AI Workflow"

	page_subtitle: STRING = "You're the pilot. Here's how the collaboration actually works."

	page_url: STRING = "/workflow"

feature -- Content

	page_content: STRING
			-- Main page content
		do
			create Result.make (12000)

			-- The Metaphor
			Result.append (section_heading ("The Metaphor: Your Airplane / My Airplane"))
			Result.append (paragraph ("In aviation, pilots explicitly transfer control:"))
			Result.append (bullet_list (<<
				"%"<strong>Your airplane</strong>%" — you take the controls",
				"%"<strong>My airplane</strong>%" — I'm flying now"
			>>))
			Result.append (paragraph ("AI-assisted development works the same way:"))

			Result.append ("<div class=%"grid md:grid-cols-2 gap-6 mb-8%">%N")
			Result.append (role_box ("Human (%"My airplane%")", <<
				"Setting direction and goals",
				"Architectural decisions",
				"Validating proposals",
				"Course corrections",
				"Final approval"
			>>, "text-emerald-400"))
			Result.append (role_box ("AI (%"Your airplane%")", <<
				"Code generation",
				"Pattern application",
				"Documentation",
				"Test creation",
				"Bulk operations"
			>>, "text-blue-400"))
			Result.append ("</div>%N")
			Result.append (paragraph ("<strong>You're always pilot-in-command.</strong> But workload shifts based on the task."))
			Result.append (divider)

			-- A Real Session
			Result.append (section_heading ("A Real Session"))
			Result.append (paragraph ("Here's an actual exchange from building simple_htmx:"))
			Result.append (session_transcript)
			Result.append (paragraph ("<strong>Result:</strong> 34 classes, 40 tests, 4 hours."))
			Result.append (divider)

			-- See It In Action
			Result.append (section_heading ("See It In Action"))
			Result.append (paragraph ("Watch real development sessions:"))
			Result.append ("<div class=%"grid md:grid-cols-2 gap-6 mb-8%">%N")
			Result.append (video_card ("Building with Eiffel + Claude", "Watch the human-AI workflow in practice.", "https://youtu.be/pbLIyEaB9uQ"))
			Result.append (video_card ("Contract-Verified Development", "See Design by Contract catching errors in real-time.", "https://youtu.be/aKSu0kmdiGA"))
			Result.append ("</div>%N")
			Result.append (divider)

			-- The Reference Documentation System
			Result.append (section_heading ("The Reference Documentation System"))
			Result.append (paragraph ("AI works best with context. We maintain living documentation:"))
			Result.append (bullet_list (<<
				"<code>CLAUDE_CONTEXT.md</code> — Eiffel fundamentals, session startup",
				"<code>gotchas.md</code> — Known pitfalls and solutions",
				"<code>patterns.md</code> — Verified working code patterns",
				"Project ROADMAPs — Project-specific context"
			>>))
			Result.append (paragraph ("When AI reads these first, accuracy goes from ~60%% to ~95%%."))
			Result.append (paragraph ("The documentation captures institutional knowledge. AI gets smarter with every session. Mistakes don't repeat."))
			Result.append (divider)

			-- The Verification Layer
			Result.append (section_heading ("The Verification Layer"))
			Result.append (paragraph ("AI writes code. But who checks AI?"))
			Result.append ("<div class=%"space-y-3 mb-8%">%N")
			Result.append (verification_layer ("Layer 1: Compiler", "Type errors caught immediately"))
			Result.append (verification_layer ("Layer 2: Contracts", "Runtime verification of correctness"))
			Result.append (verification_layer ("Layer 3: Tests", "Specific scenarios validated"))
			Result.append (verification_layer ("Layer 4: Human", "Final review and approval"))
			Result.append ("</div>%N")
			Result.append (paragraph ("<strong>Most AI errors are caught at Layers 1-2.</strong> Before human review. Before production."))
			Result.append (divider)

			-- What Makes It Work
			Result.append (section_heading ("What Makes It Work"))
			Result.append ("<div class=%"grid md:grid-cols-2 lg:grid-cols-3 gap-4 mb-8%">%N")
			Result.append (principle_card ("1", "Clear Direction", "AI needs to know what you want"))
			Result.append (principle_card ("2", "Reference Context", "AI needs to know your patterns"))
			Result.append (principle_card ("3", "Rapid Feedback", "Compiler/contracts catch errors fast"))
			Result.append (principle_card ("4", "Iteration", "Build incrementally, verify continuously"))
			Result.append (principle_card ("5", "Human Judgment", "You're always the decision-maker"))
			Result.append ("</div>%N")
			Result.append (divider)

			-- Productivity Results
			Result.append (section_heading ("Productivity Results"))
			Result.append ("<div class=%"grid grid-cols-2 gap-6 mb-8%">%N")
			Result.append ("<div class=%"text-center%">%N")
			Result.append ("  <div class=%"text-4xl font-bold mb-2%">40-80x</div>%N")
			Result.append ("  <div class=%"text-sm opacity-70%">Measured multiplier</div>%N")
			Result.append ("</div>%N")
			Result.append ("<div class=%"text-center%">%N")
			Result.append ("  <div class=%"text-4xl font-bold mb-2%">Days</div>%N")
			Result.append ("  <div class=%"text-sm opacity-70%">vs. traditional months</div>%N")
			Result.append ("</div>%N")
			Result.append ("</div>%N")
			Result.append (paragraph ("This isn't hype. This is measured output."))

			-- CTA
			Result.append ("<div class=%"mt-8%">%N")
			Result.append (cta_button ("See the Competitive Analysis", "analysis"))
			Result.append ("</div>%N")
		ensure then
			has_metaphor: Result.has_substring ("airplane")
		end

feature {NONE} -- Related Pages

	related_pages: HASH_TABLE [STRING, STRING]
			-- Related pages for footer
		do
			create Result.make (3)
			Result.put ("Get Started", "get-started")
			Result.put ("Competitive Analysis", "analysis")
		end

feature {NONE} -- Content Helpers

	role_box (a_title: STRING; a_items: ARRAY [STRING]; a_color: STRING): STRING
			-- Generate a role responsibility box
		do
			create Result.make (400)
			Result.append ("<div class=%"card%">%N")
			Result.append ("  <h4 class=%"font-medium mb-4 " + a_color + "%">" + a_title + "</h4>%N")
			Result.append ("  <ul class=%"space-y-2%">%N")
			across 1 |..| a_items.count as idx loop
				Result.append ("    <li class=%"text-sm opacity-80%">• " + a_items[idx.item] + "</li>%N")
			end
			Result.append ("  </ul>%N")
			Result.append ("</div>%N")
		end

	session_transcript: STRING
			-- Example session transcript
		do
			create Result.make (800)
			Result.append ("<div class=%"bg-[#1a1a1a] rounded-lg p-6 mb-6 text-sm space-y-4%">%N")
			Result.append ("  <div><span class=%"text-emerald-400%">HUMAN:</span> %"Build a fluent HTML builder for HTMX attributes.%"</div>%N")
			Result.append ("  <div><span class=%"text-blue-400%">AI:</span> %"I'll create an HTMX_ELEMENT base class with attribute storage via hash table, fluent methods returning 'like Current', HTML escaping for security...%"</div>%N")
			Result.append ("  <div><span class=%"text-emerald-400%">HUMAN:</span> %"Use TEST_SET_BASE for tests, not EQA_TEST_SET.%"</div>%N")
			Result.append ("  <div><span class=%"text-blue-400%">AI:</span> <em>[Adjusts approach, generates code]</em></div>%N")
			Result.append ("  <div><span class=%"text-amber-400%">COMPILER:</span> %"VKCN(1): Function used as statement%"</div>%N")
			Result.append ("  <div><span class=%"text-blue-400%">AI:</span> %"Adding .do_nothing to fluent chains to satisfy compiler.%"</div>%N")
			Result.append ("</div>%N")
		end

	verification_layer (a_layer, a_description: STRING): STRING
			-- Generate a verification layer item
		do
			create Result.make (200)
			Result.append ("<div class=%"flex items-center gap-4%">%N")
			Result.append ("  <span class=%"font-medium w-40%">" + a_layer + "</span>%N")
			Result.append ("  <span class=%"text-sm opacity-70%">" + a_description + "</span>%N")
			Result.append ("</div>%N")
		end

	principle_card (a_number, a_title, a_description: STRING): STRING
			-- Generate a principle card
		do
			create Result.make (250)
			Result.append ("<div class=%"card%">%N")
			Result.append ("  <div class=%"text-2xl font-bold opacity-30 mb-2%">" + a_number + "</div>%N")
			Result.append ("  <h4 class=%"font-medium mb-1%">" + a_title + "</h4>%N")
			Result.append ("  <p class=%"text-sm opacity-70%">" + a_description + "</p>%N")
			Result.append ("</div>%N")
		end

	video_card (a_title, a_description, a_url: STRING): STRING
			-- Generate a video card with YouTube link
		require
			title_not_empty: not a_title.is_empty
			description_not_empty: not a_description.is_empty
			url_not_empty: not a_url.is_empty
		do
			create Result.make (400)
			Result.append ("<div class=%"card group%">%N")
			Result.append ("  <a href=%"" + a_url + "%" target=%"_blank%" class=%"block%">%N")
			Result.append ("    <div class=%"flex items-center gap-3 mb-3%">%N")
			Result.append ("      <span class=%"text-2xl%">▶</span>%N")
			Result.append ("      <h4 class=%"font-medium group-hover:text-blue-400 transition-colors%">" + a_title + "</h4>%N")
			Result.append ("    </div>%N")
			Result.append ("    <p class=%"text-sm opacity-70 mb-3%">" + a_description + "</p>%N")
			Result.append ("    <span class=%"text-xs text-blue-400 opacity-60 group-hover:opacity-100 transition-opacity%">Watch on YouTube ↗</span>%N")
			Result.append ("  </a>%N")
			Result.append ("</div>%N")
		ensure
			not_empty: not Result.is_empty
			has_title: Result.has_substring (a_title)
			has_url: Result.has_substring (a_url)
		end

end
