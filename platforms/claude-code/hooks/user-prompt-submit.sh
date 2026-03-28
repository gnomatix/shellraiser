#!/usr/bin/env bash
# =============================================================================
# HOOK: UserPromptSubmit
# FIRES: When the user submits a prompt, BEFORE Claude processes it
# =============================================================================
#
# MATCHERS:
#   None — this hook has no matcher support. It fires on EVERY prompt submission.
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "UserPromptSubmit",
#     "prompt":           "string — the full text of the user's prompt",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "additionalContext": "string — text injected into Claude's context for this turn",
#     "continue": false,          // set false to BLOCK the prompt entirely
#     "stopReason": "string",     // shown to user if continue=false
#     "systemMessage": "string"   // warning shown to user
#   }
#
#   To block the prompt:
#   {
#     "continue": false,
#     "stopReason": "Prompt blocked: reason here"
#   }
#
# EXIT CODES:
#   0   — Success. Parse stdout for JSON output.
#   2   — Blocking error. Stderr shown as feedback; prompt is blocked.
#   1,3-255 — Non-blocking error. Stderr shown in verbose mode only.
#
# WORKFLOW IMPACT:
#   This hook sits between the user pressing Enter and Claude seeing the prompt.
#   It CAN:
#   - Block the prompt entirely (continue: false or exit 2)
#   - Inject additional context that Claude sees alongside the prompt
#   - Log/audit all user prompts
#   Use cases:
#   - Content filtering / guardrails on user input
#   - Injecting dynamic context (time, env state, git status)
#   - Prompt logging for compliance
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""')

# --- Your logic here ---
# Example: block prompts containing sensitive keywords
# if echo "$PROMPT" | grep -qi "drop table\|rm -rf /"; then
#   echo '{"continue": false, "stopReason": "Prompt blocked: potentially destructive command detected"}'
#   exit 0
# fi

# Example: inject timestamp context
# echo "{\"additionalContext\": \"Current time: $(date -Iseconds)\"}"

exit 0
