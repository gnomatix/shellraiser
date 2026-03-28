#!/usr/bin/env bash
# =============================================================================
# HOOK: FileChanged
# FIRES: When a watched file changes on disk (async / background)
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field — matches filename):
#   ".env"              — matches .env file changes
#   ".envrc"            — matches .envrc file changes
#   ".envrc|.env"       — pipe-separated for multiple filenames
#   "*.config.js"       — glob patterns for config files
#   ""                  — empty string matches ALL watched files
#
# NOTE: Files must first be registered for watching. This typically happens
# via CwdChanged hooks that return watchPaths, or built-in watchers for
# common files like .env and .envrc.
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "FileChanged",
#     "file_path":        "string — full path to the changed file",
#     "file_name":        "string — basename only",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT:
#   Write environment variables to $CLAUDE_ENV_FILE to update the shell env:
#     export VAR_NAME=value
#   Or return JSON:
#   {
#     "watchPaths": [".env", ".envrc"]  // additional paths to watch
#   }
#
# EXIT CODES:
#   0       — Success.
#   1-255   — Non-blocking. File change is still registered.
#
# WORKFLOW IMPACT:
#   This hook runs ASYNCHRONOUSLY — it does not block Claude's workflow.
#   It fires when a watched file changes on disk (external editor, git, etc.).
#   Use it for:
#   - RELOADING environment variables when .env changes
#   - TRIGGERING rebuilds when config files change
#   - NOTIFYING Claude of external file modifications
#   - SYNCING state between external tools and Claude's session
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

FILE_PATH=$(echo "$INPUT" | jq -r '.file_path // ""')
FILE_NAME=$(echo "$INPUT" | jq -r '.file_name // ""')

# --- Your logic here ---

# Example: reload .env into Claude's environment
# if [ "$FILE_NAME" = ".env" ] && [ -n "${CLAUDE_ENV_FILE:-}" ]; then
#   # Copy all exports from .env to Claude's env file
#   grep -E '^[A-Z_]+=.' "$FILE_PATH" | sed 's/^/export /' > "$CLAUDE_ENV_FILE"
# fi

exit 0
