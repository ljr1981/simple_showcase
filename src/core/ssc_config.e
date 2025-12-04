note
	description: "[
		Configuration loader for Simple Showcase.

		Reads settings from a JSON config file, supporting different
		configurations for development vs production environments.

		Usage:
			config: SSC_CONFIG
			create config.make ("config.json")
			server.make (config.port)
	]"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_CONFIG

inherit
	SSC_LOGGER

create
	make,
	make_default

feature {NONE} -- Initialization

	make (a_config_path: STRING)
			-- Load configuration from JSON file at `a_config_path`
		require
			path_not_empty: not a_config_path.is_empty
		local
			l_json: SIMPLE_JSON
			l_value: detachable SIMPLE_JSON_VALUE
		do
			config_path := a_config_path

			create l_json
			l_value := l_json.parse_file (a_config_path)

			if attached l_value as l_val and then l_val.is_object then
				load_from_json (l_val.as_object)
				is_loaded := True
				log_info ("config", "Loaded configuration from " + a_config_path)
			elseif l_json.has_errors then
				log_info ("config", "JSON parse error in " + a_config_path + ", using defaults")
				set_defaults
			else
				log_info ("config", "Config file not found or invalid: " + a_config_path + ", using defaults")
				set_defaults
			end
		ensure
			path_set: config_path.same_string (a_config_path)
		end

	make_default
			-- Create with default development settings
		do
			config_path := "config.json"
			set_defaults
			log_info ("config", "Using default development configuration")
		end

feature -- Access

	config_path: STRING
			-- Path to the configuration file

	is_loaded: BOOLEAN
			-- Was configuration successfully loaded from file?

	mode: STRING
			-- Running mode: "development" or "production"

	port: INTEGER
			-- HTTP server port

	base_url: STRING
			-- Base URL for the site (used in generated links)

	contact_email: STRING
			-- Email address for contact form submissions

	smtp_password: STRING
			-- Gmail app password for sending emails

	smtp_endpoints: ARRAYED_LIST [TUPLE [host: STRING; port: INTEGER; protocol: STRING; ssl_reqd: BOOLEAN]]
			-- List of SMTP endpoints to try in order

	db_path: STRING
			-- Path to SQLite database file

	log_level: STRING
			-- Logging level: "debug", "info", "warn", "error"

	verbose_logging: BOOLEAN
			-- Enable verbose console output?

feature -- Status

	is_development: BOOLEAN
			-- Are we running in development mode?
		do
			Result := mode.same_string ("development")
		end

	is_production: BOOLEAN
			-- Are we running in production mode?
		do
			Result := mode.same_string ("production")
		end

