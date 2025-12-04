note
	description: "Landing page with all 8 sections"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_LANDING_PAGE

inherit
	SSC_SHARED

	SSC_LOGGER

	SSC_GLOSSARY

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize landing page
		do
			log_enter ("SSC_LANDING_PAGE.make")
			log_info ("page", "Creating landing page sections...")

			log_debug ("page", "  Creating hero_section...")
			create hero_section.make
			log_debug ("page", "  Creating recognition_section...")
			create recognition_section.make
			log_debug ("page", "  Creating shift_section...")
			create shift_section.make
			log_debug ("page", "  Creating problem_section...")
			create problem_section.make
			log_debug ("page", "  Creating unlock_section...")
			create unlock_section.make
			log_debug ("page", "  Creating evidence_section...")
			create evidence_section.make
			log_debug ("page", "  Creating revelation_section...")
			create revelation_section.make
			log_debug ("page", "  Creating workflow_section...")
			create workflow_section.make
			log_debug ("page", "  Creating invitation_section...")
			create invitation_section.make
			log_debug ("page", "  Creating nav_overlay...")
			create nav_overlay.make
			log_debug ("page", "  Creating hamburger_menu (hidden until scroll)...")
			create hamburger_menu.make_hidden_until_scroll

			log_info ("page", "All 9 sections + nav overlay + hamburger menu created")
			log_exit ("SSC_LANDING_PAGE.make")
		ensure
			hero_created: hero_section /= Void
			recognition_created: recognition_section /= Void
			shift_created: shift_section /= Void
			problem_created: problem_section /= Void
			unlock_created: unlock_section /= Void
			evidence_created: evidence_section /= Void
			revelation_created: revelation_section /= Void
			workflow_created: workflow_section /= Void
			invitation_created: invitation_section /= Void
			nav_created: nav_overlay /= Void
			hamburger_created: hamburger_menu /= Void
		end

feature -- Access

	title: STRING = "Simple Showcase"

	description: STRING = "12 libraries. 900+ tests. 10 days. One person. AI-assisted, contract-verified development."

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
	nav_overlay: SSC_NAV_OVERLAY
	hamburger_menu: SSC_HAMBURGER_MENU

feature -- Generation

	to_html: STRING
			-- Generate complete HTML page
		do
			log_enter ("SSC_LANDING_PAGE.to_html")
			log_info ("page", "Generating full HTML page...")
			Result := html_wrapper (body_content)
			log_info ("page", "Full page generated: " + Result.count.out + " bytes")
			log_exit ("SSC_LANDING_PAGE.to_html")
		ensure
			not_empty: not Result.is_empty
			is_html: Result.has_substring ("<!DOCTYPE html>")
			has_all_sections: Result.has_substring ("hero") and Result.has_substring ("invitation")
		end

	body_content: STRING
			-- Generate all sections
		local
			l_main: ALPINE_DIV
		do
			log_enter ("SSC_LANDING_PAGE.body_content")
			create Result.make (50000)

			-- Scroll snap container with scroll tracking
			log_debug ("page", "Creating scroll snap container...")
			l_main := alpine.div
			l_main.class_ ("snap-container")
				.x_data ("scrollFade()")
				.x_ref ("scroller")
				.attr_raw ("@scroll", "updateOpacities()")
				.do_nothing

			-- Add all sections
			log_info ("page", "Adding 9 sections to page...")

			log_debug ("page", "  Adding hero_section...")
			l_main.raw_html (hero_section.to_html).do_nothing

			log_debug ("page", "  Adding recognition_section...")
			l_main.raw_html (recognition_section.to_html).do_nothing

			log_debug ("page", "  Adding shift_section...")
			l_main.raw_html (shift_section.to_html).do_nothing

			log_debug ("page", "  Adding problem_section...")
			l_main.raw_html (problem_section.to_html).do_nothing

			log_debug ("page", "  Adding unlock_section...")
			l_main.raw_html (unlock_section.to_html).do_nothing

			log_debug ("page", "  Adding evidence_section...")
			l_main.raw_html (evidence_section.to_html).do_nothing

			log_debug ("page", "  Adding revelation_section...")
			l_main.raw_html (revelation_section.to_html).do_nothing

			log_debug ("page", "  Adding workflow_section...")
			l_main.raw_html (workflow_section.to_html).do_nothing

			log_debug ("page", "  Adding invitation_section...")
			l_main.raw_html (invitation_section.to_html).do_nothing

			log_info ("page", "All sections added")
			Result.append (l_main.to_html)

			-- Add nav overlay (outside scroll container, fixed position)
			log_debug ("page", "Adding nav overlay...")
			Result.append (nav_overlay.to_html)

			-- Add hamburger menu (hidden until scroll on landing)
			log_debug ("page", "Adding hamburger menu...")
			Result.append (hamburger_menu.to_html)

			log_html_size ("body_content", Result)
			log_exit ("SSC_LANDING_PAGE.body_content")
		ensure
			not_empty: not Result.is_empty
			has_scroll_container: Result.has_substring ("snap-container")
			has_nav_overlay: Result.has_substring ("navOverlay")
		end

