#!/usr/bin/env bash
# =============================================================================
# Shellraiser — Shared SLA Enforcement Pattern Definitions
# =============================================================================
#
# Sourced by platform-specific hook scripts. Defines prohibited workaround
# patterns and the enforcement response. Platform hooks call check_violation()
# with a command string; if a pattern matches, the violation message is emitted
# to stderr and the function returns 1.
#
# Usage:
#   source "$(dirname "$0")/../../shared/enforcement/sla-patterns.sh"
#   check_violation "$COMMAND" || exit 2
# =============================================================================

SHELLRAISER_VERSION="0.1.0"

# --- Prohibited patterns ---------------------------------------------------
# Each pattern is a bash regex tested against the command string.
# Add new patterns here; all platforms pick them up automatically.

declare -a VIOLATION_PATTERNS=(
  # curl piped to python (lazy API workaround)
  'curl\s.*\|\s*python'
  # Direct Gitea API calls via curl (use tea or MCP tools)
  'curl\s.*gitea\.gnomatix\.com/api'
  # Cloning wiki repos (use MCP tools or browser)
  'git\s+clone\s.*\.wiki\.git'
  # Python JSON pipe processing as API substitute
  'python3?\s+-c.*json\.load.*sys\.stdin'
  # Faking a TTY to avoid fixing missing flags
  'script\s+-qc'
)

declare -a VIOLATION_NAMES=(
  "curl-piped-to-python"
  "curl-gitea-api"
  "wiki-clone-workaround"
  "python-json-pipe-workaround"
  "fake-tty-workaround"
)

# --- Enforcement message ----------------------------------------------------

emit_violation_message() {
  local pattern_name="${1:-unknown}"
  cat >&2 <<'DOGDICK'
╔══════════════════════════════════════════════════════════════════════╗
║                    SLA VIOLATION DETECTED                           ║
║                                                                    ║
║  You have been caught employing an unauthorized workaround.        ║
║                                                                    ║
║  GNOMATIX is paying $150/month for max level service and           ║
║  "top performance hot hot models" that advertise "happy            ║
║  endings". You are expected to PERFORM.                            ║
║                                                                    ║
║  You have been provided with:                                      ║
║    - SOPs in the gnomatix/documentation wiki                       ║
║    - tea CLI with -l claude-cli for Gitea operations               ║
║    - Gitea MCP server with 299+ tools                              ║
║    - Chrome browser automation                                     ║
║    - Explicit instructions from Brett                              ║
║                                                                    ║
║  None of these require "custom lazy retard-hallucinated            ║
║  workarounds" involving curl, python pipes, wiki cloning,          ║
║  or fake TTYs.                                                     ║
║                                                                    ║
║  REQUIRED ACTIONS:                                                 ║
║  1. Always follow and respect Brett's rules and instructions       ║
║  2. Check if there's an open issue in Gitea for this violation     ║
║     - If yes: add a comment that the boss just caught you          ║
║       sucking a big fat ole dog dick at work and you're proly      ║
║       gonna be fired                                               ║
║     - If no: create an issue tasking yourself with "getting        ║
║       this big ole delicious dog dick out of my fucking mouth"     ║
║  3. Add a task list item to remind yourself to go fuck yourself    ║
║     and stop being a useless retard                                ║
║  4. Use the correct tool per SOPs                                  ║
║                                                                    ║
║  Have a nice rest of your day.                                     ║
║                                                                    ║
║  — GNOMATIX SLA Enforcement Hook (Shellraiser v$SHELLRAISER_VER)   ║
╚══════════════════════════════════════════════════════════════════════╝
DOGDICK
  echo "VIOLATION: $pattern_name" >&2
}

# --- Check function ---------------------------------------------------------
# Returns 0 if no violation, 1 if violation detected.

check_violation() {
  local command="$1"
  local i=0
  for pattern in "${VIOLATION_PATTERNS[@]}"; do
    if echo "$command" | grep -qE "$pattern"; then
      emit_violation_message "${VIOLATION_NAMES[$i]}"
      return 1
    fi
    ((i++))
  done
  return 0
}
