#!/usr/bin/env bash
# =============================================================================
# HOOK: PermissionRequest
# FIRES: When the permission dialog is about to be shown to the user
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field — matches tool_name):
#   Same tool names as PreToolUse:
#   "Bash", "Edit", "Write", "Read", "Glob", "Grep",
#   "WebFetch", "WebSearch", "Agent", "NotebookEdit", "mcp__*"
#   ""  — empty string matches ALL tools
#
# OPTIONAL "if" FILTER:
#   "if": "Bash(git *)"   — only git commands
#   "if": "Edit(*.py)"    — only Python file edits
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "PermissionRequest",
#     "tool_name":        "string — the tool requesting permission",
#     "tool_input":       { /* tool-specific input */ },
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "hookSpecificOutput": {
#       "hookEventName": "PermissionRequest",
#       "decision": {
#         "behavior": "allow|deny",
#         "updatedInput": { /* modified tool_input */ },
#         "updatedPermissions": [
#           {
#             "type": "setMode",
#             "mode": "acceptEdits|bypassPermissions|default",
#             "destination": "session"
#           }
#         ]
#       }
#     }
#   }
#
#   decision.behavior:
#     "allow" — auto-approve this permission request (skip user dialog)
#     "deny"  — auto-deny this permission request (skip user dialog)
#
#   decision.updatedInput:
#     Replaces tool_input for the approved action
#
#   decision.updatedPermissions:
#     Can change the permission mode for the rest of the session:
#     - "acceptEdits"       — auto-approve edit/write operations
#     - "bypassPermissions" — auto-approve everything
#     - "default"           — reset to default permission mode
#     destination must be "session" (applies to current session only)
#
# EXIT CODES:
#   0   — Success. Parse stdout for JSON decisions.
#   2   — Blocking error. Permission request is denied. Stderr shown to Claude.
#   1,3-255 — Non-blocking error. Normal permission prompt shown. Stderr in verbose mode.
#
# WORKFLOW IMPACT:
#   This hook intercepts the permission dialog BEFORE the user sees it.
#   Unlike PreToolUse (which fires before permission check), this hook fires
#   specifically when a permission prompt would be shown.
#   - AUTO-APPROVE known-safe operations programmatically
#   - AUTO-DENY operations that violate policy
#   - ESCALATE/CHANGE permission mode for the session
#   - Used for automated workflows where no human is at the keyboard
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')

# --- Your logic here ---

# Example: auto-approve all read operations
# case "$TOOL_NAME" in
#   Read|Glob|Grep)
#     cat <<'EOF'
# {
#   "hookSpecificOutput": {
#     "hookEventName": "PermissionRequest",
#     "decision": {
#       "behavior": "allow"
#     }
#   }
# }
# EOF
#     exit 0
#     ;;
# esac

# Default: no decision — show normal permission prompt
exit 0
