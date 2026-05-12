# 01-refactor-cleanup PRD

## Focus

Improve the tmux configuration's internal structure so theme selection, theme
layout, configuration domains, and verification each have a clear local
boundary.

## Intentions

- Make future theme changes easier to apply without dark and light theme drift.
- Reduce unnecessary theme re-application while preserving automatic macOS
  appearance-aware behavior.
- Keep `tmux.conf` readable as the tmux entrypoint while avoiding premature file
  splitting.
- Establish a lightweight verification habit for this repository.
- Preserve the user-facing tmux workflow unless a change is explicitly called
  out.

## Goals

- Make the theme switcher idempotent so it only reapplies a theme when theme
  selection changes, with an explicit manual theme refresh path.
- Extract shared theme layout from dark and light theme files so duplicated
  status, pane, message, copy-mode, and clock formatting is represented once.
- Add a verification harness that checks tmux parsing and shell script syntax
  with one command.
- Organize configuration domains enough that bindings, options, theme hooks, and
  plugins are easy to locate from the tmux entrypoint.
- Document the resulting boundaries in the cycle closure notes or implementation
  notes before closing the cycle.

## Non-goals

- Do not redesign the visual theme beyond preserving the current Solarized-style
  presentation.
- Do not replace TPM or change plugin choices.
- Do not introduce a large test framework or dependency-heavy tooling.
- Do not manage terminal emulator, shell, editor, or macOS system preferences
  outside tmux integration.
- Do not split every section into separate files unless locality clearly
  improves.

## User stories

- As a maintainer, I want one verification harness so I can check tmux parsing
  and script syntax before reloading my live session.
- As a maintainer, I want shared theme layout in one place so I can change the
  status bar without editing both dark and light theme files.
- As a maintainer, I want theme selection to be idempotent so focus and pane
  tmux hooks do not repeatedly apply the same theme.
- As a maintainer, I want `tmux.conf` to show clear configuration domains so I
  can find keybindings, options, theme hooks, and plugins quickly.
- As a tmux user, I want the refactor to preserve my current keybindings, pane
  behavior, plugin setup, and automatic theme behavior.

## Encounter statements

- When a maintainer changes a theme layout detail, they encounter one shared
  layout boundary instead of mirrored dark and light format strings.
- When a maintainer changes macOS appearance, they encounter automatic theme
  selection that applies the new theme once and records the active selection.
- When a maintainer prepares a change, they encounter a single verification
  command before manually reloading tmux.
- When a maintainer opens the tmux entrypoint, they encounter a map of
  configuration domains rather than mixed operational details.

## Constraints and assumptions

- The installed tmux version is currently `tmux 3.5a`.
- The repository targets a macOS workflow because theme selection depends on
  `osascript` and System Events.
- The current keybindings, base index behavior, copy-mode bindings, terminal
  color support, and TPM loading should remain behaviorally stable.
- Existing `.gitignore` changes are unrelated to this cycle unless explicitly
  included later.
- No ADRs exist yet; if the cycle makes a hard-to-reverse structural decision,
  create an ADR during implementation.

## Success metrics

- One command verifies all tmux configuration files and shell scripts that are
  part of this repository.
- Dark and light theme files no longer duplicate the shared theme layout format
  strings.
- Theme selection can be exercised for dark, light, unchanged, manual theme
  refresh, detection-failure, and failed-apply paths.
- The tmux entrypoint remains short enough to scan and names the configuration
  domains it delegates or contains.
- The refactor preserves current tmux parse success under `tmux source-file -n`.

## Success signals

- A future status bar change requires editing one shared layout boundary.
- Repeated focus or pane lifecycle hooks do not produce repeated theme source
  calls when the selected appearance is unchanged.
- A maintainer can explain which file owns theme selection, which file owns
  theme layout, and which command verifies the repository.
- The implementation can be reviewed as behavior-preserving cleanup rather than
  a feature rewrite.

## Open questions

- RESOLVED IN ISSUE #1: The verification harness command surface is
  `scripts/check` (repository-local, run from workspace root).
- RESOLVED IN ISSUE #9: Keep configuration domains inline in `tmux.conf` with
  clearer sectioning; no selected domains became sourced files.
- RESOLVED IN ISSUE #4: Record active theme selection with tmux option
  `@active_theme_selection`.
- RESOLVED IN ISSUE #4: On appearance detection failure, preserve current theme
  by returning non-zero and performing no `source-file` action.
