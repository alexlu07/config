local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Diffview: git diff / merge tool / file history in a single tabpage ]]
vim.pack.add { gh 'sindrets/diffview.nvim' }

local actions = require 'diffview.actions'

-- Overrides applied to both the file panel and the file history panel, to line
-- the panels up with the neo-tree config in `lua/plugins/neo-tree.lua`.
-- Diffview leaves `/` and `?` unbound in its panels, so vim search already
-- works there and needs no equivalent of neo-tree's `['?'] = 'none'`.
-- Neo-tree's `z`/`Z` are scoped to the node under the cursor; diffview has no
-- subtree fold action, so these are the whole-panel folds on the same keys.
local function panel_keymaps(ctx)
  return {
    { 'n', 'O', actions.help(ctx), { desc = 'Open the help panel' } }, -- neo-tree: show_help
    { 'n', 'C', actions.close_fold, { desc = 'Collapse the fold under the cursor' } }, -- neo-tree: close_node
    { 'n', 'z', actions.close_all_folds, { desc = 'Collapse all folds' } }, -- neo-tree: close_all_nodes
    { 'n', 'Z', actions.open_all_folds, { desc = 'Expand all folds' } }, -- neo-tree: expand_all_nodes
    -- default: focus_files, a no-op when the panel is already focused. Paired
    -- with the `view` context's <leader>e this makes the key a focus toggle.
    { 'n', '<leader>e', actions.focus_entry, { desc = 'Open the entry and focus the diff' } },
  }
end

require('diffview').setup {
  enhanced_diff_hl = true, -- default: false. Better intra-line diff highlighting.
  view = {
    merge_tool = {
      -- default: 'diff3_horizontal' (three narrow columns). 'mixed' puts OURS
      -- and THEIRS side by side on top and the file you're editing full-width
      -- underneath.
      layout = 'diff3_mixed',
    },
  },
  keymaps = {
    file_panel = panel_keymaps 'file_panel',
    file_history_panel = panel_keymaps 'file_history_panel',
  },
}

-- Open a diffview, or close the one in this tabpage if there already is one.
-- `get_current_view()` is per-tabpage, so this is a toggle from anywhere.
local function toggle_diffview()
  if require('diffview.lib').get_current_view() then
    vim.cmd.DiffviewClose()
  else
    vim.cmd.DiffviewOpen()
  end
end

-- The branch to review against. Resolved from the remote's HEAD rather than
-- hardcoding `main`, since which one it is varies per repo. `origin/HEAD` is
-- only set at clone time, so fall back to probing the usual two names.
local function default_branch()
  local head = vim.system({ 'git', 'rev-parse', '--abbrev-ref', 'origin/HEAD' }, { text = true }):wait()
  if head.code == 0 then return vim.trim(head.stdout) end

  for _, name in ipairs { 'origin/main', 'origin/master' } do
    if vim.system({ 'git', 'rev-parse', '--verify', '--quiet', name }):wait().code == 0 then return name end
  end
end

-- Diff against the default branch. `committed_only` picks between the two
-- useful comparisons: a three-dot range diffs the merge base against HEAD
-- ("review what I've committed", ignores a dirty tree), while the bare rev
-- diffs it against the working tree (uncommitted and untracked files
-- included).
local function diff_default_branch(committed_only)
  local base = default_branch()
  if not base then
    vim.notify("Can't resolve the default branch; try `git remote set-head origin -a`", vim.log.levels.ERROR)
    return
  end
  vim.cmd('DiffviewOpen ' .. base .. (committed_only and '...HEAD' or ''))
end

-- Lowercase / uppercase is scope: this file / the whole repo. The `l` infix
-- means "compare against the working tree" rather than against each commit's
-- own parent, so picking an old commit shows everything that has changed
-- since then. There's no `<leader>dld`: `dd` already diffs the working tree.
vim.keymap.set('n', '<leader>dd', toggle_diffview, { desc = '[D]iffview toggle' })
vim.keymap.set('n', '<leader>dh', '<cmd>DiffviewFileHistory %<CR>', { desc = '[D]iff [H]istory of this file' })
vim.keymap.set('x', '<leader>dh', ":'<,'>DiffviewFileHistory<CR>", { desc = '[D]iff [H]istory of selected lines' })
vim.keymap.set('n', '<leader>dH', '<cmd>DiffviewFileHistory<CR>', { desc = '[D]iff [H]istory of the repo' })
vim.keymap.set('n', '<leader>dm', function() diff_default_branch(true) end, { desc = '[D]iff committed vs default branch ([m]erge base)' })

vim.keymap.set('n', '<leader>dlh', '<cmd>DiffviewFileHistory --base=LOCAL %<CR>', { desc = 'History of this file vs [L]ocal' })
vim.keymap.set('n', '<leader>dlH', '<cmd>DiffviewFileHistory --base=LOCAL<CR>', { desc = 'History of the repo vs [L]ocal' })
vim.keymap.set('n', '<leader>dlm', function() diff_default_branch(false) end, { desc = 'Default branch vs [L]ocal' })

-- vim: ts=2 sts=2 sw=2 et
