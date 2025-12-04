note
	description: "Landing page with all 8 sections"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_LANDING_PAGE

inherit
	SSC_PAGE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize landing page
		do
			create hero_section.make
			create recognition_section.make
			create shift_section.make
			create problem_section.make
			create unlock_section.make
			create evidence_section.make
			create revelation_section.make
			create workflow_section.make
			create invitation_section.make
		end

feature -- Access

	title: STRING = "Simple Showcase"

	description: STRING = "11 libraries. 900+ tests. 10 days. One person. AI-assisted, contract-verified development."

feature -- Sections

	hero_section: SSC_HERO_SECTION
	recognition_section: SSC_RECOGNITION_SECTION
	shift_section: SSC_SHIFT_SECTION
	problem_section: SSC_PROBLEM_SECTION
	unlock_section: SSC_UNLOCK_SECTION
	evidence_section: SSC_EVIDENCE_SECTION
	revelation_section: SSC_REVELATION_SECTION
	workflow_section: SSC_WORKFLOW_SECTION
	invitation_section: SSC_INVITATION_SECTION

feature -- Generation

	body_content: STRING
			-- Generate all sections
		local
			l_main: ALPINE_DIV
		do
			create Result.make (50000)

			-- Scroll snap container
			l_main := alpine.div
			l_main.class_ ("snap-container")

			-- Add all sections
			l_main.raw_html (hero_section.to_html)
			l_main.raw_html (recognition_section.to_html)
			l_main.raw_html (shift_section.to_html)
			l_main.raw_html (problem_section.to_html)
			l_main.raw_html (unlock_section.to_html)
			l_main.raw_html (evidence_section.to_html)
			l_main.raw_html (revelation_section.to_html)
			l_main.raw_html (workflow_section.to_html)
			l_main.raw_html (invitation_section.to_html)

			Result.append (l_main.to_html)
		end

feature {NONE} -- Factory

	alpine: ALPINE_FACTORY
			-- Factory for Alpine.js elements
		once
			create Result
		end

end
