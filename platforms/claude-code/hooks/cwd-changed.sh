#!/usr/bin/env bash
# =============================================================================
# HOOK: CwdChanged
# FIRES: When the working directory changes (async / background)
# =============================================================================
#
# MATCHERS:
#   None — this hook has no matcher support. It fires on every cwd change.
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string — the NEW working directory",
#     "hook_event_name":  "CwdChanged",
#     "previous_cwd":     "string — the old working directory",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT:
#   Write environment variables to $CLAUDE_ENV_FILE:
#     export VAR_NAME=value
#   These are applied before the next bash command in the new directory.
#
#   Or return JSON to register file watchers:
#   {
#     "watchPaths": [".env", ".envrc", "config.yaml"]
#   }
#
# EXIT CODES:
#   0       — Success.
#   1-255   — Non-blocking. Directory change proceeds regardless.
#
# WORKFLOW IMPACT:
#   This hook runs ASYNCHRONOUSLY when Claude changes working directory.
#   It CANNOT prevent the directory change. Use it for:
#   - LOADING project-specific environment variables
#   - REGISTERING file watchers for the new directory
#   - ACTIVATING virtual environments (nvm, pyenv, direnv)
#   - LOGGING directory navigation for audit
#
# ENVIRONMENT:
#   $CLAUDE_ENV_FILE — path to write env var updates (export KEY=value format)
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

NEW_CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
OLD_CWD=$(echo "$INPUT" | jq -r '.previous_cwd // ""')

# --- Your logic here ---

# Example: load .env if present in new directory
# if [ -f "$NEW_CWD/.env" ] && [ -n "${CLAUDE_ENV_FILE:-}" ]; then
#   grep -E '^[A-Z_]+=.' "$NEW_CWD/.env" | sed 's/^/export /' > "$CLAUDE_ENV_FILE"
# fi

# Example: register file watchers
# if [ -f "$NEW_CWD/.env" ]; then
#   echo '{"watchPaths": [".env", ".envrc"]}'
# fi

exit 0