feature {NONE} -- HTML Generation

	html_wrapper (a_body: STRING): STRING
			-- Wrap body content in full HTML document
		require
			body_not_empty: not a_body.is_empty
		do
			log_debug ("html", "Building HTML wrapper...")
			create Result.make (a_body.count + 2000)
			Result.append ("<!DOCTYPE html>%N")
			Result.append ("<html lang=%"en%">%N")
			Result.append (html_head)
			Result.append ("<body class=%"bg-[" + color_primary_dark + "] text-[" + color_primary_light + "] antialiased overflow-x-hidden%">%N")
			Result.append (a_body)
			Result.append (html_scripts)
			Result.append ("</body>%N</html>")
			log_debug ("html", "HTML wrapper complete")
		ensure
			not_empty: not Result.is_empty
			has_doctype: Result.has_substring ("<!DOCTYPE html>")
			has_body: Result.has_substring ("<body") and Result.has_substring ("</body>")
			contains_input: Result.has_substring (a_body)
		end

	html_head: STRING
			-- HTML head section
		do
			log_debug ("html", "Building <head>...")
			create Result.make (1000)
			Result.append ("<head>%N")
			Result.append ("  <meta charset=%"UTF-8%">%N")
			Result.append ("  <meta name=%"viewport%" content=%"width=device-width, initial-scale=1.0%">%N")
			Result.append ("  " + base_tag + "%N")
			Result.append ("  <title>" + title + "</title>%N")
			Result.append ("  <meta name=%"description%" content=%"" + description + "%">%N")
			Result.append ("  <script src=%"" + tailwind_cdn + "%"></script>%N")
			Result.append ("  <script defer src=%"" + alpine_intersect_cdn + "%"></script>%N")
			Result.append ("  <script defer src=%"" + alpine_cdn + "%"></script>%N")
			Result.append (custom_styles)
			Result.append ("</head>%N")
		ensure
			not_empty: not Result.is_empty
			has_head_tags: Result.has_substring ("<head>") and Result.has_substring ("</head>")
			has_title: Result.has_substring (title)
			has_tailwind: Result.has_substring ("tailwindcss")
			has_alpine: Result.has_substring ("alpinejs")
		end

	html_scripts: STRING
			-- JavaScript for scroll-based fade transitions and nav overlay
		do
			create Result.make (4000)
			Result.append ("<script>%N")
			Result.append ("  document.addEventListener('alpine:init', () => {%N")
			-- Nav overlay component
			Result.append (nav_overlay.nav_script)
			-- Scroll fade component
			Result.append ("    Alpine.data('scrollFade', () => ({%N")
			Result.append ("      init() {%N")
			Result.append ("        // Initial fade-in for hero%N")
			Result.append ("        this.$nextTick(() => this.updateOpacities());%N")
			Result.append ("      },%N")
			Result.append ("      updateOpacities() {%N")
			Result.append ("        const container = this.$refs.scroller;%N")
			Result.append ("        const vh = container.clientHeight;%N")
			Result.append ("        const scrollTop = container.scrollTop;%N")
			Result.append ("        container.querySelectorAll('.snap-section').forEach((section, index) => {%N")
			Result.append ("          const sectionTop = section.offsetTop;%N")
			Result.append ("          const sectionHeight = section.clientHeight;%N")
			Result.append ("          const content = section.querySelector('.section-content');%N")
			Result.append ("          if (!content) return;%N")
			Result.append ("          // Calculate how centered the section is%N")
			Result.append ("          const sectionCenter = sectionTop + sectionHeight / 2;%N")
			Result.append ("          const viewCenter = scrollTop + vh / 2;%N")
			Result.append ("          const distance = Math.abs(sectionCenter - viewCenter);%N")
			Result.append ("          const maxDistance = vh * 0.6;%N")
			Result.append ("          let opacity = 1 - (distance / maxDistance);%N")
			Result.append ("          opacity = Math.max(0, Math.min(1, opacity));%N")
			Result.append ("          // Apply easing for smoother feel%N")
			Result.append ("          opacity = opacity * opacity * (3 - 2 * opacity);%N")
			Result.append ("          content.style.opacity = opacity;%N")
			Result.append ("          content.style.transform = 'translateY(' + ((1 - opacity) * 20) + 'px)';%N")
			Result.append ("        });%N")
			Result.append ("      }%N")
			Result.append ("    }));%N")
			Result.append ("  });%N")
			Result.append ("</script>%N")
		ensure
			not_empty: not Result.is_empty
			has_script_tags: Result.has_substring ("<script>") and Result.has_substring ("</script>")
			has_alpine_init: Result.has_substring ("alpine:init")
			has_scroll_fade: Result.has_substring ("scrollFade")
		end

	custom_styles: STRING
			-- Custom CSS for scroll snap, animations, and tooltips
		do
			create Result.make (3000)
			Result.append ("<style>%N")
			-- Scroll container
			Result.append ("  .snap-container { height: 100vh; overflow-y: scroll; scroll-behavior: smooth; }%N")
			Result.append ("  .snap-section { }%N")
			Result.append ("  .section-content { transition: opacity 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94), transform 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94); }%N")
			-- Noise overlay
			Result.append ("  .noise-overlay { opacity: 0.03; background: repeating-linear-gradient(45deg, rgba(255,255,255,0.02) 0px, rgba(255,255,255,0.02) 1px, transparent 1px, transparent 3px); }%N")
			-- Stats
			Result.append ("  .stat-number { font-variant-numeric: tabular-nums; }%N")
			-- Hero stagger animation
			Result.append ("  @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }%N")
			Result.append ("  .hero-stagger { opacity: 0; animation: fadeInUp 0.7s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards; }%N")
			Result.append ("  .hero-stagger-1 { animation-delay: 0.2s; }%N")
			Result.append ("  .hero-stagger-2 { animation-delay: 0.5s; }%N")
			Result.append ("  .hero-stagger-3 { animation-delay: 0.9s; }%N")
			Result.append ("  .hero-stagger-4 { animation-delay: 1.2s; }%N")
			Result.append ("  .hero-stagger-5 { animation-delay: 1.6s; }%N")
			-- Card entrance animation (for x-intersect)
			Result.append ("  @keyframes cardEntrance { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }%N")
			Result.append ("  .card-animate { opacity: 0; }%N")
			Result.append ("  .card-animate.entered { animation: cardEntrance 0.5s ease-out forwards; }%N")
			-- Staggered card delays
			Result.append ("  .card-delay-1 { animation-delay: 0.1s; }%N")
			Result.append ("  .card-delay-2 { animation-delay: 0.2s; }%N")
			Result.append ("  .card-delay-3 { animation-delay: 0.3s; }%N")
			Result.append ("  .card-delay-4 { animation-delay: 0.4s; }%N")
			-- Hover enhancement
			Result.append ("  .hover-lift { transition: transform 0.2s ease, box-shadow 0.2s ease; }%N")
			Result.append ("  .hover-lift:hover { transform: translateY(-4px); box-shadow: 0 10px 40px rgba(0,0,0,0.3); }%N")
			Result.append (tooltip_css)
			Result.append ("</style>%N")
		ensure
			not_empty: not Result.is_empty
			has_style_tags: Result.has_substring ("<style>") and Result.has_substring ("</style>")
			has_snap_container: Result.has_substring (".snap-container")
			has_tooltip_styles: Result.has_substring (".tooltip-term")
			has_hero_stagger: Result.has_substring (".hero-stagger")
		end

feature {NONE} -- Factory

	alpine: ALPINE_FACTORY
			-- Factory for Alpine.js elements
		once
			create Result
		ensure
			result_exists: Result /= Void
		end

end
