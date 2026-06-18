#!/usr/bin/env bash

# Resolve nvim explicitly: zellij spawns the scrollback editor without our
# interactive-shell PATH, so a bare `nvim` (installed under bob, not on the
# default PATH) isn't found and the pane just flickers. Prefer PATH, fall back
# to bob's nvim-bin.
if command -v nvim >/dev/null 2>&1; then
    NVIM=nvim
else
    NVIM="$HOME/.local/share/bob/nvim-bin/nvim"
fi

# G$    -> bottom, end of line
# ?^.   -> search back to the last non-blank line (skip trailing blanks)
# :noh  -> clear the search highlight it leaves on the first char of every line
keys="G\$?^.\<CR>\$:nohlsearch\<CR>"

# --- Old vim version (used vim-oscyank + vim's term_start API) ---
# close_cb="timer_start(50, {_ -> feedkeys(\"$keys\", 'n')})"
# term_opts="{'close_cb': {_ -> $close_cb}, 'curwin': 1}"
#
# exec vim \
#   -c 'set nonumber norelativenumber' \
#   -c 'nnoremap q :qa!<CR>' \
#   -c 'vnoremap q :<C-u>qa!<CR>' \
#   -c 'nnoremap y y:OSCYankRegister<CR>:qa!<CR>' \
#   -c 'vnoremap y y:OSCYankRegister<CR>:qa!<CR>' \
#   -c "call term_start(['cat', '$1'], $term_opts)"

# --- Neovim version ---
# Open the dump as a NORMAL buffer (not a terminal): nvim renders lazily, only
# drawing the viewport, so it opens instantly and jumps to the bottom regardless
# of scrollback size -- no cat-through-a-pty bottleneck, full history scrollable.
# baleia.nvim then strips the ANSI escape codes (EditScrollback { ansi true })
# and re-applies them as highlights, so we keep colors without a terminal.
# No --clean: this loads the full config so normal keybindings (C-j/C-k, etc.)
# work; only line numbers and q/y are overridden below. y -> "+y goes through
# pbcopy locally / OSC52 over SSH (replaces vim-oscyank).
exec "$NVIM" "$1" \
  -c 'set nonumber norelativenumber signcolumn=no foldcolumn=0 laststatus=0 cmdheight=0' \
  -c 'nnoremap q :qa!<CR>' \
  -c 'vnoremap q :<C-u>qa!<CR>' \
  -c 'nnoremap y "+y:qa!<CR>' \
  -c 'vnoremap y "+y:qa!<CR>' \
  -c 'lua require("baleia").setup({ async = false, chunk_size = 5000 }).once(0)' \
  -c "call feedkeys(\"$keys\", 'n')"
