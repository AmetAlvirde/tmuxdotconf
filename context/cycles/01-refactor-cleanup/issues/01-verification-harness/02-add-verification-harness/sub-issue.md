# Sub-Issue #2: Add Verification Harness Command

## Description

Add the first vertical slice for Issue #1 by creating a repository-local
verification harness that runs the current tmux parse checks and shell syntax
check without changing live tmux behavior.

## Dependency classification

| Dependency                           | Category      | Testing strategy                                                                                                      |
| ------------------------------------ | ------------- | --------------------------------------------------------------------------------------------------------------------- |
| `tmux` binary                        | Irreplaceable | Use the real dependency in a narrow acceptance check because tmux parsing behavior is the contract being protected.   |
| Shell parser for `theme-switcher.sh` | Irreplaceable | Use the real shell parser in a narrow acceptance check because script parse behavior is the contract being protected. |
| Existing configuration files         | In-process    | Test directly by passing known repository files to the verification harness.                                          |

## Interface design

### Public interface

- Entry point: a repository-local command run from the workspace root.
- Inputs: no required arguments for the first slice.
- Outputs: concise pass/fail output naming each verification step.
- Invariants: the command does not source tmux configuration into a live session
  and does not execute `theme-switcher.sh`.
- Error modes: missing dependency, missing file, tmux parse failure, or shell
  syntax failure should produce non-zero exit status.

### Alternative A: Minimal surface

- Provide `scripts/check` with no arguments.
- Hard-code the current known files: `tmux.conf`, `solarized-dark.conf`,
  `solarized-light.conf`, and `theme-switcher.sh`.
- Run each check explicitly and return non-zero on the first failure.

### Alternative B: Common-caller optimized

- Provide `scripts/check` with optional flags such as `--tmux`, `--shell`, or
  `--all`.
- Discover files by extension and run grouped checks.
- Print a grouped summary after all checks complete.

### Chosen design

Choose Alternative A because the repository is small, the first caller needs one
obvious command, and explicit files maximize locality and testability for the
current cycle.

Reject Alternative B because flags and discovery add behavior that is not yet
justified by the number of files or callers.

## Acceptance criteria

- Running the verification harness from the workspace root checks `tmux.conf`
  with `tmux source-file -n`.
- Running the verification harness from the workspace root checks
  `solarized-dark.conf` and `solarized-light.conf` with `tmux source-file -n`.
- Running the verification harness from the workspace root checks
  `theme-switcher.sh` with shell parse mode.
- The verification harness exits with status `0` when all current checks pass.
- The verification harness exits non-zero if any check fails.
- The verification harness does not execute `theme-switcher.sh` or apply theme
  files to a live tmux session.

## Proposed tests

- Run the verification harness and confirm it succeeds against the current
  repository.
- Run `tmux source-file -n tmux.conf` directly to confirm parity with the
  harness for the tmux entrypoint.
- Run `tmux source-file -n solarized-dark.conf` and
  `tmux source-file -n solarized-light.conf` directly to confirm parity with the
  harness for theme files.
- Run shell parse mode directly against `theme-switcher.sh` to confirm parity
  with the harness for the theme switcher.

## Affected artifacts

- New verification harness command, likely `scripts/check`.
- `context/cycles/01-refactor-cleanup/issues/01-verification-harness/issue.md`
  if flags are resolved during implementation.
- No intended changes to `tmux.conf`, theme files, or `theme-switcher.sh` in
  this sub-issue.

## Dependencies

- Parent Issue #1: Establish Verification Harness.
- Current repository paths for the tmux entrypoint, theme files, and theme
  switcher.
- Installed `tmux` compatible with `tmux source-file -n`.
