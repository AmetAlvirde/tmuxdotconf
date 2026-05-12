# Tmux Configuration

Tmux is one of my favorite tools ever. This is my current personal
configuration. I hope you find it inspiring to give Tmux a try, or to find
something useful in it if you already are a tmux user.

## Highlights

- `tmux.conf` as the main tmux entrypoint.
- Automatic Solarized dark/light theme selection based on macOS appearance.
- Shared theme layout in `solarized-base.conf` so dark and light variants do not
  drift.
- Small shell-based verification scripts under `scripts/`.

## Files

- `tmux.conf` loads the main configuration and theme hooks.
- `theme-switcher.sh` detects macOS appearance and applies the matching theme.
- `solarized-dark.conf` defines dark theme role values.
- `solarized-light.conf` defines light theme role values.
- `solarized-base.conf` defines the shared status, pane, message, and clock
  layout.

## Requirements

- `tmux`
- `bash`
- macOS `osascript` for automatic appearance-aware theme switching
- TPM for plugin installation

## Usage

Load the config from tmux:

```sh
tmux source-file ~/.config/tmux/tmux.conf
```

Reload from inside tmux with `prefix + r`.

Force a theme refresh from inside tmux with `prefix + T`.

## Verification

Run the repository checks with:

```sh
bash scripts/check
```

This validates tmux parsing, shell syntax, theme layout boundaries, and
theme-switcher behavior.

## Licence

MIT Licence. See [LICENSE](LICENSE)
