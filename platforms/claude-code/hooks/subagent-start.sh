#!/usr/bin/env bash
# =============================================================================
# HOOK: SubagentStart
# FIRES: When a subagent (child agent) is spawned
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field — matches agent type):
#   "Bash"     — Bash execution subagent
#   "Explore"  — codebase exploration agent
#   "Plan"     — planning/architecture agent
#   "general-purpose" — general purpose agent
#   Custom agent names defined in .claude/agents/*.md
#   ""         — empty string matches ALL agent types
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "SubagentStart",
#     "agent_type":       "string — the type of subagent being spawned",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "hookSpecificOutput": {
#       "hookEventName": "SubagentStart",
#       "additionalContext": "string — context injected into the subagent"
#     }
#   }
#
# EXIT CODES:
#   0   — Success. Parse stdout for JSON.
#   2   — Blocking error. Subagent spawn is blocked. Stderr shown to Claude.
#   1,3-255 — Non-blocking error. Subagent proceeds. Stderr in verbose mode.
#
# WORKFLOW IMPACT:
#   This hook fires when Claude spawns a subagent via the Agent tool.
#   - INJECT context into the subagent (project conventions, warnings)
#   - BLOCK subagent creation if policy disallows it
#   - LOG subagent activity for monitoring resource usage
#   - LIMIT concurrent subagents by tracking active count
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')

# --- Your logic here ---

# Example: inject conventions into all subagents
# echo '{"hookSpecificOutput": {"hookEventName": "SubagentStart", "additionalContext": "Remember: use bun, not npm."}}'

exit 0
