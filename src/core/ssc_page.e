note
	description: "Base class for SSC pages with common HTML structure"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SSC_PAGE

inherit
	SSC_SHARED

feature -- Access

	title: STRING
			-- Page title
		deferred
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	description: STRING
			-- Meta description for SEO
		deferred
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

feature -- Generation

	to_html: STRING
			-- Generate complete HTML page
		do
			create Result.make (50000)
			Result.append (html_doctype)
			Result.append (html_head)
			Result.append (html_body_open)
			Result.append (body_content)
			Result.append (html_scripts)
			Result.append (html_body_close)
		ensure
			not_empty: not Result.is_empty
			starts_with_doctype: Result.starts_with ("<!DOCTYPE html>")
		end

	body_content: STRING
			-- Main body content - implement in descendants
		deferred
		ensure
			not_empty: not Result.is_empty
		end

feature {NONE} -- HTML Structure

	html_doctype: STRING = "<!DOCTYPE html>%N"

	html_head: STRING
			-- Generate <head> section
		do
			create Result.make (2000)
			Result.append ("<html lang=%"en%">%N")
			Result.append ("<head>%N")
			Result.append ("  <meta charset=%"UTF-8%">%N")
			Result.append ("  <meta name=%"viewport%" content=%"width=device-width, initial-scale=1.0%">%N")
			Result.append ("  <meta name=%"description%" content=%"")
			Result.append (description)
			Result.append ("%">%N")
			Result.append ("  <title>")
			Result.append (title)
			Result.append (" | simple_showcase</title>%N")
			Result.append ("  <script src=%"")
			Result.append (tailwind_cdn)
			Result.append ("%"></script>%N")
			Result.append (custom_styles)
			Result.append ("</head>%N")
		end

	html_body_open: STRING
			-- Opening body tag with Alpine x-data for global state
		do
			create Result.make (500)
			Result.append ("<body x-data=%"{ darkMode: localStorage.getItem('darkMode') === 'true', currentSection: 0 }%" %N")
			Result.append ("      x-init=%"$watch('darkMode', val => { localStorage.setItem('darkMode', val); document.documentElement.classList.toggle('dark', val) })%" %N")
			Result.append ("      :class=%"darkMode ? 'dark' : ''%" %N")
			Result.append ("      class=%"bg-[")
			Result.append (color_primary_dark)
			Result.append ("] text-[")
			Result.append (color_primary_light)
			Result.append ("] antialiased%">%N")
		end

	html_body_close: STRING = "</body>%N</html>%N"

	html_scripts: STRING
			-- JavaScript includes at end of body
		do
			create Result.make (1000)
			Result.append ("%N<!-- Alpine.js plugins -->%N")
			Result.append ("<script defer src=%"")
			Result.append (alpine_intersect_cdn)
			Result.append ("%"></script>%N")
			Result.append ("<script defer src=%"")
			Result.append (alpine_collapse_cdn)
			Result.append ("%"></script>%N")
			Result.append ("<script defer src=%"")
			Result.append (alpine_cdn)
			Result.append ("%"></script>%N")
			Result.append ("%N<!-- Smooth scroll -->%N")
			Result.append ("<script src=%"")
			Result.append (lenis_cdn)
			Result.append ("%"></script>%N")
			Result.append (lenis_init_script)
			Result.append (custom_scripts)
		end

	lenis_init_script: STRING
			-- Initialize Lenis smooth scroll
		do
			create Result.make (500)
			Result.append ("<script>%N")
			Result.append ("  const lenis = new Lenis({%N")
			Result.append ("    duration: 1.2,%N")
			Result.append ("    easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),%N")
			Result.append ("    direction: 'vertical',%N")
			Result.append ("    smooth: true%N")
			Result.append ("  });%N")
			Result.append ("  function raf(time) {%N")
			Result.append ("    lenis.raf(time);%N")
			Result.append ("    requestAnimationFrame(raf);%N")
			Result.append ("  }%N")
			Result.append ("  requestAnimationFrame(raf);%N")
			Result.append ("</script>%N")
		end

	custom_styles: STRING
			-- Override in descendants for page-specific styles
		do
			create Result.make (2000)
			Result.append ("<style>%N")
			-- Noise texture animation
			Result.append ("  @keyframes noise { 0%%, 100%% { background-position: 0 0; } 10%% { background-position: -5%% -10%%; } 30%% { background-position: 3%% -15%%; } 50%% { background-position: 12%% 9%%; } 70%% { background-position: 9%% 4%%; } 90%% { background-position: -1%% 7%%; } }%N")
			Result.append ("  .noise-overlay { background-image: url(%"data:image/svg+xml,%%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%%3E%%3Cfilter id='noise'%%3E%%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%%3E%%3C/filter%%3E%%3Crect width='100%%25' height='100%%25' filter='url(%%23noise)'/%%3E%%3C/svg%%3E%"); opacity: 0.03; animation: noise 0.2s infinite; }%N")
			-- Scroll snap
			Result.append ("  .snap-container { scroll-snap-type: y mandatory; overflow-y: scroll; height: 100vh; }%N")
			Result.append ("  .snap-section { scroll-snap-align: start; min-height: 100vh; }%N")
			-- Text reveal animation
			Result.append ("  @keyframes textReveal { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }%N")
			Result.append ("  .text-reveal { animation: textReveal 0.7s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards; }%N")
			-- Number counting styles
			Result.append ("  .stat-number { font-variant-numeric: tabular-nums; }%N")
			Result.append ("</style>%N")
		end

	custom_scripts: STRING
			-- Override in descendants for page-specific scripts
		do
			Result := ""
		end

end
