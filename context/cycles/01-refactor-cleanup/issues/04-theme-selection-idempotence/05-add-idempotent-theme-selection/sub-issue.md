# Sub-Issue #5: Add Idempotent Theme Selection Guard

## Description

Add the first vertical slice for Issue #4 by making `theme-switcher.sh`
idempotent: reapply a theme only when theme selection changes, with an explicit
manual refresh override.

## Dependency classification

| Dependency                                         | Category            | Testing strategy                                                                                                                                              |
| -------------------------------------------------- | ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `tmux` command surface used by `theme-switcher.sh` | Local-substitutable | Use a local stub in behavior tests to verify control flow and source-file calls; keep one narrow real-tmux acceptance check through normal repo verification. |
| `osascript` appearance detection                   | Local-substitutable | Use a local stub in tests to model dark, light, and detection-failure paths.                                                                                  |
| `theme-switcher.sh`                                | In-process          | Test directly through script entrypoint behavior.                                                                                                             |
| `tmux.conf` hook and manual-refresh call sites     | In-process          | Verify the call sites still invoke the script and manual refresh sends the force signal.                                                                      |
| `scripts/check` verification harness               | In-process          | Run as acceptance safety check after implementation.                                                                                                          |

## Interface design

### Public interface

- Entry point: `theme-switcher.sh` invoked from `tmux.conf` hooks and manual
  refresh binding.
- Inputs: no required CLI args; optional force signal from caller for manual
  refresh.
- Outputs: silent success on no-op or apply; concise stderr on detection
  failure.
- Invariants: no duplicate source-file call when selected theme equals active
  theme selection unless force signal is present.
- Error modes: detection failure returns non-zero and performs no source-file
  action.

### Alternative A: Minimal surface

- Keep script invocation shape unchanged for hooks.
- Add one force signal for manual refresh via environment variable
  (`TMUX_THEME_FORCE=1`).
- Record active theme selection in tmux option `@active_theme_selection`.
- Skip `tmux source-file` when selected and active theme selections match and
  force signal is absent.

### Alternative B: Common-caller optimized

- Add script flags such as `--force` and `--print-selection`.
- Add explicit subcommands for detect/apply/update-state.
- Update all tmux hook call sites to pass flags.

### Chosen design

Choose Alternative A because it adds the smallest behavior-focused seam with
high locality and keeps existing hook call sites stable.

Reject Alternative B because additional flags and subcommands increase surface
area before there are multiple callers that need that flexibility.

## Acceptance criteria

- With a dark selection and mismatched active theme selection, the script
  sources `solarized-dark.conf` and records `@active_theme_selection` as dark.
- With a light selection and mismatched active theme selection, the script
  sources `solarized-light.conf` and records `@active_theme_selection` as light.
- With unchanged selection and no force signal, the script exits success without
  issuing `tmux source-file`.
- With unchanged selection and force signal, the script reapplies the selected
  theme file.
- On appearance detection failure, the script returns non-zero and does not
  source a theme file.
- `tmux.conf` manual refresh binding invokes the force path.

## Proposed tests

- Add behavior tests for dark, light, unchanged, forced refresh, and detection
  failure paths using local stubs for `tmux` and `osascript`.
- Verify that unchanged selection path emits no `source-file` command in the
  tmux stub log.
- Verify that forced refresh path emits exactly one `source-file` command for
  the selected theme.
- Run `scripts/check` after changes.

## Affected artifacts

- `theme-switcher.sh`
- `tmux.conf` (manual refresh call site only, if force signal wiring is needed)
- `context/cycles/01-refactor-cleanup/issues/04-theme-selection-idempotence/issue.md`
  if flags are resolved during implementation

## Dependencies

- Parent Issue #4: Make Theme Selection Idempotent.
- Existing hook and manual refresh call sites in `tmux.conf`.
- Existing theme files at current repository paths.
- Existing verification harness `scripts/check`.
