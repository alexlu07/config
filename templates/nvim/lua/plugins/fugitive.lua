local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Fugitive: git porcelain ]]
-- Diffview owns the diff / review UI; fugitive covers everything else it
-- deliberately doesn't do (commit, push, blame, rebase). `:Git commit` opens
-- COMMIT_EDITMSG as a normal buffer in this instance — `:wq` commits, `:q!`
-- aborts — instead of spawning a nested nvim inside a terminal buffer.
vim.pack.add { gh 'tpope/vim-fugitive' }

vim.keymap.set('n', '<leader>gc', '<cmd>Git commit<CR>', { desc = 'Git [C]ommit' })

-- Fugitive has no float option, so relocate the commit buffer into one after
-- it opens, to match the floating neo-tree. The buffer is only moved between
-- windows, never closed, so fugitive still resumes the blocked `git` process
-- on `:wq` as usual.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gitcommit', -- add 'gitrebase' here to float `:Git rebase -i` too
  callback = function(args)
    -- When git itself runs nvim as $EDITOR the commit buffer is the only
    -- window, and nvim refuses to close the last non-floating one. Leave that
    -- case alone: there's nothing to float it over anyway.
    local non_floating = 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(win).relative == '' then non_floating = non_floating + 1 end
    end
    if non_floating < 2 then return end

    local split = vim.api.nvim_get_current_win()
    local width = math.min(80, math.floor(vim.o.columns * 0.8))
    local height = math.min(20, math.floor(vim.o.lines * 0.6))

    vim.api.nvim_open_win(args.buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
      border = 'rounded',
      title = ' Commit message ',
      title_pos = 'center',
    })
    vim.api.nvim_win_close(split, false)
  end,
})

-- vim: ts=2 sts=2 sw=2 et
