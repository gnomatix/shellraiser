#!/usr/bin/env bash
# =============================================================================
# HOOK: Notification
# FIRES: When a notification is sent to the user
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field — matches notification type):
#   "permission_prompt"   — permission dialog is being shown
#   "idle_prompt"         — Claude is idle and waiting for input
#   "auth_success"        — authentication completed successfully
#   "elicitation_dialog"  — MCP server is requesting user input
#   ""                    — empty string matches ALL notification types
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "Notification",
#     "notification_type": "permission_prompt|idle_prompt|auth_success|elicitation_dialog",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "additionalContext": "string — context injected into Claude"
#   }
#
# EXIT CODES:
#   0   — Success. Parse stdout for JSON.
#   1-255 — Non-blocking. Notification proceeds regardless.
#
# WORKFLOW IMPACT:
#   This hook is primarily informational. It CANNOT block notifications.
#   Use it for:
#   - DESKTOP NOTIFICATIONS (notify-send, osascript) when Claude needs attention
#   - SOUND ALERTS when permission prompts appear
#   - SLACK/WEBHOOK notifications for idle prompts in headless mode
#   - LOGGING notification patterns
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.notification_type // "unknown"')

# --- Your logic here ---

# Example: desktop notification when Claude needs attention
# case "$NOTIFICATION_TYPE" in
#   permission_prompt)
#     notify-send "Claude Code" "Permission required — check your terminal" 2>/dev/null ;;
#   idle_prompt)
#     notify-send "Claude Code" "Claude is waiting for input" 2>/dev/null ;;
# esac

exit 0
