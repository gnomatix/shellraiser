#!/usr/bin/env bash
# =============================================================================
# HOOK: TaskCompleted
# FIRES: When a task is being marked as complete (via TaskUpdate)
# =============================================================================
#
# MATCHERS:
#   None — this hook has no matcher support. It fires on every task completion.
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "TaskCompleted",
#     "task_id":          "string",
#     "task_title":       "string",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "continue": false,
#     "stopReason": "string — why task completion was blocked"
#   }
#
# EXIT CODES:
#   0   — Success. Task marked complete.
#   2   — Blocking error. Task completion is BLOCKED. Stderr shown to Claude.
#   1,3-255 — Non-blocking error. Task completed anyway. Stderr in verbose mode.
#
# WORKFLOW IMPACT:
#   This hook can BLOCK task completion. Use it for:
#   - VALIDATING completion criteria (tests pass, linting clean)
#   - SYNCING completion status to external trackers
#   - LOGGING task completion metrics (duration, etc.)
#   - ENFORCING review before marking done
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

TASK_ID=$(echo "$INPUT" | jq -r '.task_id // "unknown"')
TASK_TITLE=$(echo "$INPUT" | jq -r '.task_title // "untitled"')

# --- Your logic here ---

# Example: log task completion
# echo "$(date -Iseconds) TaskCompleted id=$TASK_ID title=$TASK_TITLE" >> ~/.claude/hooks/tasks.log

exit 0
