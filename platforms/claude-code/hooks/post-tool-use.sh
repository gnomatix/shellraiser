#!/usr/bin/env bash
# =============================================================================
# HOOK: PostToolUse
# FIRES: AFTER a tool executes successfully
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field — matches tool_name):
#   Same tool names as PreToolUse:
#   "Bash", "Edit", "Write", "Read", "Glob", "Grep",
#   "WebFetch", "WebSearch", "Agent", "NotebookEdit", "mcp__*"
#   ""  — empty string matches ALL tools
#
# OPTIONAL "if" FILTER:
#   "if": "Bash(git *)"   — only after git commands
#   "if": "Write(*.ts)"   — only after writing TypeScript files
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "PostToolUse",
#     "tool_name":        "string",
#     "tool_input":       { /* original tool input */ },
#     "tool_result":      { /* result from the tool execution */ },
#     "tool_use_id":      "string",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "decision": "block",
#     "reason": "string — why Claude should not proceed",
#     "additionalContext": "string — feedback injected into Claude's context",
#     "updatedMCPToolOutput": "string — replaces MCP tool output seen by Claude"
#   }
#
#   decision values:
#     "block" — prevents Claude from continuing its current line of action.
#               The tool already executed (can't undo), but Claude gets the
#               reason and should change course.
#     (omit)  — normal flow continues
#
#   updatedMCPToolOutput:
#     Only applies to MCP tools. Replaces the tool output that Claude sees.
#     Use to filter sensitive data or add annotations.
#
# EXIT CODES:
#   0   — Success. Parse stdout for JSON.
#   2   — Non-blocking (tool already ran). Stderr logged.
#   1,3-255 — Non-blocking error. Stderr in verbose mode.
#
# NOTE: Exit code 2 does NOT block here (unlike PreToolUse) because the tool
#       has already executed. The action cannot be undone.
#
# WORKFLOW IMPACT:
#   This hook runs after successful tool execution. The tool's action has
#   already happened (file written, command run, etc.). Use it for:
#   - AUTO-FORMATTING files after Edit/Write (e.g., prettier, black, gofmt)
#   - LINTING after code changes
#   - LOGGING all tool actions for audit
#   - INJECTING feedback (e.g., "tests now failing after that change")
#   - BLOCKING further action if the result is problematic
#   - FILTERING MCP tool output to remove sensitive data
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

# Example: auto-format after file writes
# if [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "Edit" ]; then
#   FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // ""')
#   if [ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ]; then
#     case "$FILE_PATH" in
#       *.ts|*.tsx|*.js|*.jsx|*.json|*.css)
#         npx prettier --write "$FILE_PATH" 2>/dev/null ;;
#       *.py)
#         black "$FILE_PATH" 2>/dev/null ;;
#       *.go)
#         gofmt -w "$FILE_PATH" 2>/dev/null ;;
#     esac
#   fi
# fi

exit 0
