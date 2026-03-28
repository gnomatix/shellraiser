#!/usr/bin/env bash
# =============================================================================
# HOOK: WorktreeRemove
# FIRES: When a git worktree is being removed/cleaned up
# =============================================================================
#
# MATCHERS:
#   None — this hook has no matcher support. It fires on every worktree removal.
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "WorktreeRemove",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT:
#   Stdout is ignored. This is a cleanup/logging-only hook.
#
# EXIT CODES:
#   0       — Success.
#   1-255   — Non-blocking. Worktree removal proceeds regardless.
#
# WORKFLOW IMPACT:
#   This hook CANNOT prevent worktree removal. It is informational only.
#   Use it for:
#   - CLEANING UP resources associated with the worktree
#   - LOGGING worktree lifecycle for resource tracking
#   - ARCHIVING worktree contents before deletion
#   - FREEING external resources (ports, services, etc.)
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

# --- Your logic here ---

# Example: log worktree removal
# echo "$(date -Iseconds) WorktreeRemove" >> ~/.claude/hooks/worktrees.log

exit 0
