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

Static files with no OS differences (just copied): `vimrc`, `ackrc`, `gitconfig`, `gitignore`, `tmux_lines.sh`, `zellij.kdl`, `nvim/init.lua`

## Neovim

Editor is Neovim, configured via `templates/nvim/init.lua` (linked to `~/.config/nvim`). The config is a customized [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim): a single owned `init.lua` using the built-in `vim.pack` plugin manager (requires nvim 0.12+), shipping Telescope, Treesitter, LSP + completion, gitsigns, which-key. Local customizations are marked with comments and keep the upstream lines commented out beside them.

- **Install**: neovim is installed via [bob](https://github.com/MordechaiHadad/bob) (`bob use stable`), itself installed via `cargo install bob-nvim`. `requirements` bootstraps rustup if absent (all under `$HOME`, no sudo). `zshrc` adds `~/.cargo/bin` and `~/.local/share/bob/nvim-bin` to PATH.
- **Clipboard**: no plugin. `'clipboard'` is left empty so normal yanks stay local; only `"+y`/`"+p` hit the system clipboard, routed through pbcopy/pbpaste locally and OSC52 over SSH (replaces the old `vim-oscyank`). The `unnamedplus` line from kickstart is commented out.
- **Ported from old vimrc**: `relativenumber`, 4-space expandtab fallback (guess-indent auto-detects per file), `<C-j>`/`<C-k>` = jump 3 lines + center (overrides kickstart's window-focus maps; use `<C-h>`/`<C-l>` for windows).
- **`vim`/`vi`** are aliased to `nvim` in zshrc; `EDITOR`/`VISUAL` = `nvim`. The `~/.vimrc` link remains as a fallback for the real vim binary.
- **zellij scrollback** (`templates/zellij/zellij_scrollback.sh`): opens the ANSI dump as a normal buffer (lazy render, instant, full history) and colorizes it with `baleia.nvim` instead of piping through a terminal. `baleia` is added via `vim.pack` but only invoked by this script.

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
