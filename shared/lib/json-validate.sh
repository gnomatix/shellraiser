#!/usr/bin/env bash
# =============================================================================
# Shellraiser — Shared JSON Input Validation
# =============================================================================
#
# Common functions for reading and validating JSON input from stdin,
# used by all platform hook scripts.
#
# Usage:
#   source "$(dirname "$0")/../../shared/lib/json-validate.sh"
#   INPUT=$(read_json_input) || exit 1
#   FIELD=$(json_field "$INPUT" '.field_name')
# =============================================================================

# Read JSON from stdin, validate, return it. Exits 1 on invalid JSON.
read_json_input() {
  local input
  input=$(cat)
  if ! echo "$input" | jq empty 2>/dev/null; then
    echo "ERROR: Invalid JSON input" >&2
    return 1
  fi
  echo "$input"
}

# Extract a field from JSON. Returns "unknown" if field is missing.
json_field() {
  local json="$1"
  local path="$2"
  local default="${3:-unknown}"
  echo "$json" | jq -r "$path // \"$default\""
}

# Extract a field as compact JSON object.
json_object() {
  local json="$1"
  local path="$2"
  echo "$json" | jq -c "$path // {}"
}
