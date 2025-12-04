note
	description: "Universal hamburger menu for site-wide navigation"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_HAMBURGER_MENU

inherit
	SSC_SHARED

create
	make,
	make_hidden_until_scroll

feature {NONE} -- Initialization

	make
			-- Initialize hamburger menu (always visible)
		do
			hide_until_scroll := False
		ensure
			always_visible: not hide_until_scroll
		end

	make_hidden_until_scroll
			-- Initialize hamburger menu that appears on scroll (for landing page)
		do
			hide_until_scroll := True
		ensure
			hidden_initially: hide_until_scroll
		end

feature -- Status

	hide_until_scroll: BOOLEAN
			-- Should menu be hidden until user scrolls?

feature -- Access

	page_count: INTEGER = 12
			-- Number of navigation pages

	page_titles: ARRAY [STRING]
			-- Page titles
		once
			Result := <<"Home", "Get Started", "Portfolio", "Design by Contract", "Workflow",
				"Analysis", "Business Case", "Why Eiffel", "Probable to Provable", "The Old Way", "AI Changes", "Contact">>
		end

	page_urls: ARRAY [STRING]
			-- Page URLs (relative for base tag compatibility)
		once
			Result := <<".", "get-started", "portfolio", "design-by-contract", "workflow",
				"analysis", "business-case", "why-eiffel", "probable-to-provable", "old-way", "ai-changes", "contact">>
		end

	page_descriptions: ARRAY [STRING]
			-- Page descriptions
		once
			Result := <<"Back to landing page", "Start building with Eiffel + AI", "See the project evidence",
				"How DBC works", "The human-AI collaboration", "Competitive analysis", "ROI and risk analysis",
				"Language choice explained", "The core framework", "Traditional approach costs", "What AI actually changes",
				"Get in touch">>
		end

feature -- Generation

	to_html: STRING
			-- Generate hamburger menu HTML with Alpine.js
		local
			i: INTEGER
		do
			create Result.make (4000)

			-- Container with Alpine.js state (optionally hidden until scroll)
			if hide_until_scroll then
				Result.append ("<div class=%"fixed top-4 left-4 z-50 transition-all duration-300%" ")
				Result.append ("x-data=%"{ menuOpen: false, visible: false }%" ")
				-- Listen to .snap-container scroll (landing page uses custom scroll container)
				Result.append ("x-init=%"")
				Result.append ("const container = document.querySelector('.snap-container'); ")
				Result.append ("if (container) { container.addEventListener('scroll', () => { visible = container.scrollTop > 100 }); } ")
				Result.append ("else { window.addEventListener('scroll', () => { visible = window.scrollY > 100 }); }%" ")
				Result.append ("x-show=%"visible%" ")
				Result.append ("x-transition:enter=%"transition ease-out duration-300%" ")
				Result.append ("x-transition:enter-start=%"opacity-0 -translate-y-4%" ")
				Result.append ("x-transition:enter-end=%"opacity-100 translate-y-0%" ")
				Result.append (">%N")
			else
				Result.append ("<div class=%"fixed top-4 left-4 z-50%" x-data=%"{ menuOpen: false }%">%N")
			end

			-- Hamburger button
			Result.append ("  <button @click=%"menuOpen = !menuOpen%" ")
			Result.append ("class=%"w-12 h-12 rounded-full bg-[" + color_primary_dark + "]/80 backdrop-blur-sm border border-white/10 ")
			Result.append ("flex items-center justify-center hover:bg-white/10 transition-all%" ")
			Result.append ("aria-label=%"Navigation menu%">%N")
			Result.append ("    <div class=%"flex flex-col gap-1.5%">%N")
			Result.append ("      <span class=%"block w-5 h-0.5 bg-white/80 transition-all%" ")
			Result.append (":class=%"menuOpen ? 'rotate-45 translate-y-2' : ''%"></span>%N")
			Result.append ("      <span class=%"block w-5 h-0.5 bg-white/80 transition-all%" ")
			Result.append (":class=%"menuOpen ? 'opacity-0' : ''%"></span>%N")
			Result.append ("      <span class=%"block w-5 h-0.5 bg-white/80 transition-all%" ")
			Result.append (":class=%"menuOpen ? '-rotate-45 -translate-y-2' : ''%"></span>%N")
			Result.append ("    </div>%N")
			Result.append ("  </button>%N")

			-- Menu panel (slides in from left)
			Result.append ("  <div x-show=%"menuOpen%" ")
			Result.append ("x-transition:enter=%"transition ease-out duration-200%" ")
			Result.append ("x-transition:enter-start=%"opacity-0 -translate-x-4%" ")
			Result.append ("x-transition:enter-end=%"opacity-100 translate-x-0%" ")
			Result.append ("x-transition:leave=%"transition ease-in duration-150%" ")
			Result.append ("x-transition:leave-start=%"opacity-100 translate-x-0%" ")
			Result.append ("x-transition:leave-end=%"opacity-0 -translate-x-4%" ")
			Result.append ("@click.outside=%"menuOpen = false%" ")
			Result.append ("class=%"absolute top-14 left-0 w-[calc(100vw-2rem)] sm:w-72 max-w-72 bg-[" + color_primary_dark + "]/95 backdrop-blur-md ")
			Result.append ("rounded-lg border border-white/10 shadow-2xl overflow-hidden%">%N")

			-- Menu header
			Result.append ("    <div class=%"px-4 py-3 border-b border-white/10%">%N")
			Result.append ("      <span class=%"text-sm font-medium opacity-60%">Navigate</span>%N")
			Result.append ("    </div>%N")

			-- Menu items
			Result.append ("    <nav class=%"py-2 max-h-[70vh] overflow-y-auto%">%N")
			from i := 1 until i > page_count loop
				Result.append (menu_item (page_titles[i], page_urls[i], page_descriptions[i]))
				i := i + 1
			end
			Result.append ("    </nav>%N")

			-- Footer with meta
			Result.append ("    <div class=%"px-4 py-3 border-t border-white/10 text-xs opacity-40%">%N")
			Result.append ("      <p>Built with Eiffel + AI + DBC</p>%N")
			Result.append ("    </div>%N")

			Result.append ("  </div>%N")
			Result.append ("</div>%N")
		ensure
			not_empty: not Result.is_empty
			has_alpine: Result.has_substring ("x-data")
			has_button: Result.has_substring ("aria-label")
		end

feature {NONE} -- Implementation

	menu_item (a_title, a_url, a_description: STRING): STRING
			-- Generate a single menu item
		require
			title_not_empty: not a_title.is_empty
			url_not_empty: not a_url.is_empty
		do
			create Result.make (300)
			Result.append ("      <a href=%"" + a_url + "%" ")
			Result.append ("class=%"block px-4 py-2 hover:bg-white/10 transition-colors group%">%N")
			Result.append ("        <div class=%"font-medium group-hover:text-blue-400 transition-colors%">" + a_title + "</div>%N")
			Result.append ("        <div class=%"text-xs opacity-50%">" + a_description + "</div>%N")
			Result.append ("      </a>%N")
		ensure
			not_empty: not Result.is_empty
			has_url: Result.has_substring (a_url)
		end

end
