#!/usr/bin/env bash
# =============================================================================
# HOOK: Stop
# FIRES: When the main agent finishes responding (about to go idle)
# =============================================================================
#
# MATCHERS:
#   None — this hook has no matcher support. It fires every time Claude stops.
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "Stop",
#     "stop_hook_active": "boolean — true if this hook already ran once this turn",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
#   IMPORTANT: stop_hook_active prevents infinite loops. If true, the hook
#   already blocked a stop attempt this turn. Check this to avoid looping.
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "decision": "block",
#     "reason": "string — why Claude should continue working"
#   }
#
# EXIT CODES:
#   0   — Success. Parse stdout for JSON.
#   2   — Blocking error. Claude is prevented from stopping. Stderr shown.
#   1,3-255 — Non-blocking error. Claude stops normally. Stderr in verbose mode.
#
# WORKFLOW IMPACT:
#   This is a powerful hook that can PREVENT Claude from finishing its turn.
#   When blocked, Claude receives the reason and continues working.
#   Use it for:
#   - ENFORCING quality gates (run tests before stopping)
#   - REQUIRING certain actions (must commit, must update docs)
#   - CONTINUOUS WORKFLOWS (keep working until condition is met)
#
#   WARNING: Always check stop_hook_active to avoid infinite loops!
#   If the hook blocks, Claude works more, then tries to stop again —
#   the hook fires again with stop_hook_active=true. You should allow
#   the stop on the second attempt to avoid endless loops.
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // "false"')

# IMPORTANT: Prevent infinite loops — if hook already blocked once, allow stop
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

# --- Your logic here ---

# Example: require passing tests before stopping
# CWD=$(echo "$INPUT" | jq -r '.cwd // "."')
# if [ -f "$CWD/package.json" ] && grep -q '"test"' "$CWD/package.json"; then
#   if ! (cd "$CWD" && npm test --silent 2>/dev/null); then
#     echo '{"decision": "block", "reason": "Tests are failing. Please fix before finishing."}'
#     exit 0
#   fi
# fi

exit 0
