local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Autocomplete Engine ]]
-- Uses luasnip as the snippet engine; see `lua/plugins/luasnip.lua` (loaded first).
vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
  keymap = {
    preset = 'default',

    -- Accept completion with Tab; otherwise insert normal indentation.
    ['<Tab>'] = { 'select_and_accept', 'fallback' },
    ['<C-y>'] = false,

    -- Keep snippet navigation off Tab and terminal pane-navigation keys.
    ['<S-Tab>'] = false,
    ['<C-f>'] = { 'snippet_forward', 'fallback' },
    ['<C-b>'] = { 'snippet_backward', 'fallback' },
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
  },

  completion = {
    -- By default, you may press `<c-space>` to show the documentation.
    -- Optionally, set `auto_show = true` to show the documentation after a delay.
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },

  snippets = { preset = 'luasnip' },

  -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
  -- which automatically downloads a prebuilt binary when enabled.
  --
  -- By default, we use the Lua implementation instead, but you may enable
  -- the rust implementation via `'prefer_rust_with_warning'`
  --
  -- See `:help blink-cmp-config-fuzzy` for more information
  fuzzy = { implementation = 'lua' },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}

-- vim: ts=2 sts=2 sw=2 et
