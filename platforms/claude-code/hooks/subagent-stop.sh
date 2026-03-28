#!/usr/bin/env bash
# =============================================================================
# HOOK: SubagentStop
# FIRES: When a subagent finishes execution
# =============================================================================
#
# MATCHERS (configure in settings.json "matcher" field — matches agent type):
#   "Bash", "Explore", "Plan", "general-purpose", custom agent names
#   ""  — empty string matches ALL agent types
#
# INPUT (JSON on stdin):
#   {
#     "session_id":       "string",
#     "cwd":              "string",
#     "hook_event_name":  "SubagentStop",
#     "agent_type":       "string",
#     "success":          "boolean — whether the subagent completed successfully",
#     "transcript_path":  "string",
#     "permission_mode":  "string"
#   }
#
# OUTPUT (JSON on stdout, optional):
#   {
#     "decision": "block",
#     "reason": "string — prevents parent from accepting subagent result"
#   }
#
# EXIT CODES:
#   0   — Success. Parse stdout for JSON.
#   2   — Blocking error. Subagent result is rejected. Stderr shown to Claude.
#   1,3-255 — Non-blocking error. Result accepted. Stderr in verbose mode.
#
# WORKFLOW IMPACT:
#   This hook fires after a subagent completes. The subagent's work is done,
#   but you can prevent the parent agent from accepting the result.
#   - VALIDATE subagent output quality
#   - BLOCK incomplete or failed subagent results
#   - LOG subagent execution time and outcomes
#   - CLEAN UP resources the subagent may have created
# =============================================================================

set -euo pipefail

INPUT=$(cat)

if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
SUCCESS=$(echo "$INPUT" | jq -r '.success // "unknown"')

# --- Your logic here ---

# Example: reject failed subagent results
# if [ "$SUCCESS" = "false" ]; then
#   echo '{"decision": "block", "reason": "Subagent failed — retrying or escalating"}'
# fi

exit 0
