note
	description: "[
		SQLite database for Simple Showcase.

		Manages:
		- Analytics (page views, request logging)
		- Contact form submissions
		- Admin sessions

		Database file: showcase.db (created automatically)
	]"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_DATABASE

inherit
	SSC_LOGGER

create
	make

feature {NONE} -- Initialization

	make (a_db_path: STRING)
			-- Create/open database at `a_db_path`
		require
			path_not_empty: not a_db_path.is_empty
		do
			db_path := a_db_path
			create db.make (a_db_path)
			log_info ("database", "Database opened: " + a_db_path)
			ensure_schema
		ensure
			db_open: db.is_open
		end

feature -- Access

	db: SIMPLE_SQL_DATABASE
			-- Database connection

	db_path: STRING
			-- Path to database file

feature -- Analytics

	log_request (a_path, a_method, a_ip, a_user_agent, a_referrer: STRING; a_response_code, a_response_time_ms: INTEGER)
			-- Log an HTTP request to analytics table
		require
			db_open: db.is_open
			path_not_empty: not a_path.is_empty
			method_not_empty: not a_method.is_empty
		do
			db.execute_with_args (
				"INSERT INTO analytics (path, method, ip_address, user_agent, referrer, response_code, response_time_ms) VALUES (?, ?, ?, ?, ?, ?, ?)",
				<<a_path, a_method, a_ip, a_user_agent, a_referrer, a_response_code, a_response_time_ms>>
			)
			if db.has_error and then attached db.last_error_message as l_err then
				log_info ("database", "Failed to log analytics: " + l_err.to_string_8)
			end
		end

	get_page_view_counts: ARRAYED_LIST [TUPLE [path: STRING; view_count: INTEGER]]
			-- Get page view counts grouped by path, ordered by count desc
		local
			l_result: SIMPLE_SQL_RESULT
			l_row: SIMPLE_SQL_ROW
		do
			create Result.make (20)
			l_result := db.query ("SELECT path, COUNT(*) as cnt FROM analytics GROUP BY path ORDER BY cnt DESC LIMIT 50")
			across l_result.rows as ic loop
				l_row := ic
				Result.extend ([l_row.string_value ("path").to_string_8, l_row.integer_value ("cnt")])
			end
		ensure
			result_attached: Result /= Void
		end

	get_recent_requests (a_limit: INTEGER): ARRAYED_LIST [TUPLE [path: STRING; method: STRING; ip: STRING; created_at: STRING]]
			-- Get most recent requests
		require
			limit_positive: a_limit > 0
		local
			l_result: SIMPLE_SQL_RESULT
			l_row: SIMPLE_SQL_ROW
		do
			create Result.make (a_limit)
			l_result := db.query_with_args (
				"SELECT path, method, ip_address, created_at FROM analytics ORDER BY created_at DESC LIMIT ?",
				<<a_limit>>
			)
			across l_result.rows as ic loop
				l_row := ic
				Result.extend ([
					l_row.string_value_or_default ("path", ""),
					l_row.string_value_or_default ("method", ""),
					l_row.string_value_or_default ("ip_address", ""),
					l_row.string_value_or_default ("created_at", "")
				])
			end
		ensure
			result_attached: Result /= Void
		end

	get_analytics_summary: TUPLE [total_requests: INTEGER; unique_paths: INTEGER; unique_ips: INTEGER]
			-- Get summary statistics
		local
			l_result: SIMPLE_SQL_RESULT
			l_total, l_paths, l_ips: INTEGER
		do
			l_result := db.query ("SELECT COUNT(*) as cnt FROM analytics")
			if not l_result.rows.is_empty then
				l_total := l_result.rows.first.integer_value ("cnt")
			end

			l_result := db.query ("SELECT COUNT(DISTINCT path) as cnt FROM analytics")
			if not l_result.rows.is_empty then
				l_paths := l_result.rows.first.integer_value ("cnt")
			end

			l_result := db.query ("SELECT COUNT(DISTINCT ip_address) as cnt FROM analytics")
			if not l_result.rows.is_empty then
				l_ips := l_result.rows.first.integer_value ("cnt")
			end

			Result := [l_total, l_paths, l_ips]
		end

