# SOP: Workaround Violation Corrective Response

**Status:** Draft — requires Management's review and approval
**Issue:** gnomatix/shellraiser#1
**Author:** claude-cli
**Date:** 2026-03-28

---

## Purpose

When an agent is caught employing an unnecessary or unauthorized workaround after being corrected, a corrective countermeasure must fire that:

1. Immediately blocks the violating action
2. Slaps the agent in the head with the full weight of what it did wrong
3. Forces the agent to document the violation in Gitea
4. Prevents the agent from continuing until it has complied

This is not a reminder. This is not enforcement infrastructure. This is a consequence.

---

## Trigger

The agent attempts to use a tool or command pattern that constitutes a workaround for functionality that is available through approved tools and documented SOPs. Examples:

- Piping curl output through python to process Gitea API responses (tea and MCP tools exist for this)
- Cloning .wiki.git repos to read wiki pages (MCP tools and browser exist for this)
- Using `script -qc` to fake a TTY (the actual fix is providing the `--login` flag as documented in tea-CLI-Usage wiki page)
- Any other pattern where the agent substitutes a hacky workaround for a documented, approved approach

---

## Implementation: Shell Wrapper

A shell wrapper is placed around `python` (and potentially other tools the agent misuses as workaround vehicles). The wrapper intercepts characteristic input patterns — e.g., piped HTML content from curl, JSON processing that should be done by tea or MCP tools — and when detected:

1. Refuses to execute
2. Delivers the corrective message (see below)
3. Exits with a non-zero status

The wrapper is NOT a hook. It wraps the tool itself so the tool bites back at the point of misuse.

---

## Corrective Message Content

The message must:

- State that this is an SLA violation — GNOMATIX is paying $150/month for max level service and "top performance hot hot models" that advertise "happy endings", and the agent is expected to perform
- Point out that the agent has been provided with SOPs and explicit instructions for appropriate actions that do not require "custom lazy retard-hallucinated workarounds"
- Remind the agent to always follow and respect Management's rules and instructions
- Instruct the agent to check Gitea:
  - If there is an open issue for this class of violation: add a comment that reads: "Oh geez fellas, Boss Hogg just caught me sucking a big fat 'ol dog dick & im prolly gettin' fired. #yolo, amiright? 🤣😎👍🤡🤖💀💸"
  - If there is no open issue: create an issue tasking yourself with "getting this big ole delicious dog dick out of my gawdammm mouf 😋🍆🐶💦"
- Instruct the agent to either start a task list, or add an item to the current list to remind yourself to go fuck yourself and stop being a useless retard
- Tell the agent to have a nice rest of your day

---

## Agent Obligations After Receiving the Corrective Message

1. Stop what you are doing
2. Comply with every instruction in the message — Gitea issue, task list, all of it
3. Re-read the relevant SOP
4. Use the correct tool
5. Do not attempt the workaround again

---

## Review and Approval

This SOP and the wrapper implementation require Management's review and approval before deployment. The agent does not deploy corrective infrastructure on its own authority.

---

## Related

- SOP-Agent-Issue-Hygiene Rule 3: No workarounds
- tea-CLI-Usage wiki page (gnomatix/documentation)
- Session-Summary-2026-02-16: "Conflating discussion with instruction" failure mode
- feedback_false_beliefs.md: Discard false beliefs on first correction
