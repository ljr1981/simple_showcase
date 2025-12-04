note
	description: "Contact page - Form to reach out"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_CONTACT_PAGE

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

	page_title: STRING = "Contact"

	page_subtitle: STRING = "Questions? Ideas? Want to collaborate? Reach out."

	page_url: STRING = "/contact"

feature -- Content

	page_content: STRING
			-- Main page content
		do
			create Result.make (8000)

			-- Intro
			Result.append (paragraph ("Whether you're a CTO evaluating this approach, a developer wanting to try it, or just curious—we'd love to hear from you."))
			Result.append (divider)

			-- Contact Form
			Result.append (section_heading ("Send a Message"))
			Result.append (contact_form)
			Result.append (divider)

			-- Alternative Contact
			Result.append (section_heading ("Other Ways to Connect"))
			Result.append (bullet_list (<<
				"<strong>GitHub:</strong> " + external_link ("github.com/ljr1981", "https://github.com/ljr1981") + " — Open issues, contribute, or just explore the code",
				"<strong>Eiffel Community:</strong> " + external_link ("eiffel.org/community", "https://www.eiffel.org/community") + " — Join the broader Eiffel conversation"
			>>))
			Result.append (divider)

			-- What to Expect
			Result.append (section_heading ("What to Expect"))
			Result.append (paragraph ("We read every message. If your question is relevant to Eiffel + AI development, expect a thoughtful response. We're particularly interested in:"))
			Result.append (bullet_list (<<
				"Technical questions about the approach",
				"Feedback on the libraries",
				"Collaboration opportunities",
				"Real-world use cases and results"
			>>))
		ensure then
			has_form: Result.has_substring ("form")
		end

feature {NONE} -- Related Pages

	related_pages: HASH_TABLE [STRING, STRING]
			-- Related pages for footer
		do
			create Result.make (3)
			Result.put ("Get Started", "get-started")
			Result.put ("Portfolio", "portfolio")
		end

