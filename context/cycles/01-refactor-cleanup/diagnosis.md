# Refactor Diagnosis

## Current Shape

- `tmux.conf` owns reload behavior, prefix/mouse/index settings, bindings, terminal capabilities, theme hooks, copy-mode behavior, and TPM initialization.
- `theme-switcher.sh` detects macOS appearance with `osascript` and sources either the dark or light theme file.
- `solarized-dark.conf` and `solarized-light.conf` duplicate the palette and most layout commands while varying a small set of semantic color choices.
- There is no existing SDP context folder, ADR history, or verification harness.

## Candidate 1: Idempotent Theme Selection

Affected artifacts: `tmux.conf`, `theme-switcher.sh`

Concrete friction: the theme switcher runs on startup, pane/window lifecycle tmux hooks, client focus, and manual theme refresh, but most events do not mean the selected appearance changed.

Proposed change: make the theme switcher compare detected appearance against an active tmux option and source a theme only when the selection changes or manual theme refresh forces it.

Expected gain: theme behavior becomes local, repeated hook work is reduced, and failure handling becomes explicit.

Test improvement: mock `osascript` and `tmux` to cover dark, light, unchanged, manual theme refresh, and detection-failure paths.

## Candidate 2: Shared Theme Layout

Affected artifacts: `solarized-dark.conf`, `solarized-light.conf`, possible shared theme layout file

Concrete friction: both theme files duplicate status bar, window status, pane border, message, mode, and clock commands.

Proposed change: keep dark and light theme files focused on semantic theme values, then source a shared layout file that applies those values.

Expected gain: future visual changes become one-location edits and dark/light drift becomes less likely.

Test improvement: parse every theme file and verify both themes apply the same option set.

## Candidate 3: Verification Harness

Affected artifacts: new repository-local check command

Concrete friction: verification is currently ad hoc even though tmux and shell parsing can be checked cheaply.

Proposed change: add one command that runs `tmux source-file -n` for tmux configuration files and shell syntax checks for scripts.

Expected gain: future behavior-preserving refactors have a fast safety net.

Test improvement: the harness becomes the first deepened verification interface for the repository.

## Candidate 4: Configuration Domain Organization

Affected artifacts: `tmux.conf`, possible sourced files if implementation proves the split improves locality

Concrete friction: `tmux.conf` mixes several configuration domains, though it is still small enough that over-splitting would add noise.

Proposed change: clarify domains in the tmux entrypoint and split only the domains where locality clearly improves.

Expected gain: maintainers can find behavior without bouncing through incidental sections or premature modules.

Test improvement: parse the tmux entrypoint and any sourced files independently.

## Recommended Single Cycle

Treat all four candidates as one cleanup cycle, but sequence implementation so verification lands early, theme selection and layout are deepened next, and broader configuration splitting happens only where the deletion test passes.
