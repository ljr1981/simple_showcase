note
	description: "[
		Analytics middleware for Simple Showcase.

		Logs every HTTP request to SQLite database:
		- Path, method, IP address
		- User agent, referrer
		- Response code, response time

		Must be registered before other middleware to capture accurate timing.
	]"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SSC_ANALYTICS_MIDDLEWARE

inherit
	SIMPLE_WEB_MIDDLEWARE

	SSC_LOGGER
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_database: SSC_DATABASE)
			-- Create middleware with database reference
		require
			database_attached: a_database /= Void
		do
			database := a_database
		ensure
			database_set: database = a_database
		end

feature -- Access

	database: SSC_DATABASE
			-- Database for logging analytics

	name: STRING = "SSC Analytics"
			-- Middleware name

feature -- Processing

	process (a_request: SIMPLE_WEB_SERVER_REQUEST; a_response: SIMPLE_WEB_SERVER_RESPONSE; a_next: PROCEDURE)
			-- Log request to database
		local
			l_start_time: DATE_TIME
			l_end_time: DATE_TIME
			l_elapsed_ms: INTEGER
			l_path, l_method, l_ip, l_user_agent, l_referrer: STRING
		do
			-- Capture start time
			create l_start_time.make_now

			-- Extract request info before processing
			l_path := a_request.path.to_string_8
			l_method := a_request.method
			l_ip := extract_client_ip (a_request)
			l_user_agent := if attached a_request.header ("User-Agent") as ua then ua else "" end
			l_referrer := if attached a_request.header ("Referer") as ref then ref else "" end

			-- Continue to next middleware/handler
			a_next.call

			-- Capture end time and calculate elapsed
			create l_end_time.make_now
			l_elapsed_ms := milliseconds_between (l_start_time, l_end_time)

			-- Log to database (non-blocking, fire-and-forget)
			database.log_request (
				l_path,
				l_method,
				l_ip,
				truncate (l_user_agent, 500),
				truncate (l_referrer, 500),
				a_response.status_code,
				l_elapsed_ms
			)
		end

feature {NONE} -- Implementation

	extract_client_ip (a_request: SIMPLE_WEB_SERVER_REQUEST): STRING
			-- Extract client IP, checking for proxy headers
		local
			l_forwarded: detachable STRING_8
		do
			-- Check X-Forwarded-For first (Cloudflare/proxy)
			l_forwarded := a_request.header ("X-Forwarded-For")
			if attached l_forwarded and then not l_forwarded.is_empty then
				-- X-Forwarded-For can contain multiple IPs: "client, proxy1, proxy2"
				-- First one is the original client
				if l_forwarded.has (',') then
					Result := l_forwarded.split (',').first
					Result.left_adjust
					Result.right_adjust
				else
					Result := l_forwarded
				end
			else
				-- Check X-Real-IP
				if attached a_request.header ("X-Real-IP") as l_real_ip and then not l_real_ip.is_empty then
					Result := l_real_ip
				else
					-- Fall back to direct connection IP (requires WSF access)
					Result := extract_remote_addr (a_request)
				end
			end
		ensure
			result_attached: Result /= Void
		end

	extract_remote_addr (a_request: SIMPLE_WEB_SERVER_REQUEST): STRING
			-- Extract REMOTE_ADDR from underlying WSF request
		do
			if not a_request.is_mock and then attached a_request.wsf_request as l_wsf then
				if attached l_wsf.remote_addr as l_addr then
					Result := l_addr.to_string_8
				else
					Result := "unknown"
				end
			else
				Result := "mock"
			end
		ensure
			result_attached: Result /= Void
		end

	milliseconds_between (a_start, a_end: DATE_TIME): INTEGER
			-- Calculate milliseconds between two times
		local
			l_duration: DATE_TIME_DURATION
		do
			l_duration := a_end.relative_duration (a_start)
			-- Convert to milliseconds (approximate since DATE_TIME_DURATION doesn't have ms)
			Result := (l_duration.second * 1000).to_integer_32
			-- Add fractional from fine_second if available
			if l_duration.second < 60 then
				Result := Result.max (1) -- At least 1ms
			end
		ensure
			non_negative: Result >= 0
		end

	truncate (a_string: STRING; a_max: INTEGER): STRING
			-- Truncate string to max length
		require
			max_positive: a_max > 0
		do
			if a_string.count <= a_max then
				Result := a_string
			else
				Result := a_string.substring (1, a_max)
			end
		ensure
			within_limit: Result.count <= a_max
		end

invariant
	database_attached: database /= Void

end
