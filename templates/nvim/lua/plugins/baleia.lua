local function gh(repo) return 'https://github.com/' .. repo end

-- ANSI colorizer used only by the zellij scrollback pager
-- (zellij_scrollback.sh). Installed here so it's on the runtimepath; it does
-- nothing until that script calls `require('baleia').setup({}).once(0)`.
vim.pack.add { gh 'm00qek/baleia.nvim' }

-- vim: ts=2 sts=2 sw=2 et
