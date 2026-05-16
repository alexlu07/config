#!/usr/bin/env bash

exec vim \
  -c 'set nonumber norelativenumber termguicolors' \
  -c 'nnoremap q :qa!<CR>' \
  -c 'nnoremap y "+y:qa!<CR>' \
  -c 'vnoremap y "+y:qa!<CR>' \
  -c "call term_start(['cat', '$1'], {'close_cb': {_ -> feedkeys(\"G\$?^.\<CR>\$\",'n')}, 'curwin': 1})"

