#!/usr/bin/env bash
# =============================================================================
# HOOK: StopFailure
# FIRES: When an API error occurs during Claude's turn
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field — matches error type):
#   "rate_limit"            — API rate limit hit
#   "authentication_failed" — auth token expired or invalid
#   "billing_error"         — billing/quota issue
#   "invalid_request"       — malformed API request
#   "server_error"          — Anthropic server error (5xx)
#   "max_output_tokens"     — response exceeded max output tokens
#   "unknown"               — unclassified error
#   ""                      — empty string matches ALL error types
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "StopFailure",
#     "error_type":       "string — one of the error types above",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT:
#   Stdout is ignored. This is a logging/notification-only hook.
#
# EXIT CODES:
#   0       — Success.
#   1-255   — All non-blocking. The error state persists regardless.
#
# WORKFLOW IMPACT:
#   This hook CANNOT prevent or retry the error. It is informational only.
#   Use it for:
#   - ALERTING on API failures (Slack, PagerDuty, email)
#   - LOGGING error frequency and types
#   - MONITORING rate limit patterns
#   - NOTIFYING on auth expiration so user can re-authenticate
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

ERROR_TYPE=$(echo "$INPUT" | jq -r '.error_type // "unknown"')

# --- Your logic here ---

# Example: log API errors
# echo "$(date -Iseconds) API_ERROR type=$ERROR_TYPE" >> ~/.claude/hooks/api-errors.log

# Example: desktop notification on rate limit
# if [ "$ERROR_TYPE" = "rate_limit" ] && command -v notify-send &>/dev/null; then
#   notify-send "Claude Code" "Rate limit hit — waiting for cooldown"
# fi

exit 0
