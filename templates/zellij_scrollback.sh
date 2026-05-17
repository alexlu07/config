#!/usr/bin/env bash

keys="G\$?^.\<CR>\$"
close_cb="timer_start(50, {_ -> feedkeys(\"$keys\", 'n')})"
term_opts="{'close_cb': {_ -> $close_cb}, 'curwin': 1}"

exec vim \
  -c 'set nonumber norelativenumber' \
  -c 'nnoremap q :qa!<CR>' \
  -c 'nnoremap y "+y:qa!<CR>' \
  -c 'vnoremap y "+y:qa!<CR>' \
  -c "call term_start(['cat', '$1'], $term_opts)"
