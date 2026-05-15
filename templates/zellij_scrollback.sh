#!/usr/bin/env bash

exec vim \
  +'normal G?^.<CR>$' \
  +'exe "normal ?\\S\r"' \
  +'nnoremap q :qa!<CR>' \
  +'nnoremap y "+y:qa!<CR>' \
  +'vnoremap y "+y:qa!<CR>' \
  "$@"
