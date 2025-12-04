note
	description: "Get Started page - Gateway for developers ready to try"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_GET_STARTED_PAGE

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

	page_title: STRING = "Get Started"

	page_subtitle: STRING = "Start building with Eiffel + AI in under an hour."

	page_url: STRING = "/get-started"

feature -- Content

	page_content: STRING
			-- Main page content
		do
			create Result.make (10000)

			-- What You'll Need
			Result.append (section_heading ("What You'll Need"))
			Result.append (bullet_list (<<
				"A computer (Windows, macOS, or Linux)",
				"About 45 minutes",
				"Willingness to try something different"
			>>))
			Result.append (divider)

			-- Step 1
			Result.append (step_section ("1", "Install EiffelStudio",
				"EiffelStudio is the development environment for Eiffel. It's free for open-source development.",
				"https://www.eiffel.org/downloads", "Download EiffelStudio"))
			Result.append (expandable_section ("Installation notes for Windows",
				"Run the installer, accept defaults. Add EiffelStudio to your PATH. Restart your terminal."))
			Result.append (expandable_section ("Installation notes for macOS",
				"Download the DMG, drag to Applications. May need to allow in Security preferences."))
			Result.append (expandable_section ("Installation notes for Linux",
				"Extract the archive to /opt or your preferred location. Set ISE_EIFFEL and update PATH."))
			Result.append (divider)

			-- Step 2
			Result.append (step_section ("2", "Get AI Assistance",
				"The workflow shines with AI assistance. We recommend:",
				"", ""))
			Result.append (bullet_list (<<
				"<strong>Claude</strong> (Anthropic) — What we use. Excellent for Eiffel with proper reference documentation.",
				"<strong>Claude Code CLI</strong> — Direct file access, runs compiler.",
				"Other AI assistants work, but may need more guidance."
			>>))
			Result.append (divider)

			-- Step 3
			Result.append (step_section ("3", "Get the Reference Docs",
				"AI works best with context. Our reference documentation teaches AI the patterns and pitfalls.",
				"https://github.com/ljr1981/reference_docs", "Clone reference_docs"))
			Result.append (paragraph ("Key files to have AI read first:"))
			Result.append (bullet_list (<<
				"<code>CLAUDE_CONTEXT.md</code> — Eiffel fundamentals",
				"<code>gotchas.md</code> — Common pitfalls and solutions",
				"<code>patterns.md</code> — Verified working code"
			>>))
			Result.append (divider)

			-- Step 4
			Result.append (step_section ("4", "Build Something",
				"Start simple. Here's a first project:",
				"", ""))
			Result.append (code_block (
				"Create a simple calculator class with Design by Contract.%N" +
				"It should have add, subtract, multiply, divide.%N" +
				"Each feature should have preconditions and postconditions."))
			Result.append (paragraph ("Paste this to your AI assistant along with the reference docs. Watch what happens."))
			Result.append (divider)

			-- What to Expect
			Result.append (section_heading ("What to Expect"))
			Result.append (timeline_item ("First hour", <<
				"Environment setup",
				"First successful compile",
				"%"Hello World%" with a contract"
			>>))
			Result.append (timeline_item ("First day", <<
				"Comfortable with basic syntax",
				"Understanding preconditions/postconditions",
				"AI generating useful code"
			>>))
			Result.append (timeline_item ("First week", <<
				"Building real features",
				"Contracts catching bugs",
				"Productivity increasing"
			>>))
			Result.append (divider)

			-- Explore the Libraries
			Result.append (section_heading ("Explore the Libraries"))
			Result.append (paragraph ("Want to see real code? Clone any of our libraries:"))
			Result.append (bullet_list (<<
				external_link ("simple_json", "https://github.com/ljr1981/simple_json") + " — Good starting point, clear patterns",
				external_link ("simple_htmx", "https://github.com/ljr1981/simple_htmx") + " — See fluent interface design",
				external_link ("simple_alpine", "https://github.com/ljr1981/simple_alpine") + " — See library layering"
			>>))
			Result.append (paragraph ("All have tests you can run to see contracts in action."))
			Result.append (divider)

			-- Need Help?
			Result.append (section_heading ("Need Help?"))
			Result.append (bullet_list (<<
				"Eiffel community: " + external_link ("eiffel.org/community", "https://www.eiffel.org/community"),
				"Our repos: Issues welcome on GitHub",
				"Direct questions: See our contact info"
			>>))
		ensure then
			has_steps: Result.has_substring ("Step 1") and Result.has_substring ("Step 4")
		end

feature {NONE} -- Related Pages

	related_pages: HASH_TABLE [STRING, STRING]
			-- Related pages for footer
		do
			create Result.make (3)
			Result.put ("Portfolio", "portfolio")
			Result.put ("How DBC Works", "design-by-contract")
		end

feature {NONE} -- Content Helpers

	step_section (a_number, a_title, a_description, a_link_url, a_link_text: STRING): STRING
			-- Generate a step section
		do
			create Result.make (500)
			Result.append ("<div class=%"content-section%">%N")
			Result.append ("  <h3 class=%"text-xl font-medium mb-4%">")
			Result.append ("<span class=%"text-2xl font-bold opacity-50 mr-2%">Step " + a_number + "</span>")
			Result.append (a_title + "</h3>%N")
			Result.append ("  <p class=%"mb-4 opacity-90%">" + a_description + "</p>%N")
			if not a_link_url.is_empty then
				Result.append ("  <p>" + external_link (a_link_text, a_link_url) + "</p>%N")
			end
			Result.append ("</div>%N")
		end

	expandable_section (a_title, a_content: STRING): STRING
			-- Generate an expandable section with Alpine.js
		do
			create Result.make (400)
			Result.append ("<div x-data=%"{ open: false }%" class=%"mb-4 border border-white/10 rounded-lg overflow-hidden%">%N")
			Result.append ("  <button @click=%"open = !open%" class=%"w-full px-4 py-3 text-left text-sm flex justify-between items-center hover:bg-white/5%">%N")
			Result.append ("    <span>" + a_title + "</span>%N")
			Result.append ("    <span x-text=%"open ? '−' : '+'%"></span>%N")
			Result.append ("  </button>%N")
			Result.append ("  <div x-show=%"open%" x-collapse class=%"px-4 pb-4 text-sm opacity-70%">%N")
			Result.append ("    " + a_content + "%N")
			Result.append ("  </div>%N")
			Result.append ("</div>%N")
		end

	timeline_item (a_period: STRING; a_items: ARRAY [STRING]): STRING
			-- Generate a timeline item
		do
			create Result.make (300)
			Result.append ("<div class=%"mb-6%">%N")
			Result.append ("  <h4 class=%"font-medium mb-2%">" + a_period + "</h4>%N")
			Result.append (bullet_list (a_items))
			Result.append ("</div>%N")
		end

end
