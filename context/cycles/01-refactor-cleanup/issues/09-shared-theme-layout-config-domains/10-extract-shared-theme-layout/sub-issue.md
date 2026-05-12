# Sub-Issue #10: Extract Shared Theme Layout

## Description

Extract the duplicated Solarized theme layout from `solarized-dark.conf` and
`solarized-light.conf` into one shared theme layout sourced by both theme files.
Keep each theme file responsible for color values and dark/light-specific role
assignments, while preserving the current tmux visual presentation.

This vertical slice owns the shared theme layout boundary only. Configuration
domain organization in `tmux.conf` remains a later sibling slice because it must
resolve a separate domain-organization flag.

## Dependency classification

| Dependency                                       | Classification | Testing strategy                                          |
| ------------------------------------------------ | -------------- | --------------------------------------------------------- |
| `tmux source-file` parse behavior                | Irreplaceable  | Use `scripts/check` and direct parse checks through tmux. |
| `solarized-dark.conf` and `solarized-light.conf` | In-process     | Verify through repository files and tmux parse checks.    |
| New shared theme layout file                     | In-process     | Verify both theme files source it and parse successfully. |
| `theme-switcher.sh` theme file call sites        | In-process     | Keep paths unchanged and run existing behavior checks.    |

## Interface design

### Entry points

- `solarized-dark.conf` remains the dark theme file applied by the theme
  switcher.
- `solarized-light.conf` remains the light theme file applied by the theme
  switcher.
- A new sourced file owns shared status bar, pane border, message, copy-mode,
  and clock-mode layout commands.

### Inputs

- Theme role variables assigned by each theme file before sourcing the shared
  layout, including background, foreground, muted foreground, accent, active
  background, and active foreground roles.

### Outputs

- The same tmux options currently set by each theme file for status, pane
  borders, display panes, messages, mode style, and clock mode.

### Invariants

- `theme-switcher.sh` continues to source only `solarized-dark.conf` or
  `solarized-light.conf`; it does not need to know about the shared layout file.
- The shared theme layout file contains no dark/light branch logic.
- Dark and light theme files preserve their current visual values after role
  substitution.
- `scripts/check` includes the full configuration path and passes after the
  extraction.

### Error modes

- If a theme file fails to source the shared layout file, tmux parsing should
  fail before live reload.
- If a required role variable is missing, tmux may apply an empty or invalid
  style value; keep role assignments adjacent to the source command to make this
  visible during review.

## Design it twice

### Alternative A: Minimal sourced layout file

Create `solarized-shared.conf` with the duplicated `set -g` layout commands.
Each theme file assigns role variables to its current color values, then sources
`solarized-shared.conf`.

- Leverage: High, because future layout changes happen in one file.
- Locality: High, because theme-specific colors stay in theme files and shared
  layout stays in one boundary.
- Testability: High, because existing tmux parse checks exercise both theme
  entry points.

### Alternative B: Shared role file plus theme files

Create a shared file that defines all Solarized palette values and another file
that defines layout commands. Theme files would only assign role variables and
source both shared files.

- Leverage: Medium, because palette duplication also disappears.
- Locality: Lower, because one visual change may require understanding three
  files instead of two.
- Testability: Medium, because the additional sourced file expands the parse
  path without adding a necessary seam for this issue.

### Chosen design

Choose Alternative A. It satisfies the PRD goal of removing duplicated theme
layout while keeping palette ownership and theme switcher behavior local to the
existing theme files.

Reject Alternative B because palette extraction is not required by the current
acceptance criteria and would add another sourced file before locality clearly
improves.

## Acceptance criteria

- A shared theme layout file exists and is sourced by both `solarized-dark.conf`
  and `solarized-light.conf`.
- Shared status bar, pane border, display pane, message, copy-mode, and clock
  layout commands are removed from duplicated dark/light definitions.
- Dark and light theme files keep the same externally sourced paths used by
  `theme-switcher.sh`.
- Current dark and light visual role values are preserved after extraction.
- `scripts/check` passes.

## Proposed tests

- Run `scripts/check`.
- Run `tmux source-file -n solarized-dark.conf`.
- Run `tmux source-file -n solarized-light.conf`.
- Review the diff to confirm duplicated layout commands moved to one shared
  boundary and `theme-switcher.sh` did not need a call-site change.

## Affected artifacts

- `solarized-dark.conf`
- `solarized-light.conf`
- New shared theme layout file, expected name: `solarized-shared.conf`
- `scripts/check`, only if it must explicitly require or parse the shared layout
  file after implementation

## Dependencies

- Parent Issue #9.
- Issue #1 verification harness (`scripts/check`).
- Issue #4 idempotent theme selection, already closed.
