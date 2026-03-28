#!/usr/bin/env bash
# =============================================================================
# HOOK: PostCompact
# FIRES: After context compaction completes
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field):
#   "manual"  — user-triggered compaction
#   "auto"    — system-triggered compaction
#   ""        — empty string matches both
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "PostCompact",
#     "source":           "manual|auto",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT:
#   Stdout is ignored. This is a logging-only hook.
#
# EXIT CODES:
#   0       — Success.
#   1-255   — Non-blocking. Session continues regardless.
#
# WORKFLOW IMPACT:
#   This hook CANNOT affect the compaction result. It is informational only.
#   Use it for:
#   - LOGGING compaction completion and timing
#   - VERIFYING context state post-compaction
#   - INJECTING reminders that may have been lost during compaction
#     (though SessionStart with "compact" matcher is better for this)
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

SOURCE=$(echo "$INPUT" | jq -r '.source // "unknown"')

# --- Your logic here ---

# Example: log compaction completion
# echo "$(date -Iseconds) PostCompact source=$SOURCE" >> ~/.claude/hooks/compact.log

exit 0
