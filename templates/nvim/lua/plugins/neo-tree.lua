local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Neo-Tree: file tree ]]
vim.pack.add {
  { src = gh 'nvim-neo-tree/neo-tree.nvim', version = vim.version.range '3' },
  -- dependencies
  gh 'nvim-lua/plenary.nvim',
  gh 'MunifTanjim/nui.nvim',
  -- optional, but recommended
  gh 'nvim-tree/nvim-web-devicons',
}

-- Collapse every folder except the path down to (and including) the node
-- under the cursor. Node ids survive collapsing, so this is all in-memory:
-- no filesystem rescans.
local function fold_all_others(state)
  local renderer = require 'neo-tree.ui.renderer'
  local node = state.tree:get_node()
  if not node then return end
  local node_id = node:get_id()
  local was_expanded = node:is_expanded()
  renderer.collapse_all_nodes(state.tree)
  state.explicitly_opened_nodes = {}
  if was_expanded then state.tree:get_node(node_id):expand() end
  renderer.expand_to_node(state, node_id) -- expands ancestors + redraws
  renderer.focus_node(state, node_id)
end

require('neo-tree').setup {
  close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
  window = {
    mappings = {
      ['?'] = 'none', -- default: show_help; freed so `?` is normal vim search
      ['O'] = 'show_help',
      -- ['z'] = 'close_all_nodes',
      ['z'] = 'close_all_subnodes',
      ['Z'] = 'expand_all_subnodes',
      ['F'] = { fold_all_others, desc = 'fold_all_others' },
    },
  },
  filesystem = {
    window = {
      mappings = {
        -- default: fuzzy_finder; freed so `/` is normal vim search and n/N
        -- jump between matches. Note: only visible (expanded) rows are
        -- searchable — press Z on the root first to search the whole tree.
        ['/'] = 'none',
      },
    },
  },
}

vim.keymap.set('n', '<leader>n', '<cmd>Neotree position=float toggle=true reveal=true<CR>')

-- vim: ts=2 sts=2 sw=2 et
