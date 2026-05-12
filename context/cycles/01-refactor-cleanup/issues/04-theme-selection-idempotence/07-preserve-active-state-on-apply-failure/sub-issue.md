# Sub-Issue #7: Preserve Active Theme State on Apply Failure

## Description

Tighten the idempotent theme selection behavior from Issue #4 so the theme
switcher records `@active_theme_selection` only after the selected theme file is
successfully applied. A failed `tmux source-file` must not make later hook runs
believe the selected theme is already active.

## Dependency classification

| Dependency                                         | Category            | Testing strategy                                                                                                           |
| -------------------------------------------------- | ------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `theme-switcher.sh`                                | In-process          | Test directly through the script entrypoint behavior.                                                                      |
| `tmux` command surface used by `theme-switcher.sh` | Local-substitutable | Use a local stub in behavior tests to simulate successful and failed `source-file` calls and verify state update ordering. |
| `osascript` appearance detection                   | Local-substitutable | Use a local stub in tests to keep theme selection deterministic while exercising apply success and failure paths.          |
| `scripts/test-theme-switcher-behavior`             | In-process          | Extend the existing behavior coverage rather than adding a second test surface.                                            |
| `scripts/check` verification harness               | In-process          | Run as the acceptance safety check after implementation.                                                                   |

## Interface design

### Public interface

- Entry point: `theme-switcher.sh`, invoked from existing `tmux.conf` hook and
  manual refresh call sites.
- Inputs: existing macOS appearance result from `osascript`; existing optional
  `TMUX_THEME_FORCE=1` manual refresh signal.
- Outputs: success after no-op or successful apply; non-zero when appearance
  detection fails or selected theme application fails.
- Invariants: `@active_theme_selection` reflects the last theme file that the
  switcher successfully applied, not merely the last theme selection attempted.
- Error modes: failed `tmux source-file` returns non-zero and performs no
  `@active_theme_selection` update.

### Alternative A: Minimal explicit status handling

- Keep the current command surface and call sites unchanged.
- Check the status of `tmux source-file` before running `tmux set-option`.
- Return the failed `source-file` status to the caller.
- Preserve the existing no-op guard and manual refresh behavior.

### Alternative B: Broad shell fail-fast mode

- Enable broad shell fail-fast behavior such as `set -e`.
- Rely on the shell to stop before `tmux set-option` when `tmux source-file`
  fails.
- Audit every existing command substitution and conditional command in the
  script for `set -e` compatibility.

### Chosen design

Choose Alternative A because it is local to the apply-and-record sequence and
does not widen shell error semantics for unrelated detection and no-op paths.

Reject Alternative B because broad fail-fast behavior is a larger script policy
change than this slice needs and can make future control-flow edits surprising.

## Acceptance criteria

- When selected theme application succeeds, the script records
  `@active_theme_selection` with the selected theme value.
- When `tmux source-file` fails, the script returns non-zero.
- When `tmux source-file` fails, the script does not run
  `tmux set-option -gq @active_theme_selection ...`.
- Existing dark, light, unchanged no-op, forced refresh, and appearance
  detection-failure behaviors continue to pass.

## Proposed tests

- Extend `scripts/test-theme-switcher-behavior` with a local `tmux` stub that
  fails `source-file` and records every attempted tmux command.
- Assert the failed apply path returns non-zero.
- Assert the failed apply path logs the `source-file` attempt but no
  `set-option -gq @active_theme_selection` update.
- Run `scripts/check` after changes.

## Affected artifacts

- `theme-switcher.sh`
- `scripts/test-theme-switcher-behavior`
- `context/cycles/01-refactor-cleanup/issues/04-theme-selection-idempotence/issue.md`
  if implementation exposes a new parent-level flag or resolved behavior note

## Dependencies

- Parent Issue #4: Make Theme Selection Idempotent.
- Existing idempotence behavior from Sub-Issue #5.
- Existing `scripts/check` verification harness.
- Existing `tmux.conf` hook and manual refresh call sites.
