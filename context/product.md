# tmux Configuration

## Elevator Pitch

This repository provides a compact, reliable tmux configuration for a macOS-based development workflow that keeps terminal behavior, navigation, and theme presentation predictable across sessions.

## Intentions

- Keep day-to-day tmux behavior easy to understand from the repository.
- Preserve fast reload and verification feedback for configuration changes.
- Make theme behavior reliable without making the main tmux configuration harder to scan.
- Prefer small, explicit files over framework-like abstractions.

## Goals

- Maintain a working tmux entrypoint that can be loaded directly by tmux.
- Keep macOS appearance-aware theme selection understandable and testable.
- Keep shared theme layout choices local so dark and light themes do not drift.
- Provide a simple verification harness for future changes.

## Access Surface

- `tmux.conf` is the user-facing entrypoint loaded by tmux.
- `theme-switcher.sh` is the operational boundary for macOS appearance-aware theme selection.
- Theme files define theme layout applied to tmux sessions.

## Work Boundaries

- This repository configures tmux; it does not manage shell, editor, terminal emulator, or system-wide macOS settings.
- Plugin installation remains delegated to TPM.
- Theme selection can observe macOS appearance, but it should not attempt to control macOS appearance.

## Generative Core

The configuration should make tmux comfortable for development by combining predictable keybindings, pane/window behavior, and automatic theme presentation in a small set of files that can be checked quickly.

## Coherence Signals

- A maintainer can identify where keybindings, theme selection, and theme layout live without reading every file.
- Theme selection does not repeatedly re-apply work when the selected appearance has not changed.
- Dark and light themes share the same status layout unless a deliberate visual difference is documented in the theme definitions.
- A single verification command can catch parsing and shell syntax regressions.

## Constraints

- Keep the configuration compatible with the installed tmux version unless a future cycle changes the target.
- Keep shell scripts portable enough for the repository's macOS workflow.
- Avoid adding heavy tooling for a small dotfiles repository.
