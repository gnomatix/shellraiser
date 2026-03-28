#!/usr/bin/env bash
# =============================================================================
# HOOK: PreToolUse
# FIRES: BEFORE a tool is executed, after Claude decides to use it
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field — matches tool_name):
#   "Bash"           — shell command execution
#   "Edit"           — file editing (string replacement)
#   "Write"          — file creation / full overwrite
#   "Read"           — file reading
#   "Glob"           — file pattern matching (find files)
#   "Grep"           — content search (ripgrep)
#   "WebFetch"       — HTTP fetch of a URL
#   "WebSearch"      — web search query
#   "Agent"          — subagent spawning
#   "NotebookEdit"   — Jupyter notebook editing
#   "mcp__*"         — any MCP tool (e.g., "mcp__github__create_issue")
#   "Edit|Write"     — pipe-separated for multiple tools
#   ""               — empty string matches ALL tools
#
# OPTIONAL "if" FILTER (settings.json, requires v2.1.85+):
#   Further filters by tool name AND arguments using permission rule syntax:
#   "if": "Bash(git *)"       — only git commands in Bash
#   "if": "Bash(npm test)"    — only npm test
#   "if": "Edit(*.ts)"        — only TypeScript file edits
#   "if": "Write(src/**)"     — only writes under src/
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "PreToolUse",
#     "tool_name":        "string — the tool being invoked",
#     "tool_input":       { /* tool-specific input object */ },
#     "tool_use_id":      "string — unique ID for this tool invocation",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
#   tool_input varies by tool:
#     Bash:      { "command": "string" }
#     Edit:      { "file_path": "string", "old_string": "string", "new_string": "string" }
#     Write:     { "file_path": "string", "content": "string" }
#     Read:      { "file_path": "string", "offset": number, "limit": number }
#     Glob:      { "pattern": "string", "path": "string" }
#     Grep:      { "pattern": "string", "path": "string", "type": "string" }
#     WebFetch:  { "url": "string" }
#     WebSearch: { "query": "string" }
#     Agent:     { "prompt": "string", "subagent_type": "string" }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "hookSpecificOutput": {
#       "hookEventName": "PreToolUse",
#       "permissionDecision": "allow|deny|ask",
#       "permissionDecisionReason": "string — shown to user/Claude",
#       "updatedInput": { /* modified tool_input — replaces original */ },
#       "additionalContext": "string — feedback text shown to Claude"
#     }
#   }
#
#   permissionDecision values:
#     "allow" — skip permission prompt, execute immediately
#               (still respects deny rules in permission config)
#     "deny"  — block execution, send reason to Claude
#     "ask"   — show normal permission prompt to user (default behavior)
#
#   updatedInput: replaces the tool_input entirely. Use to:
#     - Rewrite commands (e.g., add flags, change paths)
#     - Modify file paths or content before write
#     - Sanitize inputs
#
# EXIT CODES:
#   0   — Success. Parse stdout for JSON decisions.
#   2   — Blocking error. Tool execution is BLOCKED. Stderr shown to Claude.
#   1,3-255 — Non-blocking error. Tool proceeds. Stderr in verbose mode.
#
# WORKFLOW IMPACT:
#   This is the most powerful hook for controlling Claude's actions. It sits
#   between Claude's decision to use a tool and the actual execution.
#   - BLOCK dangerous operations (rm -rf, force push, drop table)
#   - AUTO-APPROVE safe operations (read-only commands, file reads)
#   - MODIFY inputs (add safety flags, redirect paths, sanitize)
#   - INJECT context to guide Claude's next steps
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
TOOL_INPUT=$(echo "$INPUT" | jq -c '.tool_input // {}')

# --- Your logic here ---

# Default: no opinion — let normal permission flow handle it
exit 0
