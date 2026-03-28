#!/usr/bin/env bash
# =============================================================================
# HOOK: ConfigChange
# FIRES: When a settings/config file changes during a session
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field — matches config source):
#   "user_settings"    — ~/.claude/settings.json changed
#   "project_settings" — .claude/settings.json in project root changed
#   "local_settings"   — .claude/settings.local.json changed
#   "policy_settings"  — managed/enterprise policy settings changed
#   "skills"           — skill definitions changed
#   ""                 — empty string matches ALL config sources
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "ConfigChange",
#     "source":           "user_settings|project_settings|local_settings|policy_settings|skills",
#     "file_path":        "string — path to the changed config file",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "decision": "block",
#     "reason": "string — why config reload was blocked"
#   }
#
# EXIT CODES:
#   0   — Success. Config is reloaded.
#   2   — Blocking error. Config reload is BLOCKED. Stderr shown.
#   1,3-255 — Non-blocking error. Config reloads anyway. Stderr in verbose mode.
#
# WORKFLOW IMPACT:
#   This hook can BLOCK config changes from taking effect. Use it for:
#   - PREVENTING unauthorized permission changes
#   - VALIDATING config modifications
#   - LOGGING config changes for security audit
#   - ALERTING on unexpected settings modifications
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

SOURCE=$(echo "$INPUT" | jq -r '.source // "unknown"')
FILE_PATH=$(echo "$INPUT" | jq -r '.file_path // "unknown"')

# --- Your logic here ---

# Example: block changes to policy settings
# if [ "$SOURCE" = "policy_settings" ]; then
#   echo '{"decision": "block", "reason": "Policy settings cannot be modified during a session"}'
#   exit 0
# fi

exit 0
