# tmux Configuration Context

> Canonical glossary for this context -- terms, relationships, example dialogue. Product pitch, goals, and constraints live in `product.md`.

## Configuration Model

| Term | Definition | Aliases to avoid |
| --- | --- | --- |
| **tmux entrypoint** | The tmux configuration file that tmux loads first for this repository. | main config, root config |
| **sourced file** | A file loaded by tmux from another tmux configuration file or script. | include, imported config |
| **theme file** | A sourced file that applies tmux visual presentation options. | color file, style file |
| **theme layout** | The shared structure of status bar, pane, message, copy-mode, and clock presentation across themes. | status template, UI layout |
| **theme selection** | The decision that chooses which theme file should be applied to tmux. | theme switching, appearance handling |
| **theme switcher** | The shell script that performs theme selection and applies the selected theme file. | switch script, theme script |
| **active theme selection** | The theme selection currently recorded in tmux state. | current theme, selected mode |
| **manual theme refresh** | A maintainer-triggered request to reapply theme selection regardless of recorded tmux state. | force refresh, theme reload |
| **tmux hook** | A tmux event binding that runs a command when a tmux lifecycle event occurs. | event handler, callback |
| **verification harness** | A small command surface that checks tmux configuration parsing and script syntax. | test script, check script |
| **configuration domain** | A cohesive area of tmux configuration behavior such as keybindings, options, theme hooks, or plugins. | config section, module |

## Refactor Planning

| Term | Definition | Aliases to avoid |
| --- | --- | --- |
| **refactor cycle** | A bounded SDP work cycle that changes internal structure while preserving intended user-facing behavior. | cleanup pass, refactor project |
| **deepened interface** | A smaller boundary where behavior can be verified without depending on incidental implementation details. | better API, abstraction |

## Relationships

- A **tmux entrypoint** may load one or more **sourced file** entries.
- A **theme file** is a kind of **sourced file**.
- A **theme switcher** performs **theme selection**.
- A **theme switcher** may update the **active theme selection**.
- A **manual theme refresh** bypasses the **active theme selection** no-op check.
- A **tmux hook** may invoke the **theme switcher**.
- A **theme file** applies a **theme layout**.
- A **verification harness** checks the **tmux entrypoint**, **theme file** entries, and the **theme switcher**.
- A **refactor cycle** may introduce a **deepened interface** when it improves locality and verification.

## Example dialogue

> **Dev:** "Where should macOS dark mode detection live?" **Domain expert:** "In the **theme switcher**, because **theme selection** is its boundary."

> **Dev:** "Should dark and light status bars duplicate the same format strings?" **Domain expert:** "No, that belongs to the **theme layout** unless the formats intentionally differ."

> **Dev:** "How do I know a tmux change is safe?" **Domain expert:** "Run the **verification harness** so parsing and script syntax are checked together."

> **Dev:** "When should we split `tmux.conf`?" **Domain expert:** "Only when a **configuration domain** becomes easier to understand as a sourced file than as an inline section."

> **Dev:** "Why did focus not source the theme again?" **Domain expert:** "The **active theme selection** already matched, so the **theme switcher** treated the **tmux hook** as a no-op."

## Boundary scenarios

- If macOS appearance changes from light to dark, **theme selection** changes and the **theme switcher** applies the dark **theme file**.
- If a focus **tmux hook** fires while the **active theme selection** still matches macOS appearance, the **theme switcher** performs no source-file work.
- If a maintainer invokes **manual theme refresh**, the **theme switcher** reapplies the selected **theme file** even when the recorded selection matches.

## Flagged ambiguities

- "theme switching" was used to mean both the decision and the script -- resolved: use **theme selection** for the decision and **theme switcher** for the script.
- "main config" was used informally for the first-loaded tmux file -- resolved: use **tmux entrypoint**.
