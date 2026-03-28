#!/usr/bin/env bash
# =============================================================================
# HOOK: PreCompact
# FIRES: Before context compaction begins
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field):
#   "manual"  — user triggered compaction via /compact
#   "auto"    — system triggered compaction (context window near limit)
#   ""        — empty string matches both
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "PreCompact",
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
#   1-255   — Non-blocking. Compaction proceeds regardless.
#
# WORKFLOW IMPACT:
#   This hook CANNOT prevent compaction. It is informational only.
#   Use it for:
#   - SAVING context snapshots before compaction
#   - LOGGING compaction frequency (detect excessive auto-compactions)
#   - EXPORTING conversation state to external storage
#   - BENCHMARKING compaction performance
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

SOURCE=$(echo "$INPUT" | jq -r '.source // "unknown"')

# --- Your logic here ---

# Example: log compaction events
# echo "$(date -Iseconds) PreCompact source=$SOURCE" >> ~/.claude/hooks/compact.log

exit 0
