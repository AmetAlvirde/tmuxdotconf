# Parent Issue #1: Verification Harness

> Translated to `issue.md`. This sub-PRD records the product-level intent --
> user stories and dependencies. Update `issue.md` for ongoing technical work.
> Update this file only if the underlying user stories themselves change.

## User stories owned

- As a maintainer, I want one verification harness so I can check tmux parsing
  and script syntax before reloading my live session.
- As a tmux user, I want the refactor to preserve my current keybindings, pane
  behavior, plugin setup, and automatic theme behavior.

## Encounter statements in scope

- When a maintainer prepares a change, they encounter a single verification
  command before manually reloading tmux.

## Directional dependencies

- This parent issue should land before theme selection changes, shared theme
  layout extraction, and configuration domain organization so those later
  changes can rely on a stable verification harness.
- Later parent issues should expand or reuse this verification harness instead
  of adding separate ad hoc checks.

## Out of scope

- This parent issue does not change tmux behavior, visual theme design, plugin
  choices, or macOS appearance handling.
- This parent issue does not add dependency-heavy tooling or a broad test
  framework.
