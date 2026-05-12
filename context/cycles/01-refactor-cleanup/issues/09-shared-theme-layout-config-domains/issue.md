# Issue #9: Extract Shared Theme Layout and Organize Configuration Domains

## Acceptance criteria

- Dark and light theme files no longer duplicate shared formatting strings for
  status bar, pane borders, messages, window modes, copy mode, and clock mode.
- Shared theme layout is represented in a single location that both dark and
  light theme files can reference.
- The PRD open question on configuration domain organization is resolved and
  recorded in the cycle closure notes or an ADR.
- `tmux.conf` clearly separates each configuration domain so bindings, options,
  theme hooks, and plugins are easy to locate from the tmux entrypoint.
- `scripts/check` passes against the full configuration including the new shared
  layout file.
- Current visual presentation is preserved so no user-facing tmux behavior
  changes.

## Implementation approach

- Create one shared theme layout file containing the status bar, pane border,
  message, copy-mode, and clock formatting strings that are currently duplicated
  in `solarized-dark.conf` and `solarized-light.conf`.
- Strip duplicated formatting from both theme files, keeping only color
  definitions and the dark/light-specific values (primary background,
  foreground, and accent color assignments).
- Source the shared layout file from each theme file via `tmux source-file` so
  each theme file remains the single `run-shell` call target from
  `theme-switcher.sh`.
- For configuration domain organization, resolve the PRD open question through
  implementation by evaluating the current file size and domain count against
  the PRD non-goal: "Do not split every section into separate files unless
  locality clearly improves." Prefer inline sectioning with clear visual
  markers. If a domain is extracted to a sourced file, create an ADR.
- Use `scripts/check` as the verification surface throughout iteration.
- Record the domain organization decision in the cycle closure notes or an ADR.

## Dependencies

- Depends on Issue #1 verification harness (`scripts/check`).
- Depends on Issue #4 idempotent theme selection so theme files and
  `theme-switcher.sh` call sites are stable.
- Depends on `solarized-dark.conf` and `solarized-light.conf` at current paths.
- Depends on `tmux.conf` at current path.
- `tmux source-file` and `run-shell` behavior must be preserved.

## Flags

- OPEN: Should the shared theme layout file be named `solarized-shared.conf`,
  `theme-shared.conf`, `solarized-base.conf`, or another name?
- OPEN: Should `tmux.conf` configuration domains remain inline with clearer
  section headers, or should selected domains (bindings, options, theme hooks,
  plugins) become separately sourced files? Resolve through implementation.
- OPEN: If any domain is extracted to a sourced file, should an ADR be created
  to record the decision?
