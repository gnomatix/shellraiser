#!/usr/bin/env bash
# =============================================================================
# HOOK: PostToolUseFailure
# FIRES: AFTER a tool call fails (error/exception during execution)
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field — matches tool_name):
#   Same tool names as PreToolUse:
#   "Bash", "Edit", "Write", "Read", "Glob", "Grep",
#   "WebFetch", "WebSearch", "Agent", "NotebookEdit", "mcp__*"
#   ""  — empty string matches ALL tools
#
# OPTIONAL "if" FILTER:
#   "if": "Bash(npm *)"   — only after failed npm commands
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "PostToolUseFailure",
#     "tool_name":        "string",
#     "tool_input":       { /* original tool input */ },
#     "tool_error":       "string — the error message from the failed tool",
#     "tool_use_id":      "string",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "additionalContext": "string — feedback injected into Claude's context"
#   }
#
# EXIT CODES:
#   0   — Success. Parse stdout for JSON.
#   1-255 — Non-blocking. Stderr in verbose mode.
#
# WORKFLOW IMPACT:
#   This hook fires when a tool errors out. It CANNOT retry the tool or
#   change the error. Use it for:
#   - LOGGING failures for debugging / monitoring
#   - INJECTING helpful context (e.g., "this error usually means X, try Y")
#   - ALERTING on repeated failures (e.g., Slack notification)
#   - TELEMETRY on tool reliability
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
TOOL_ERROR=$(echo "$INPUT" | jq -r '.tool_error // "unknown error"')

# --- Your logic here ---

# Example: log failures
# echo "$(date -Iseconds) TOOL_FAILURE tool=$TOOL_NAME error=$TOOL_ERROR" >> ~/.claude/hooks/failures.log

# Example: inject helpful context for common errors
# if echo "$TOOL_ERROR" | grep -q "EACCES"; then
#   echo '{"additionalContext": "Permission denied — check file ownership or try with appropriate permissions"}'
# fi

exit 0
