note
	description: "[
		Base class for SSC sub-pages with common navigation and structure.

		Sub-pages share a common header/nav and back-to-home link.
		Each page provides its own content sections.
	]"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SSC_SUB_PAGE

inherit
	SSC_SHARED

	SSC_GLOSSARY

feature -- Access

	page_title: STRING
			-- Page title (appears in header and browser tab)
		deferred
		ensure
			not_empty: not Result.is_empty
		end

	page_subtitle: STRING
			-- Subtitle below main title
		deferred
		ensure
			not_empty: not Result.is_empty
		end

	page_url: STRING
			-- URL path for this page (e.g., "/get-started")
		deferred
		ensure
			not_empty: not Result.is_empty
			starts_with_slash: Result.starts_with ("/")
		end

feature -- Generation

	to_html: STRING
			-- Generate complete HTML page
		do
			create Result.make (50000)
			Result.append (html_doctype)
			Result.append (html_head)
			Result.append (html_body)
		ensure
			not_empty: not Result.is_empty
			is_html: Result.has_substring ("<!DOCTYPE html>")
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
			Result.append ("  " + base_tag + "%N")
			Result.append ("  <title>" + page_title + " | Simple Showcase</title>%N")
			Result.append ("  <meta name=%"description%" content=%"" + page_subtitle + "%">%N")
			-- PWA support
			Result.append ("  <link rel=%"manifest%" href=%"" + base_url + "/manifest.json%">%N")
			Result.append ("  <meta name=%"theme-color%" content=%"" + color_primary_dark + "%">%N")
			Result.append ("  <link rel=%"apple-touch-icon%" href=%"" + base_url + "/icon-192.png%">%N")
			Result.append ("  <script src=%"" + tailwind_cdn + "%"></script>%N")
			Result.append ("  <script defer src=%"" + alpine_cdn + "%"></script>%N")
			Result.append (page_styles)
			Result.append ("</head>%N")
		ensure
			not_empty: not Result.is_empty
			has_title: Result.has_substring (page_title)
		end

	html_body: STRING
			-- Generate <body> with nav, content, and footer
		do
			create Result.make (40000)
			Result.append ("<body class=%"bg-[" + color_primary_dark + "] text-[" + color_primary_light + "] antialiased min-h-screen%">%N")
			Result.append (page_nav)
			Result.append ("<main class=%"max-w-4xl mx-auto px-4 sm:px-6 py-8 sm:py-16%">%N")
			Result.append (page_header)
			Result.append (page_content)
			Result.append (page_footer_nav)
			Result.append ("</main>%N")
			-- Service worker registration for PWA
			Result.append ("<script>%N")
			Result.append ("  if ('serviceWorker' in navigator) {%N")
			Result.append ("    navigator.serviceWorker.register('" + base_url + "/sw.js')%N")
			Result.append ("      .then(reg => console.log('SW registered'))%N")
			Result.append ("      .catch(err => console.log('SW failed:', err));%N")
			Result.append ("  }%N")
			Result.append ("</script>%N")
			Result.append ("</body>%N</html>")
		ensure
			not_empty: not Result.is_empty
		end

	page_nav: STRING
			-- Hamburger navigation menu (always visible on sub-pages)
		local
			l_menu: SSC_HAMBURGER_MENU
		do
			create l_menu.make
			Result := l_menu.to_html
		ensure
			not_empty: not Result.is_empty
		end

	page_header: STRING
			-- Page header with title and subtitle
		do
			create Result.make (500)
			Result.append ("<header class=%"mb-8 sm:mb-16 pt-4 sm:pt-8%">%N")
			Result.append ("  <p class=%"text-xs uppercase tracking-widest opacity-60 mb-4%">" + page_label + "</p>%N")
			Result.append ("  <h1 class=%"text-3xl sm:text-4xl md:text-5xl font-light mb-4 sm:mb-6%">" + page_title + "</h1>%N")
			Result.append ("  <p class=%"text-lg sm:text-xl opacity-80 max-w-2xl%">" + page_subtitle + "</p>%N")
			Result.append ("</header>%N")
		ensure
			not_empty: not Result.is_empty
			has_title: Result.has_substring (page_title)
		end

	page_label: STRING
			-- Label above page title (derived from URL)
		do
			Result := page_url.substring (2, page_url.count).as_upper
			Result.replace_substring_all ("-", " ")
		ensure
			not_empty: not Result.is_empty
		end

	page_content: STRING
			-- Main page content - implement in descendants
		deferred
		ensure
			not_empty: not Result.is_empty
		end

	page_footer_nav: STRING
			-- Footer navigation links
		local
			l_pages: like related_pages
		do
			create Result.make (600)
			l_pages := related_pages
			Result.append ("<footer class=%"mt-16 pt-8 border-t border-white/10%">%N")
			Result.append ("  <div class=%"flex flex-wrap gap-4 mb-8%">%N")
			Result.append ("    <a href=%".%" class=%"text-sm opacity-60 hover:opacity-100 transition-opacity%">Back to home</a>%N")
			from l_pages.start until l_pages.after loop
				Result.append ("    <a href=%"" + l_pages.key_for_iteration + "%" class=%"text-sm opacity-60 hover:opacity-100 transition-opacity%">" + l_pages.item_for_iteration + "</a>%N")
				l_pages.forth
			end
			Result.append ("  </div>%N")
			Result.append (meta_statement)
			Result.append ("</footer>%N")
		ensure
			not_empty: not Result.is_empty
			has_home_link: Result.has_substring ("Back to home")
		end

	meta_statement: STRING
			-- The "this site is the proof" statement
		do
			create Result.make (500)
			Result.append ("<div class=%"text-xs opacity-40 pt-4 border-t border-white/5%">%N")
			Result.append ("  <p class=%"mb-2%">This site is built with the approach it describes.</p>%N")
			Result.append ("  <p>No frameworks. No bundlers. No node_modules. Just Eiffel + AI + Design by Contract.</p>%N")
			Result.append ("  <p class=%"mt-2%"><a href=%"https://github.com/ljr1981/simple_showcase%" target=%"_blank%" class=%"text-blue-400 hover:underline%">View the source on GitHub ↗</a></p>%N")
			Result.append ("</div>%N")
		end

	related_pages: HASH_TABLE [STRING, STRING]
			-- Related pages to show in footer (title -> url)
			-- Override in descendants to customize
		do
			create Result.make (3)
		end

	page_styles: STRING
			-- CSS styles for sub-pages
		do
			create Result.make (1000)
			Result.append ("<style>%N")
			Result.append ("  .section-divider { border-top: 1px solid rgba(255,255,255,0.1); margin: 3rem 0; }%N")
			Result.append ("  .content-section { margin-bottom: 3rem; }%N")
			Result.append ("  .code-block { background: " + color_code_bg + "; padding: 1.5rem; border-radius: 0.5rem; overflow-x: auto; }%N")
			Result.append ("  .code-block code { color: " + color_code_text + "; font-family: monospace; font-size: 0.875rem; line-height: 1.6; }%N")
			Result.append ("  .stat-box { background: rgba(255,255,255,0.05); padding: 1.5rem; border-radius: 0.5rem; text-align: center; }%N")
			Result.append ("  .stat-number { font-size: 2.5rem; font-weight: bold; font-variant-numeric: tabular-nums; }%N")
			Result.append ("  .stat-label { font-size: 0.875rem; opacity: 0.7; }%N")
			Result.append ("  .card { background: rgba(255,255,255,0.05); padding: 1.5rem; border-radius: 0.5rem; transition: background 0.2s; }%N")
			Result.append ("  .card:hover { background: rgba(255,255,255,0.1); }%N")
			Result.append (tooltip_css)
			Result.append ("</style>%N")
		ensure
			not_empty: not Result.is_empty
		end

feature {NONE} -- Content Helpers

	section_heading (a_title: STRING): STRING
			-- Generate a section heading
		require
			title_not_empty: not a_title.is_empty
		do
			Result := "<h2 class=%"text-xl sm:text-2xl font-medium mb-4 sm:mb-6%">" + a_title + "</h2>%N"
		ensure
			not_empty: not Result.is_empty
			has_title: Result.has_substring (a_title)
		end

	paragraph (a_text: STRING): STRING
			-- Generate a paragraph
		require
			text_not_empty: not a_text.is_empty
		do
			Result := "<p class=%"mb-4 opacity-90 leading-relaxed%">" + a_text + "</p>%N"
		ensure
			not_empty: not Result.is_empty
		end

	bullet_list (a_items: ARRAY [STRING]): STRING
			-- Generate a bullet list
		require
			has_items: a_items.count > 0
		do
			create Result.make (500)
			Result.append ("<ul class=%"list-disc list-inside space-y-2 mb-6 opacity-90%">%N")
			across 1 |..| a_items.count as idx loop
				Result.append ("  <li>" + a_items[idx.item] + "</li>%N")
			end
			Result.append ("</ul>%N")
		ensure
			not_empty: not Result.is_empty
		end

	code_block (a_code: STRING): STRING
			-- Generate a code block
		require
			code_not_empty: not a_code.is_empty
		do
			create Result.make (a_code.count + 100)
			Result.append ("<div class=%"code-block mb-6%"><code><pre>")
			Result.append (a_code)
			Result.append ("</pre></code></div>%N")
		ensure
			not_empty: not Result.is_empty
		end

	stat_box (a_number, a_label: STRING): STRING
			-- Generate a stat box
		require
			number_not_empty: not a_number.is_empty
			label_not_empty: not a_label.is_empty
		do
			create Result.make (200)
			Result.append ("<div class=%"stat-box%">%N")
			Result.append ("  <div class=%"stat-number%">" + a_number + "</div>%N")
			Result.append ("  <div class=%"stat-label%">" + a_label + "</div>%N")
			Result.append ("</div>%N")
		ensure
			not_empty: not Result.is_empty
			has_number: Result.has_substring (a_number)
		end

	divider: STRING
			-- Section divider
		do
			Result := "<div class=%"section-divider%"></div>%N"
		end

	cta_button (a_text, a_url: STRING): STRING
			-- Call-to-action button
		require
			text_not_empty: not a_text.is_empty
			url_not_empty: not a_url.is_empty
		do
			Result := "<a href=%"" + a_url + "%" class=%"inline-block px-6 py-3 bg-white/10 hover:bg-white/20 rounded-full text-sm transition-colors%">" + a_text + "</a>%N"
		ensure
			not_empty: not Result.is_empty
			has_url: Result.has_substring (a_url)
		end

	external_link (a_text, a_url: STRING): STRING
			-- External link with arrow
		require
			text_not_empty: not a_text.is_empty
			url_not_empty: not a_url.is_empty
		do
			Result := "<a href=%"" + a_url + "%" target=%"_blank%" class=%"text-blue-400 hover:underline%">" + a_text + " ↗</a>"
		ensure
			not_empty: not Result.is_empty
		end

end
