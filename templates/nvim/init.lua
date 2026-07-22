-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Core options, keymaps, and autocommands
require 'options'
require 'keymaps'

-- vim.pack intro and build hooks; must load before any `vim.pack.add` below
require 'pack'

-- [[ Plugins ]]
-- One file per plugin in `lua/plugins/`. To add a plugin, create a new file
-- there (vim.pack.add + setup) and require it here. Order matters only where
-- noted (e.g. luasnip before blink-cmp).
require 'plugins.guess-indent'
require 'plugins.baleia'
require 'plugins.devicons'
require 'plugins.gitsigns'
require 'plugins.which-key'
require 'plugins.colorscheme'
require 'plugins.todo-comments'
require 'plugins.mini'
require 'plugins.telescope'
require 'plugins.lsp'
require 'plugins.conform'
require 'plugins.luasnip'
require 'plugins.blink-cmp'
require 'plugins.treesitter'
require 'plugins.neo-tree'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
