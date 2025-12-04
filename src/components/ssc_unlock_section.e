note
	description: "The Unlock section - Contracts verify AI"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_UNLOCK_SECTION

inherit
	SSC_SECTION
		redefine
			background_color
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize unlock section
		do
			-- Nothing needed
		end

feature -- Access

	section_number: INTEGER = 4

	section_id: STRING = "unlock"

	background_color: STRING
			-- Deep teal for solution/calm
		do
			Result := color_accent_calm
		end

feature {NONE} -- Content

	section_content: STRING
			-- Unlock section with code example
		local
			l_container, l_label_wrap, l_content, l_code_block: ALPINE_DIV
			l_label: ALPINE_SPAN
			l_headline: ALPINE_H2
			l_subhead, l_explanation: ALPINE_P
		do
			create Result.make (5000)

			-- Main container
			l_container := alpine.div
			l_container.class_ (container_wide)

			-- Section label
			l_label_wrap := alpine.div
			l_label_wrap.class_ ("mb-8 opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-500 delay-200")
				.attr_raw ("x-transition:enter-start", "opacity-0")
				.attr_raw ("x-transition:enter-end", "opacity-100")

			l_label := alpine.span
			l_label.class_ (font_section_label)
				.text ("THE UNLOCK")
			l_label_wrap.raw_html (l_label.to_html)
			l_container.raw_html (l_label_wrap.to_html)

			-- Content
			l_content := alpine.div
			l_content.class_ ("grid lg:grid-cols-2 gap-12 items-center")

			-- Left: Text
			l_label_wrap := alpine.div
			l_label_wrap.class_ ("opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-400")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-x-[-20px]")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-x-0")

			l_headline := alpine.h2
			l_headline.class_ (font_section_headline + " mb-6")
				.text ("What if the code could verify itself?")
			l_label_wrap.raw_html (l_headline.to_html)

			l_subhead := alpine.p
			l_subhead.class_ (font_body + " opacity-90 mb-4")
				.text ("Design by Contract embeds verification into every feature. The compiler becomes your QA department.")
			l_label_wrap.raw_html (l_subhead.to_html)

			l_explanation := alpine.p
			l_explanation.class_ (font_body + " opacity-70")
				.text ("Preconditions guard inputs. Postconditions verify outputs. Invariants maintain state. Every contract violation is caught immediately—not in production.")
			l_label_wrap.raw_html (l_explanation.to_html)

			l_content.raw_html (l_label_wrap.to_html)

			-- Right: Code example
			l_code_block := alpine.div
			l_code_block.class_ ("opacity-0")
				.x_show ("visible")
				.attr_raw ("x-transition:enter", "transition-all duration-700 delay-600")
				.attr_raw ("x-transition:enter-start", "opacity-0 translate-x-[20px]")
				.attr_raw ("x-transition:enter-end", "opacity-100 translate-x-0")
				.raw_html (code_example)

			l_content.raw_html (l_code_block.to_html)

			l_container.raw_html (l_content.to_html)

			Result.append (l_container.to_html)
		end

	code_example: STRING
			-- Eiffel DBC code example
		do
			create Result.make (1000)
			Result.append ("<pre class=%"p-6 rounded-lg bg-[" + color_code_bg + "] overflow-x-auto%"><code class=%"" + font_code + " text-[" + color_code_text + "]%">")
			Result.append ("divide (a, b: REAL): REAL%N")
			Result.append ("  <span class=%"text-amber-400%">require</span>%N")
			Result.append ("    positive_divisor: b > 0%N")
			Result.append ("  <span class=%"text-blue-400%">do</span>%N")
			Result.append ("    Result := a / b%N")
			Result.append ("  <span class=%"text-emerald-400%">ensure</span>%N")
			Result.append ("    correct_result: Result * b = a%N")
			Result.append ("  <span class=%"text-blue-400%">end</span>")
			Result.append ("</code></pre>")
			Result.append ("<p class=%"text-sm opacity-60 mt-4 text-center%">The contract IS the specification. Violation = immediate feedback.</p>")
		end

end
