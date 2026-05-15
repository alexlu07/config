# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A personal dotfiles repository managed by [dotbot](https://github.com/anishathalye/dotbot). A single unified branch supports both macOS and Linux via OS-specific markers in the template files.

## Key Commands

**Bootstrap + apply dotfiles (does everything):**
```bash
./install
```

`install` generates OS-specific configs from `templates/`, runs the generated `configs/requirements`, inits the dotbot submodule, symlinks all configs, and runs macOS-only post-install steps.

## How the OS Marker System Works

Source files live in `templates/`. Files with OS-specific content use `#@os:` block markers:

```
#@os:mac
...lines only on macOS (Darwin)...
#@os:end

#@os:linux
...lines only on Linux...
#@os:end
```

`./install` detects `uname -s`, strips the other OS's blocks via `awk`, and writes plain output files into `configs/`. The `configs/` directory is gitignored.

Dotbot is called with `configs/install.conf.yaml`, which links from `configs/` for all files.

## Template Files and Their Differences

| File | OS-specific content |
|------|-------------------|
| `zshrc` | alias comment style, autoclicker/setwindow functions (linux), fzf load method, conda home path |
| `tmux.conf` | `default-shell` path, `reattach-to-user-namespace` (mac), yank_selection settings (linux) |
| `requirements` | package manager (apt vs brew), fzf install method, reattach (mac), miniconda URL/command |
| `install.conf.yaml` | zellij.kdl link (mac only) |

Static files with no OS differences (just copied): `vimrc`, `ackrc`, `gitconfig`, `gitignore`, `tmux_lines.sh`, `zellij.kdl`

## Notable zshrc Behaviors

- `here()` — cd to directory of the currently open file in VSCode
- `home()` — cd to the folder open in VSCode; auto-runs on shell start inside VSCode
- Outside VSCode: `cd ~/Desktop` on start
- Auto-attaches to `main` tmux session on shell start (skipped inside VSCode)
- vi mode enabled (`set -o vi`) with emacs fallback (`bindkey -e`)

## tmux Key Bindings

- `C-a` — forwards to nested tmux session
- `prefix -` / `prefix |` — split pane vertically/horizontally
- `prefix h/j/k/l` — move between panes (vim-style)
- `M-Left` / `M-Right` — previous/next window
- Uses TPM with tmux-sensible and tmux-yank plugins
