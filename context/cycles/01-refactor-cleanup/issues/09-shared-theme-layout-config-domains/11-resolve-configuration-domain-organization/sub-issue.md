# Sub-Issue #11: Resolve Configuration Domain Organization

## Description

Resolve the remaining Issue #9 flag on how `tmux.conf` should organize
configuration domains now that shared theme layout extraction is complete.
Decide whether domains remain inline with clearer sectioning or selected domains
move to sourced files, then apply the chosen structure while preserving current
tmux behavior.

This vertical slice owns the domain-organization decision boundary and its
implementation in `tmux.conf`. Shared theme layout extraction is already handled
by Sub-Issue #10.

## Dependency classification

| Dependency                                      | Category      | Testing strategy                                                                                 |
| ----------------------------------------------- | ------------- | ------------------------------------------------------------------------------------------------ |
| `tmux.conf` entrypoint and current domain order | In-process    | Refactor directly in-file and verify all existing behavior-preserving constraints.               |
| `tmux source-file -n` parse behavior            | Irreplaceable | Use real tmux parse checks through `scripts/check` and direct parse verification for entrypoint. |
| Existing sourced files and hooks                | In-process    | Keep current source/hook call sites stable unless explicitly moved by the chosen design.         |
| Decision-recording location (ADR or closure)    | In-process    | Record the final decision in the cycle artifact required by parent issue acceptance.             |

## Interface design

### Public interface

- Entry point: `tmux.conf` loaded via existing tmux startup and reload flows.
- Inputs: existing tmux commands for options, bindings, hooks, and plugin setup.
- Outputs: unchanged effective runtime behavior with clearer domain locality for
  maintainers.
- Invariants: no user-facing keybinding, pane behavior, plugin setup, or theme
  hook behavior changes.
- Error modes: invalid ordering or malformed extracted source paths may break
  parse/load; all structural changes must remain covered by parse checks.

### Alternative A: Keep domains inline with stronger section markers

- Keep `tmux.conf` as the single entrypoint file.
- Reorder and annotate sections so bindings, options, theme hooks, and plugins
  are visually isolated and easy to scan.
- Avoid introducing new sourced files unless locality is clearly improved.

### Alternative B: Extract selected domains into sourced files

- Keep `tmux.conf` as orchestrator only.
- Split one or more domains (for example bindings or plugin setup) into
  dedicated sourced files and keep domain boundaries explicit in `tmux.conf`.
- Introduce additional source paths and verify load order requirements.

### Chosen design

Choose Alternative A by default unless implementation reveals a concrete domain
whose locality clearly improves only through extraction.

Reject Alternative B as the default because additional source boundaries
increase navigation and ordering complexity without guaranteed leverage at
current configuration size.

If implementation adopts Alternative B for any domain, record the decision in an
ADR and update parent issue flags accordingly.

## Acceptance criteria

- `tmux.conf` clearly separates configuration domains so bindings, options,
  theme hooks, and plugins are easy to locate from the entrypoint.
- Effective tmux behavior is preserved: no intentional user-facing changes to
  keybindings, pane behavior, plugin setup, or automatic theme behavior.
- `scripts/check` passes against the final structure.
- The Issue #9 configuration-domain organization flag is resolved and recorded
  in the required cycle artifact.
- If any domain is extracted to a sourced file, an ADR is created and referenced
  from Issue #9 notes.

## Proposed tests

- Run `scripts/check`.
- Run `tmux source-file -n tmux.conf` directly after reorganization.
- Diff-review `tmux.conf` (and any newly sourced domain file, if introduced) to
  confirm structural/locality changes without behavior changes.
- Validate that existing theme hook and plugin initialization order is
  preserved.

## Affected artifacts

- `tmux.conf`
- `context/cycles/01-refactor-cleanup/issues/09-shared-theme-layout-config-domains/issue.md`
  for flag resolution notes
- Cycle closure notes or ADR artifact for recording the final
  domain-organization decision
- Potential new domain file(s) only if Alternative B is selected during
  implementation

## Dependencies

- Parent Issue #9: Extract Shared Theme Layout and Organize Configuration
  Domains.
- Sub-Issue #10 completion so shared theme layout naming and source boundary are
  stable.
- Issue #1 verification harness (`scripts/check`).
