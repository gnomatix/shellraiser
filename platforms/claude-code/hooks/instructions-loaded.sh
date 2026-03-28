#!/usr/bin/env bash
# =============================================================================
# HOOK: InstructionsLoaded
# FIRES: When CLAUDE.md or rules files are loaded into context
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field):
#   "session_start"     — instructions loaded at session start
#   "nested_traversal"  — instructions loaded via directory traversal
#   "path_glob_match"   — instructions loaded via path glob matching
#   "include"           — instructions loaded via @include directive
#   "compact"           — instructions reloaded after context compaction
#   ""                  — empty string matches ALL of the above
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "InstructionsLoaded",
#     "source":           "session_start|nested_traversal|path_glob_match|include|compact",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT:
#   Stdout is ignored. This is a logging-only hook.
#
# EXIT CODES:
#   0       — Success.
#   1-255   — Non-blocking. Instructions load regardless.
#
# WORKFLOW IMPACT:
#   This hook CANNOT prevent instructions from loading. It is informational.
#   Use it for:
#   - Auditing which instruction files are loaded
#   - Logging when rules change or are reloaded
#   - Debugging instruction loading order
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

SOURCE=$(echo "$INPUT" | jq -r '.source // "unknown"')

# --- Your logic here ---
# Example: log instruction load events
# echo "$(date -Iseconds) InstructionsLoaded source=$SOURCE" >> ~/.claude/hooks/audit.log

exit 0