feature {NONE} -- Form Generation

	contact_form: STRING
			-- Generate the contact form HTML
		do
			create Result.make (2000)
			Result.append ("<form id=%"contact-form%" class=%"space-y-6%" x-data=%"contactForm()%">%N")

			-- Name field
			Result.append ("  <div>%N")
			Result.append ("    <label for=%"name%" class=%"block text-sm font-medium mb-2%">Name</label>%N")
			Result.append ("    <input type=%"text%" id=%"name%" name=%"name%" x-model=%"name%" required maxlength=%"100%"")
			Result.append (" class=%"w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-blue-400 transition-colors%">%N")
			Result.append ("  </div>%N")

			-- Email field
			Result.append ("  <div>%N")
			Result.append ("    <label for=%"email%" class=%"block text-sm font-medium mb-2%">Email</label>%N")
			Result.append ("    <input type=%"email%" id=%"email%" name=%"email%" x-model=%"email%" required maxlength=%"254%"")
			Result.append (" class=%"w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-blue-400 transition-colors%">%N")
			Result.append ("  </div>%N")

			-- Subject field
			Result.append ("  <div>%N")
			Result.append ("    <label for=%"subject%" class=%"block text-sm font-medium mb-2%">Subject</label>%N")
			Result.append ("    <select id=%"subject%" name=%"subject%" x-model=%"subject%"")
			Result.append (" class=%"w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-blue-400 transition-colors%">%N")
			Result.append ("      <option value=%"general%">General Question</option>%N")
			Result.append ("      <option value=%"technical%">Technical Question</option>%N")
			Result.append ("      <option value=%"collaboration%">Collaboration Opportunity</option>%N")
			Result.append ("      <option value=%"feedback%">Feedback</option>%N")
			Result.append ("    </select>%N")
			Result.append ("  </div>%N")

			-- Message field
			Result.append ("  <div>%N")
			Result.append ("    <label for=%"message%" class=%"block text-sm font-medium mb-2%">Message</label>%N")
			Result.append ("    <textarea id=%"message%" name=%"message%" x-model=%"message%" rows=%"6%" required maxlength=%"5000%"")
			Result.append (" class=%"w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-blue-400 transition-colors resize-none%"></textarea>%N")
			Result.append ("  </div>%N")

			-- Submit button
			Result.append ("  <div>%N")
			Result.append ("    <button type=%"submit%" @click.prevent=%"submitForm()%"")
			Result.append (" :disabled=%"submitting%"")
			Result.append (" class=%"px-6 py-3 bg-blue-500 hover:bg-blue-600 disabled:bg-blue-500/50 rounded-lg font-medium transition-colors%">%N")
			Result.append ("      <span x-show=%"!submitting%">Send Message</span>%N")
			Result.append ("      <span x-show=%"submitting%">Sending...</span>%N")
			Result.append ("    </button>%N")
			Result.append ("  </div>%N")

			-- Status messages
			Result.append ("  <div x-show=%"success%" x-cloak class=%"p-4 bg-emerald-500/20 border border-emerald-500/50 rounded-lg text-emerald-400%">%N")
			Result.append ("    Message sent successfully! We'll get back to you soon.%N")
			Result.append ("  </div>%N")
			Result.append ("  <div x-show=%"error%" x-cloak class=%"p-4 bg-red-500/20 border border-red-500/50 rounded-lg text-red-400%">%N")
			Result.append ("    <span x-text=%"errorMessage%"></span>%N")
			Result.append ("  </div>%N")

			Result.append ("</form>%N")

			-- Alpine.js component
			Result.append (contact_form_script)
		end

	contact_form_script: STRING
			-- Alpine.js script for form handling
		do
			create Result.make (1000)
			Result.append ("<script>%N")
			Result.append ("function contactForm() {%N")
			Result.append ("  return {%N")
			Result.append ("    name: '',%N")
			Result.append ("    email: '',%N")
			Result.append ("    subject: 'general',%N")
			Result.append ("    message: '',%N")
			Result.append ("    submitting: false,%N")
			Result.append ("    success: false,%N")
			Result.append ("    error: false,%N")
			Result.append ("    errorMessage: '',%N")
			Result.append ("    async submitForm() {%N")
			Result.append ("      this.submitting = true;%N")
			Result.append ("      this.success = false;%N")
			Result.append ("      this.error = false;%N")
			Result.append ("      try {%N")
			Result.append ("        const response = await fetch('/api/contact', {%N")
			Result.append ("          method: 'POST',%N")
			Result.append ("          headers: { 'Content-Type': 'application/json' },%N")
			Result.append ("          body: JSON.stringify({%N")
			Result.append ("            name: this.name,%N")
			Result.append ("            email: this.email,%N")
			Result.append ("            subject: this.subject,%N")
			Result.append ("            message: this.message%N")
			Result.append ("          })%N")
			Result.append ("        });%N")
			Result.append ("        if (response.ok) {%N")
			Result.append ("          this.success = true;%N")
			Result.append ("          this.name = '';%N")
			Result.append ("          this.email = '';%N")
			Result.append ("          this.subject = 'general';%N")
			Result.append ("          this.message = '';%N")
			Result.append ("        } else {%N")
			Result.append ("          const data = await response.json();%N")
			Result.append ("          this.error = true;%N")
			Result.append ("          this.errorMessage = data.error || 'Failed to send message. Please try again.';%N")
			Result.append ("        }%N")
			Result.append ("      } catch (e) {%N")
			Result.append ("        this.error = true;%N")
			Result.append ("        this.errorMessage = 'Network error. Please try again.';%N")
			Result.append ("      }%N")
			Result.append ("      this.submitting = false;%N")
			Result.append ("    }%N")
			Result.append ("  }%N")
			Result.append ("}%N")
			Result.append ("</script>%N")
		end

end
