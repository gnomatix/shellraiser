#!/usr/bin/env bash
# =============================================================================
# HOOK: SessionStart
# FIRES: When a new session begins or an existing session resumes
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field):
#   "startup"  — fresh session start (user ran `claude` or opened new window)
#   "resume"   — resuming a previous session
#   "clear"    — session cleared via /clear
#   "compact"  — session restarted after context compaction
#   ""         — empty string matches ALL of the above
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string — unique session identifier",
#     "cwd":              "string — current working directory",
#     "hook_event_name":  "SessionStart",
#     "source":           "startup|resume|clear|compact",
#     "transcript_path":  "string — path to session transcript .jsonl",
#     "permission_mode":  "default|plan|acceptEdits|auto|dontAsk|bypassPermissions"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   Plain text on stdout is injected as additional context into the session.
#   Structured JSON output:
#   {
#     "hookSpecificOutput": {
#       "hookEventName": "SessionStart",
#       "additionalContext": "string — text injected into Claude's context"
#     }
#   }
#
# EXIT CODES:
#   0   — Success. Stdout (text or JSON) is processed.
#   2   — Blocking error. Stderr is shown to Claude as feedback.
#   1,3-255 — Non-blocking error. Stderr shown only in verbose mode (Ctrl+O).
#
# WORKFLOW IMPACT:
#   This hook runs at the very start of a session. It CANNOT prevent the session
#   from starting, but it CAN inject context that Claude will see. Use this to:
#   - Inject environment info (git branch, recent commits, CI status)
#   - Add project reminders or conventions
#   - Log session starts for auditing
# =============================================================================

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Validate JSON
if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

# Extract fields
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
SOURCE=$(echo "$INPUT" | jq -r '.source // "unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // "unknown"')

# --- Your logic here ---
# Example: inject git branch info on startup
# if [ "$SOURCE" = "startup" ] && command -v git &>/dev/null; then
#   BRANCH=$(git -C "$CWD" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "N/A")
#   echo "Current git branch: $BRANCH"
# fi

# Minimal success — no output means no context injected
exit 0