feature -- Contacts

	save_contact (a_name, a_email, a_subject, a_message, a_ip: STRING): INTEGER_64
			-- Save contact form submission, return ID
		require
			db_open: db.is_open
			name_not_empty: not a_name.is_empty
			email_not_empty: not a_email.is_empty
			message_not_empty: not a_message.is_empty
		do
			db.execute_with_args (
				"INSERT INTO contacts (name, email, subject, message, ip_address) VALUES (?, ?, ?, ?, ?)",
				<<a_name, a_email, a_subject, a_message, a_ip>>
			)
			if db.has_error then
				if attached db.last_error_message as l_err then
					log_info ("database", "Failed to save contact: " + l_err.to_string_8)
				end
				Result := -1
			else
				Result := db.last_insert_rowid
				log_info ("database", "Contact saved with ID: " + Result.out)
			end
		end

	get_contacts (a_limit: INTEGER): ARRAYED_LIST [TUPLE [id: INTEGER_64; name: STRING; email: STRING; subject: STRING; message: STRING; created_at: STRING; read_at: detachable STRING]]
			-- Get contact submissions
		require
			limit_positive: a_limit > 0
		local
			l_result: SIMPLE_SQL_RESULT
			l_row: SIMPLE_SQL_ROW
		do
			create Result.make (a_limit)
			l_result := db.query_with_args (
				"SELECT id, name, email, subject, message, created_at, read_at FROM contacts ORDER BY created_at DESC LIMIT ?",
				<<a_limit>>
			)
			across l_result.rows as ic loop
				l_row := ic
				Result.extend ([
					l_row.integer_64_value ("id"),
					l_row.string_value_or_default ("name", ""),
					l_row.string_value_or_default ("email", ""),
					l_row.string_value_or_default ("subject", ""),
					l_row.string_value_or_default ("message", ""),
					l_row.string_value_or_default ("created_at", ""),
					l_row.string_value_or_void ("read_at")
				])
			end
		ensure
			result_attached: Result /= Void
		end

	mark_contact_read (a_id: INTEGER_64)
			-- Mark contact as read
		require
			db_open: db.is_open
			id_positive: a_id > 0
		do
			db.execute_with_args (
				"UPDATE contacts SET read_at = datetime('now') WHERE id = ?",
				<<a_id>>
			)
		end

	get_unread_contact_count: INTEGER
			-- Count of unread contacts
		local
			l_result: SIMPLE_SQL_RESULT
		do
			l_result := db.query ("SELECT COUNT(*) as cnt FROM contacts WHERE read_at IS NULL")
			if not l_result.rows.is_empty then
				Result := l_result.rows.first.integer_value ("cnt")
			end
		end

feature -- Sessions

	create_session (a_token: STRING; a_hours: INTEGER): BOOLEAN
			-- Create admin session with expiration
		require
			db_open: db.is_open
			token_not_empty: not a_token.is_empty
			hours_positive: a_hours > 0
		do
			db.execute_with_args (
				"INSERT INTO sessions (token, expires_at) VALUES (?, datetime('now', '+' || ? || ' hours'))",
				<<a_token, a_hours>>
			)
			Result := not db.has_error
			if Result then
				log_info ("database", "Session created")
			end
		end

	validate_session (a_token: STRING): BOOLEAN
			-- Check if session token is valid and not expired
		require
			db_open: db.is_open
			token_not_empty: not a_token.is_empty
		local
			l_result: SIMPLE_SQL_RESULT
		do
			l_result := db.query_with_args (
				"SELECT COUNT(*) as cnt FROM sessions WHERE token = ? AND expires_at > datetime('now')",
				<<a_token>>
			)
			if not l_result.rows.is_empty then
				Result := l_result.rows.first.integer_value ("cnt") > 0
			end
		end

	delete_session (a_token: STRING)
			-- Delete session (logout)
		require
			db_open: db.is_open
			token_not_empty: not a_token.is_empty
		do
			db.execute_with_args ("DELETE FROM sessions WHERE token = ?", <<a_token>>)
			log_info ("database", "Session deleted")
		end

	cleanup_expired_sessions
			-- Remove expired sessions
		require
			db_open: db.is_open
		local
			l_count: INTEGER
		do
			db.execute ("DELETE FROM sessions WHERE expires_at <= datetime('now')")
			l_count := db.changes_count
			if l_count > 0 then
				log_info ("database", "Cleaned up " + l_count.out + " expired sessions")
			end
		end

feature -- Lifecycle

	close
			-- Close database connection
		do
			if db.is_open then
				db.close
				log_info ("database", "Database closed")
			end
		ensure
			closed: not db.is_open
		end

feature {NONE} -- Schema

	ensure_schema
			-- Create tables if they don't exist
		require
			db_open: db.is_open
		do
			log_info ("database", "Ensuring database schema...")

			-- Analytics table
			db.execute ("[
				CREATE TABLE IF NOT EXISTS analytics (
					id INTEGER PRIMARY KEY AUTOINCREMENT,
					path TEXT NOT NULL,
					method TEXT NOT NULL,
					ip_address TEXT,
					user_agent TEXT,
					referrer TEXT,
					response_code INTEGER,
					response_time_ms INTEGER,
					created_at TEXT DEFAULT (datetime('now'))
				)
			]")

			db.execute ("CREATE INDEX IF NOT EXISTS idx_analytics_path ON analytics(path)")
			db.execute ("CREATE INDEX IF NOT EXISTS idx_analytics_created ON analytics(created_at)")

			-- Contacts table
			db.execute ("[
				CREATE TABLE IF NOT EXISTS contacts (
					id INTEGER PRIMARY KEY AUTOINCREMENT,
					name TEXT NOT NULL,
					email TEXT NOT NULL,
					subject TEXT,
					message TEXT NOT NULL,
					ip_address TEXT,
					read_at TEXT,
					created_at TEXT DEFAULT (datetime('now'))
				)
			]")

			-- Sessions table
			db.execute ("[
				CREATE TABLE IF NOT EXISTS sessions (
					token TEXT PRIMARY KEY,
					created_at TEXT DEFAULT (datetime('now')),
					expires_at TEXT NOT NULL
				)
			]")

			db.execute ("CREATE INDEX IF NOT EXISTS idx_sessions_expires ON sessions(expires_at)")

			log_info ("database", "Schema ready")
		end

invariant
	db_attached: db /= Void
	db_path_not_empty: not db_path.is_empty

end
