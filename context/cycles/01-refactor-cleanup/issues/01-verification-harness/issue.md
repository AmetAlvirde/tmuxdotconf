# Issue #1: Establish Verification Harness

## Acceptance criteria

- A maintainer can run one repository-local verification harness from the
  workspace root.
- The verification harness performs tmux parse checks for the tmux entrypoint
  and existing theme files.
- The verification harness performs a shell syntax check for the theme switcher.
- The verification harness exits non-zero when a checked command fails.
- The verification harness output is concise enough to use before manually
  reloading tmux.
- No user-facing tmux behavior changes as part of this parent issue.

## Implementation approach

- Add the smallest repository-local command surface that can be run directly
  from the workspace root.
- Prefer explicit checks for the current known artifacts over discovery logic
  that could hide accidental files or pull in ignored directories.
- Use real `tmux source-file -n` for tmux parse checks because tmux
  configuration parsing is the behavior being protected.
- Use real shell parse mode for the theme switcher because the current script is
  shell-based and has no separate runtime contract yet.
- Keep the command dependency-light and compatible with the existing macOS
  workflow.

## Dependencies

- Depends on the current tmux entrypoint, theme files, and theme switcher
  existing at their current paths.
- Requires `tmux` to be installed for the tmux parse check.
- Requires a shell capable of parsing `theme-switcher.sh`.
- Later parent issues depend on this verification harness as their safety check.

## Flags

- RESOLVED IN SUB-ISSUE #2: The verification harness path is `scripts/check`
  as the repository-local command surface.
- RESOLVED IN SUB-ISSUE #2: The harness checks only current known files
  (`tmux.conf`, `solarized-dark.conf`, `solarized-light.conf`, and
  `theme-switcher.sh`) with explicit commands.
