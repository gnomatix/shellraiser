#!/usr/bin/env bash
# =============================================================================
# HOOK: TaskCreated
# FIRES: When a task is being created (via TaskCreate tool)
# =============================================================================
#
# MATCHERS:
#   None — this hook has no matcher support. It fires on every task creation.
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "TaskCreated",
#     "task_id":          "string — unique task identifier",
#     "task_title":       "string — the task description",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "continue": false,
#     "stopReason": "string — why task creation was blocked"
#   }
#
# EXIT CODES:
#   0   — Success. Task is created.
#   2   — Blocking error. Task creation is BLOCKED. Stderr shown to Claude.
#   1,3-255 — Non-blocking error. Task created anyway. Stderr in verbose mode.
#
# WORKFLOW IMPACT:
#   This hook can BLOCK task creation. Use it for:
#   - VALIDATING task descriptions (enforce naming conventions)
#   - LIMITING total number of active tasks
#   - SYNCING tasks to external systems (Jira, Linear, GitHub Issues)
#   - LOGGING task creation for project tracking
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

# Example: log task creation
# echo "$(date -Iseconds) TaskCreated id=$TASK_ID title=$TASK_TITLE" >> ~/.claude/hooks/tasks.log

exit 0
