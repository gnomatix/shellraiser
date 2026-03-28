#!/usr/bin/env bash
# =============================================================================
# HOOK: Elicitation
# FIRES: When an MCP server requests user input
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field — matches MCP server name):
#   "memory"       — memory MCP server
#   "github"       — GitHub MCP server
#   Any configured MCP server name from your settings
#   ""             — empty string matches ALL MCP servers
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "Elicitation",
#     "mcp_server_name":  "string — name of the MCP server requesting input",
#     "user_prompt":      "string — the input request from the server",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "action": "accept|decline|cancel",
#     "content": "string — response to the MCP server"
#   }
#
#   action values:
#     "accept"  — approve the elicitation with content as the response
#     "decline" — decline the elicitation request
#     "cancel"  — cancel the elicitation entirely
#
# EXIT CODES:
#   0   — Success. Parse stdout for JSON.
#   2   — Blocking error. Elicitation is cancelled. Stderr shown.
#   1,3-255 — Non-blocking error. Normal elicitation flow. Stderr in verbose mode.
#
# WORKFLOW IMPACT:
#   This hook can AUTO-RESPOND to MCP server input requests. Use it for:
#   - AUTO-APPROVING known-safe MCP elicitations
#   - AUTO-DECLINING unwanted MCP requests
#   - PROVIDING automated responses to MCP servers
#   - LOGGING MCP interaction patterns
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

MCP_SERVER=$(echo "$INPUT" | jq -r '.mcp_server_name // "unknown"')
USER_PROMPT=$(echo "$INPUT" | jq -r '.user_prompt // ""')

# --- Your logic here ---

# Example: auto-approve memory server elicitations
# if [ "$MCP_SERVER" = "memory" ]; then
#   echo '{"action": "accept", "content": "approved"}'
#   exit 0
# fi

exit 0
