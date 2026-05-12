# Parent Issue #4: Theme Selection Idempotence

> Translated to `issue.md`. This sub-PRD records the product-level intent --
> user stories and dependencies. Update `issue.md` for ongoing technical work.
> Update this file only if the underlying user stories themselves change.

## User stories owned

- As a maintainer, I want theme selection to be idempotent so focus and pane
  tmux hooks do not repeatedly apply the same theme.
- As a maintainer, I want an explicit manual theme refresh path so I can
  reapply the selected theme on demand.
- As a tmux user, I want this refactor to preserve current keybindings, pane
  behavior, plugin setup, and automatic theme behavior.

## Encounter statements in scope

- When a maintainer changes macOS appearance, they encounter automatic theme
  selection that applies the new theme once and records the active theme
  selection.
- When a focus or pane lifecycle tmux hook fires while selection is unchanged,
  they encounter a no-op.
- When a maintainer requests manual theme refresh, they encounter a forced
  reapply even when selection is unchanged.

## Directional dependencies

- This parent issue depends on Issue #1 verification harness so theme-switcher
  changes can be checked quickly before reload.
- Shared theme layout extraction should follow this issue so behavior and
  structure changes stay separated.
- Configuration domain organization should follow this issue so tmux hook and
  theme switcher ownership are stabilized first.

## Out of scope

- This parent issue does not redesign Solarized visual presentation.
- This parent issue does not change plugin choices or introduce heavy tooling.