feature {NONE} -- Implementation

	set_defaults
			-- Set default development values
		do
			mode := "development"
			port := 8080
			base_url := "http://localhost:8080"
			contact_email := ""
			smtp_password := ""
			set_default_smtp_endpoints
			db_path := "showcase_dev.db"
			log_level := "debug"
			verbose_logging := True
			is_loaded := False
		ensure
			development_mode: is_development
			default_port: port = 8080
			has_smtp_endpoints: not smtp_endpoints.is_empty
		end

	set_default_smtp_endpoints
			-- Set default SMTP endpoints (Gmail)
		do
			create smtp_endpoints.make (2)
			-- Port 465 (SMTPS) - direct SSL, usually works
			smtp_endpoints.extend (["smtp.gmail.com", 465, "smtps", False])
			-- Port 587 (STARTTLS) - fallback
			smtp_endpoints.extend (["smtp.gmail.com", 587, "smtp", True])
		ensure
			not_empty: not smtp_endpoints.is_empty
		end

	load_from_json (a_obj: SIMPLE_JSON_OBJECT)
			-- Load settings from parsed JSON object
		do
			-- Mode
			if attached a_obj.item ("mode") as l_mode and then l_mode.is_string then
				mode := l_mode.as_string_32.to_string_8
			else
				mode := "development"
			end

			-- Port
			if attached a_obj.item ("port") as l_port and then l_port.is_number then
				port := l_port.as_integer.to_integer_32
			else
				port := 8080
			end

			-- Base URL
			if attached a_obj.item ("base_url") as l_url and then l_url.is_string then
				base_url := l_url.as_string_32.to_string_8
			else
				base_url := "http://localhost:" + port.out
			end

			-- Contact email
			if attached a_obj.item ("contact_email") as l_email and then l_email.is_string then
				contact_email := l_email.as_string_32.to_string_8
			else
				contact_email := ""
			end

			-- SMTP password (prefer environment variable for security)
			if attached (create {EXECUTION_ENVIRONMENT}).item ("SSC_SMTP_PASSWORD") as l_env_pwd then
				smtp_password := l_env_pwd.to_string_8
				log_info ("config", "SMTP password loaded from SSC_SMTP_PASSWORD environment variable")
			elseif attached a_obj.item ("smtp_password") as l_smtp and then l_smtp.is_string then
				smtp_password := l_smtp.as_string_32.to_string_8
				log_info ("config", "SMTP password loaded from config file (consider using SSC_SMTP_PASSWORD env var)")
			else
				smtp_password := ""
			end

			-- Database path
			if attached a_obj.item ("db_path") as l_db and then l_db.is_string then
				db_path := l_db.as_string_32.to_string_8
			else
				db_path := "showcase.db"
			end

			-- Log level
			if attached a_obj.item ("log_level") as l_log and then l_log.is_string then
				log_level := l_log.as_string_32.to_string_8
			else
				log_level := "info"
			end

			-- Verbose logging
			if attached a_obj.item ("verbose_logging") as l_verbose and then l_verbose.is_boolean then
				verbose_logging := l_verbose.as_boolean
			else
				verbose_logging := is_development
			end

			-- SMTP endpoints
			if attached a_obj.item ("smtp_endpoints") as l_endpoints and then l_endpoints.is_array then
				load_smtp_endpoints (l_endpoints.as_array)
			else
				set_default_smtp_endpoints
			end

			log_debug ("config", "mode=" + mode + ", port=" + port.out + ", base_url=" + base_url)
			log_debug ("config", "smtp_endpoints: " + smtp_endpoints.count.out + " configured")
		end

	load_smtp_endpoints (a_array: SIMPLE_JSON_ARRAY)
			-- Load SMTP endpoints from JSON array
		local
			i: INTEGER
			l_item: SIMPLE_JSON_VALUE
			l_obj: detachable SIMPLE_JSON_OBJECT
			l_host, l_protocol: STRING
			l_port: INTEGER
			l_ssl_reqd: BOOLEAN
		do
			create smtp_endpoints.make (a_array.count.to_integer_32.max (2))

			from
				i := 1
			until
				i > a_array.count.to_integer_32
			loop
				l_item := a_array.item (i)
				if l_item.is_object then
					l_obj := l_item.as_object
				else
					l_obj := Void
				end

				if attached l_obj as l_o then
					-- Host (required)
					if attached l_o.item ("host") as l_h and then l_h.is_string then
						l_host := l_h.as_string_32.to_string_8
					else
						l_host := ""
					end

					-- Port (required)
					if attached l_o.item ("port") as l_p and then l_p.is_number then
						l_port := l_p.as_integer.to_integer_32
					else
						l_port := 0
					end

					-- Protocol (default based on port)
					if attached l_o.item ("protocol") as l_pr and then l_pr.is_string then
						l_protocol := l_pr.as_string_32.to_string_8
					elseif l_port = 465 then
						l_protocol := "smtps"
					else
						l_protocol := "smtp"
					end

					-- SSL required (default based on port)
					if attached l_o.item ("ssl_reqd") as l_ssl and then l_ssl.is_boolean then
						l_ssl_reqd := l_ssl.as_boolean
					else
						l_ssl_reqd := (l_port = 587)
					end

					-- Only add if we have valid host and port
					if not l_host.is_empty and l_port > 0 then
						smtp_endpoints.extend ([l_host, l_port, l_protocol, l_ssl_reqd])
						log_debug ("config", "  SMTP endpoint: " + l_protocol + "://" + l_host + ":" + l_port.out)
					end
				end
				i := i + 1
			end

			-- Fall back to defaults if no valid endpoints were parsed
			if smtp_endpoints.is_empty then
				log_info ("config", "No valid smtp_endpoints in config, using defaults")
				set_default_smtp_endpoints
			end
		ensure
			not_empty: not smtp_endpoints.is_empty
		end

invariant
	mode_not_empty: not mode.is_empty
	port_positive: port > 0
	base_url_not_empty: not base_url.is_empty
	db_path_not_empty: not db_path.is_empty
	log_level_not_empty: not log_level.is_empty
	smtp_endpoints_exist: smtp_endpoints /= Void and then not smtp_endpoints.is_empty

end
