note
	description: "Shared constants and utilities for Simple Showcase"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_SHARED

feature -- Color Palette

	color_primary_dark: STRING = "#0c0b0b"
			-- Deep charcoal - main background

	color_primary_light: STRING = "#fdfcfa"
			-- Off-white - primary text

	color_accent_calm: STRING = "#0d4f4f"
			-- Deep teal - unlock/solution sections

	color_accent_warning: STRING = "#4f2d0d"
			-- Deep amber - problem sections

	color_accent_energy: STRING = "#2d0d4f"
			-- Deep purple - shift/excitement sections

	color_accent_evidence: STRING = "#0d1a4f"
			-- Deep navy - evidence/proof sections

	color_code_bg: STRING = "#1a1a1a"
			-- Near-black - code blocks

	color_code_text: STRING = "#8fdf8f"
			-- Soft green - code syntax

feature -- Typography Classes

	font_hero_headline: STRING = "text-4xl sm:text-5xl md:text-[6vw] lg:text-[8vw] font-light tracking-[-0.02em] leading-tight"
			-- Responsive hero headline: 4xl on mobile, scales up to 8vw on desktop

	font_section_headline: STRING = "text-2xl sm:text-3xl md:text-[4vw] lg:text-[5vw] font-medium leading-tight"
			-- Responsive section headline: 2xl on mobile, scales up to 5vw on desktop

	font_body: STRING = "text-base sm:text-lg leading-relaxed"
			-- Responsive body text: base on mobile, lg on larger screens

	font_section_label: STRING = "text-xs uppercase tracking-widest opacity-60"

	font_code: STRING = "font-mono text-xs sm:text-sm leading-relaxed"
			-- Responsive code: smaller on mobile

	font_stats: STRING = "font-bold tabular-nums"

feature -- Animation Classes

	anim_text_reveal: STRING = "transition-all duration-700 ease-out"

	anim_card_entrance: STRING = "transition-all duration-500 ease-out"

	anim_hover: STRING = "transition-all duration-200 ease"

	anim_scroll_indicator: STRING = "animate-bounce"

feature -- Common Classes

	section_full_viewport: STRING = "min-h-screen w-full snap-start flex flex-col justify-center items-center px-4 sm:px-6 md:px-8"
			-- Responsive padding: tighter on mobile

	container_centered: STRING = "max-w-4xl mx-auto text-center px-4 sm:px-0"
			-- Centered container with mobile padding

	container_wide: STRING = "max-w-6xl mx-auto px-4 sm:px-0"
			-- Wide container with mobile padding

feature -- Base URL (for GitHub Pages)

	base_url: STRING
			-- Base URL path - empty for localhost, "/simple_showcase" for GitHub Pages
			-- Set via shared_base_url cell
		do
			Result := shared_base_url.item
		end

	shared_base_url: CELL [STRING]
			-- Shared base URL cell - set once for all pages
			-- Default is empty (for local development)
		once
			create Result.put ("")
		end

	set_base_url_for_github_pages
			-- Set base URL for GitHub Pages deployment
		do
			shared_base_url.put ("/simple_showcase")
		end

	base_tag: STRING
			-- HTML base tag for proper link resolution
		do
			if base_url.is_empty then
				Result := ""
			else
				Result := "<base href=%"" + base_url + "/%">"
			end
		end

feature -- CDN URLs

	tailwind_cdn: STRING = "https://cdn.tailwindcss.com"

	alpine_cdn: STRING = "https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"

	alpine_intersect_cdn: STRING = "https://cdn.jsdelivr.net/npm/@alpinejs/intersect@3.x.x/dist/cdn.min.js"

	alpine_collapse_cdn: STRING = "https://cdn.jsdelivr.net/npm/@alpinejs/collapse@3.x.x/dist/cdn.min.js"

	lenis_cdn: STRING = "https://cdn.jsdelivr.net/npm/@studio-freight/lenis@1.0.42/dist/lenis.min.js"

invariant
	-- Color palette is valid hex format
	valid_primary_dark: color_primary_dark.starts_with ("#") and color_primary_dark.count = 7
	valid_primary_light: color_primary_light.starts_with ("#") and color_primary_light.count = 7
	valid_accent_calm: color_accent_calm.starts_with ("#") and color_accent_calm.count = 7
	valid_accent_warning: color_accent_warning.starts_with ("#") and color_accent_warning.count = 7
	valid_accent_energy: color_accent_energy.starts_with ("#") and color_accent_energy.count = 7
	valid_accent_evidence: color_accent_evidence.starts_with ("#") and color_accent_evidence.count = 7
	valid_code_bg: color_code_bg.starts_with ("#") and color_code_bg.count = 7
	valid_code_text: color_code_text.starts_with ("#") and color_code_text.count = 7

	-- CDN URLs are valid https
	tailwind_https: tailwind_cdn.starts_with ("https://")
	alpine_https: alpine_cdn.starts_with ("https://")
	alpine_intersect_https: alpine_intersect_cdn.starts_with ("https://")

end
