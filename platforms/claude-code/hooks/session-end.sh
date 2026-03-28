#!/usr/bin/env bash
# =============================================================================
# HOOK: SessionEnd
# FIRES: When a session terminates for any reason
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field):
#   "clear"                       — user ran /clear
#   "resume"                      — session ended because a different session resumed
#   "logout"                      — user logged out
#   "prompt_input_exit"           — user exited at the prompt (Ctrl+C, Ctrl+D, /exit)
#   "bypass_permissions_disabled" — session ended because bypass permissions was disabled
#   "other"                       — any other reason
#   ""                            — empty string matches ALL of the above
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "SessionEnd",
#     "source":           "clear|resume|logout|prompt_input_exit|bypass_permissions_disabled|other",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT:
#   Stdout is ignored. This is a logging/cleanup-only hook.
#
# EXIT CODES:
#   0       — Success (cleanup completed).
#   1-255   — All treated as non-blocking. Session ends regardless.
#
# WORKFLOW IMPACT:
#   This hook CANNOT prevent the session from ending. It is fire-and-forget.
#   Use it for:
#   - Audit logging (who used Claude, when, how long)
#   - Cleanup of temporary files or processes
#   - Telemetry / analytics
#   - Saving session metadata externally
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
SOURCE=$(echo "$INPUT" | jq -r '.source // "unknown"')

# --- Your logic here ---
# Example: log session end
# echo "$(date -Iseconds) SessionEnd session=$SESSION_ID source=$SOURCE" >> ~/.claude/hooks/audit.log

exit 0
