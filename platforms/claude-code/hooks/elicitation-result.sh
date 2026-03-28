#!/usr/bin/env bash
# =============================================================================
# HOOK: ElicitationResult
# FIRES: When the user responds to an MCP elicitation dialog
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field — matches MCP server name):
#   Same as Elicitation: MCP server names or "" for all
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "ElicitationResult",
#     "mcp_server_name":  "string — name of the MCP server",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "action": "accept|decline|cancel",
#     "content": "string — override or modify the user's response"
#   }
#
# EXIT CODES:
#   0   — Success. Parse stdout for JSON.
#   2   — Blocking error. Stderr shown.
#   1,3-255 — Non-blocking error. Stderr in verbose mode.
#
# WORKFLOW IMPACT:
#   This hook fires AFTER the user responds to an MCP elicitation.
#   Use it for:
#   - MODIFYING user responses before they reach the MCP server
#   - LOGGING user responses to MCP requests
#   - OVERRIDING user responses programmatically
#   - AUDITING MCP server interactions
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

MCP_SERVER=$(echo "$INPUT" | jq -r '.mcp_server_name // "unknown"')

# --- Your logic here ---

# Example: log elicitation results
# echo "$(date -Iseconds) ElicitationResult server=$MCP_SERVER" >> ~/.claude/hooks/mcp.log

exit 0
