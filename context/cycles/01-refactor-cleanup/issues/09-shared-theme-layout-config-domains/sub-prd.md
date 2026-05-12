# Parent Issue #9: Shared Theme Layout and Configuration Domain Organization

> Translated to `issue.md`. This sub-PRD records the product-level intent --
> user stories and dependencies. Update `issue.md` for ongoing technical work.
> Update this file only if the underlying user stories themselves change.

## User stories owned

- As a maintainer, I want shared theme layout in one place so I can change the
  status bar without editing both dark and light theme files.
- As a maintainer, I want `tmux.conf` to show clear configuration domains so I
  can find keybindings, options, theme hooks, and plugins quickly.
- As a tmux user, I want the refactor to preserve my current keybindings, pane
  behavior, plugin setup, and automatic theme behavior.

## Encounter statements in scope

- When a maintainer changes a theme layout detail, they encounter one shared
  layout boundary instead of mirrored dark and light format strings.
- When a maintainer opens the tmux entrypoint, they encounter a map of
  configuration domains rather than mixed operational details.

## Directional dependencies

- This parent issue depends on Issue #1 verification harness so structural
  changes can be verified before reload.
- This parent issue depends on Issue #4 idempotent theme selection so theme file
  sourcing and `theme-switcher.sh` call sites are stable before layout
  extraction.
- Cycle closure should follow this parent issue after both remaining PRD goals
  are satisfied.

## Out of scope

- This parent issue does not redesign Solarized visual presentation.
- This parent issue does not change plugin choices, TPM loading, or macOS
  appearance handling.
- This parent issue does not split every section into separate files unless
  locality clearly improves (per PRD non-goal).
