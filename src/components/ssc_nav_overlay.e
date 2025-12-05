note
	description: "Fixed navigation overlay with Home/Up/Down buttons"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_NAV_OVERLAY

inherit
	SSC_SHARED

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize nav overlay
		do
			-- Nothing needed
		end

feature -- Access

	section_ids: ARRAY [STRING]
			-- Ordered list of section IDs for navigation
		once
			Result := <<"hero", "recognition", "shift", "problem", "unlock", "evidence", "revelation", "workflow", "invitation">>
		ensure
			has_sections: Result.count > 0
			starts_with_hero: Result[1].same_string ("hero")
		end

feature -- Generation

	to_html: STRING
			-- Generate nav overlay HTML with Alpine.js logic
		do
			create Result.make (3000)
			Result.append ("<div class=%"fixed right-6 top-1/2 -translate-y-1/2 z-50 flex flex-col gap-3%"")
			Result.append (" x-data=%"navOverlay()%">%N")

			-- Home button (always visible)
			Result.append ("  <button @click=%"goHome()%" ")
			Result.append ("class=%"w-10 h-10 rounded-full bg-white/10 hover:bg-white/20 backdrop-blur-sm flex items-center justify-center transition-all%" ")
			Result.append ("title=%"Home%">%N")
			Result.append ("    <span class=%"text-lg%">&#8962;</span>%N")
			Result.append ("  </button>%N")

			-- Up button (hidden on first section)
			Result.append ("  <button x-show=%"currentSection > 0%" @click=%"goUp()%" ")
			Result.append ("x-transition:enter=%"transition ease-out duration-200%" ")
			Result.append ("x-transition:enter-start=%"opacity-0 scale-75%" ")
			Result.append ("x-transition:enter-end=%"opacity-100 scale-100%" ")
			Result.append ("x-transition:leave=%"transition ease-in duration-150%" ")
			Result.append ("x-transition:leave-start=%"opacity-100 scale-100%" ")
			Result.append ("x-transition:leave-end=%"opacity-0 scale-75%" ")
			Result.append ("class=%"w-10 h-10 rounded-full bg-white/10 hover:bg-white/20 backdrop-blur-sm flex items-center justify-center transition-all%" ")
			Result.append ("title=%"Previous section%">%N")
			Result.append ("    <span class=%"text-lg%">&#8593;</span>%N")
			Result.append ("  </button>%N")

			-- Down button (hidden on last section)
			Result.append ("  <button x-show=%"currentSection < " + (section_ids.count - 1).out + "%" @click=%"goDown()%" ")
			Result.append ("x-transition:enter=%"transition ease-out duration-200%" ")
			Result.append ("x-transition:enter-start=%"opacity-0 scale-75%" ")
			Result.append ("x-transition:enter-end=%"opacity-100 scale-100%" ")
			Result.append ("x-transition:leave=%"transition ease-in duration-150%" ")
			Result.append ("x-transition:leave-start=%"opacity-100 scale-100%" ")
			Result.append ("x-transition:leave-end=%"opacity-0 scale-75%" ")
			Result.append ("class=%"w-10 h-10 rounded-full bg-white/10 hover:bg-white/20 backdrop-blur-sm flex items-center justify-center transition-all%" ")
			Result.append ("title=%"Next section%">%N")
			Result.append ("    <span class=%"text-lg%">&#8595;</span>%N")
			Result.append ("  </button>%N")

			-- Section indicator dots (clickable with larger hit area)
			Result.append ("  <div class=%"flex flex-col items-center mt-2%">%N")
			across 0 |..| (section_ids.count - 1) as idx loop
				Result.append ("    <button @click=%"goToSection(" + idx.item.out + ")%" ")
				Result.append ("class=%"p-2 group cursor-pointer%" ")
				Result.append ("title=%"" + section_ids[idx.item + 1] + "%">")
				Result.append ("<span class=%"block w-3 h-3 rounded-full transition-all group-hover:scale-125%" ")
				Result.append (":class=%"currentSection === " + idx.item.out + " ? 'bg-white scale-110' : 'bg-white/50'%"></span>")
				Result.append ("</button>%N")
			end
			Result.append ("  </div>%N")

			Result.append ("</div>%N")
		ensure
			not_empty: not Result.is_empty
			has_nav_component: Result.has_substring ("navOverlay()")
			has_home_button: Result.has_substring ("goHome()")
		end

feature -- JavaScript

	nav_script: STRING
			-- Alpine.js component for navigation
		do
			create Result.make (2000)
			Result.append ("  Alpine.data('navOverlay', () => ({%N")
			Result.append ("    currentSection: 0,%N")
			Result.append ("    sections: [")
			across 1 |..| section_ids.count as idx loop
				Result.append ("'" + section_ids[idx.item] + "'")
				if idx.item < section_ids.count then
					Result.append (", ")
				end
			end
			Result.append ("],%N")
			Result.append ("    init() {%N")
			Result.append ("      this.updateCurrentSection();%N")
			Result.append ("      document.querySelector('.snap-container').addEventListener('scroll', () => this.updateCurrentSection());%N")
			Result.append ("    },%N")
			Result.append ("    updateCurrentSection() {%N")
			Result.append ("      const container = document.querySelector('.snap-container');%N")
			Result.append ("      const scrollTop = container.scrollTop;%N")
			Result.append ("      const vh = container.clientHeight;%N")
			Result.append ("      this.currentSection = Math.round(scrollTop / vh);%N")
			Result.append ("    },%N")
			Result.append ("    goHome() {%N")
			Result.append ("      document.getElementById('hero').scrollIntoView({ behavior: 'smooth' });%N")
			Result.append ("    },%N")
			Result.append ("    goUp() {%N")
			Result.append ("      if (this.currentSection > 0) {%N")
			Result.append ("        document.getElementById(this.sections[this.currentSection - 1]).scrollIntoView({ behavior: 'smooth' });%N")
			Result.append ("      }%N")
			Result.append ("    },%N")
			Result.append ("    goDown() {%N")
			Result.append ("      if (this.currentSection < this.sections.length - 1) {%N")
			Result.append ("        document.getElementById(this.sections[this.currentSection + 1]).scrollIntoView({ behavior: 'smooth' });%N")
			Result.append ("      }%N")
			Result.append ("    },%N")
			Result.append ("    goToSection(index) {%N")
			Result.append ("      document.getElementById(this.sections[index]).scrollIntoView({ behavior: 'smooth' });%N")
			Result.append ("    }%N")
			Result.append ("  }));%N")
		ensure
			not_empty: not Result.is_empty
			has_component_def: Result.has_substring ("Alpine.data('navOverlay'")
			has_all_methods: Result.has_substring ("goHome()") and Result.has_substring ("goUp()") and Result.has_substring ("goDown()")
		end

end
