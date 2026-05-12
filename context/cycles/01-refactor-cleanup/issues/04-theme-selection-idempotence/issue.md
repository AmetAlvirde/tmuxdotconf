# Issue #4: Make Theme Selection Idempotent

## Acceptance criteria

- Running the theme switcher applies the selected theme file when macOS
  appearance implies a different theme selection than the active theme
  selection recorded in tmux state.
- Running the theme switcher does not reapply a theme file when selected theme
  and active theme selection already match.
- A manual theme refresh path can force theme reapplication even when selected
  theme and active theme selection already match.
- After applying a theme, tmux state records the active theme selection using a
  stable tmux option name.
- If appearance detection fails, theme switcher preserves current theme behavior
  by skipping reapply and returning non-zero.
- Existing theme hooks and manual keybinding continue to function for users.

## Implementation approach

- Keep the existing command surface at `theme-switcher.sh` and introduce the
  smallest state check needed for idempotence.
- Record active theme selection in one tmux user option and compare it before
  calling `tmux source-file`.
- Add one explicit manual-refresh signal from tmux config to bypass the no-op
  guard.
- Preserve current macOS-driven dark/light selection contract.
- Use `scripts/check` as the default verification path while iterating.

## Dependencies

- Depends on Issue #1 verification harness (`scripts/check`).
- Depends on `tmux.conf` hooks and manual keybinding invoking the theme
  switcher.
- Depends on `theme-switcher.sh`, `solarized-dark.conf`, and
  `solarized-light.conf` at current paths.
- Depends on macOS appearance detection via `osascript`.

## Flags

- RESOLVED: Use tmux option name `@active_theme_selection` for recorded active
  theme selection.
- RESOLVED: On appearance detection failure, preserve the current theme by
  performing no source-file action and returning non-zero.
