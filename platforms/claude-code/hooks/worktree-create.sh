#!/usr/bin/env bash
# =============================================================================
# HOOK: WorktreeCreate
# FIRES: When a git worktree is being created for an isolated agent
# =============================================================================
#
# MATCHERS:
#   None — this hook has no matcher support. It fires on every worktree creation.
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "WorktreeCreate",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT:
#   Return the worktree path either as:
#   - Plain text on stdout (the path string)
#   - JSON: { "worktreePath": "/path/to/worktree" }
#
#   If output is provided, it overrides the default worktree location.
#
# EXIT CODES:
#   0   — Success. Parse stdout for worktree path.
#   2   — Blocking error. Worktree creation is BLOCKED. Stderr shown.
#   1,3-255 — Non-blocking error. Default worktree creation proceeds.
#
# WORKFLOW IMPACT:
#   This hook can CUSTOMIZE or BLOCK worktree creation. Use it for:
#   - CUSTOMIZING worktree locations (e.g., RAM disk, specific directory)
#   - BLOCKING worktree creation if resources are constrained
#   - PRE-CONFIGURING worktrees (install deps, set up env)
#   - LOGGING worktree creation for resource tracking
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

# --- Your logic here ---

# Example: create worktree in a specific location
# WORKTREE_BASE="/tmp/claude-worktrees"
# mkdir -p "$WORKTREE_BASE"
# WORKTREE_PATH=$(mktemp -d "$WORKTREE_BASE/wt-XXXXXX")
# echo "{\"worktreePath\": \"$WORKTREE_PATH\"}"

# Default: no output means use default worktree location
exit 0
