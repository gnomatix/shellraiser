#!/usr/bin/env bash
# =============================================================================
# HOOK: TeammateIdle
# FIRES: When a team member (in multi-agent/team mode) is about to go idle
# =============================================================================
#
# MATCHERS:
#   None — this hook has no matcher support. It fires on every idle event.
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "TeammateIdle",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "continue": false   // set false to allow idle (default behavior)
#   }
#
# EXIT CODES:
#   0   — Success. Parse stdout for JSON.
#   2   — Blocking: prevents the teammate from going idle.
#   1,3-255 — Non-blocking. Teammate goes idle. Stderr in verbose mode.
#
# WORKFLOW IMPACT:
#   This hook fires in team/multi-agent workflows when a teammate is about
#   to become idle. Use it to:
#   - KEEP teammates active by blocking idle (exit 2 or continue: false)
#   - LOG team member activity patterns
#   - TRIGGER follow-up work assignment
#   - COORDINATE multi-agent task distribution
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

# --- Your logic here ---

# Example: log idle events
# echo "$(date -Iseconds) TeammateIdle" >> ~/.claude/hooks/team.log

exit 0
