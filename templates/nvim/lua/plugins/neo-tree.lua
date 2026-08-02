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

-- [[ Tree-wide search ]]
--
-- A vim `/` can only match rows that are actually rendered, so anything inside
-- a collapsed directory is invisible to it. These mappings search the *tree*
-- instead of the buffer: matches come from neo-tree's own file scanner (so
-- dotfile and gitignore filtering agree with what the tree would display), and
-- landing on one expands only that match's ancestors. Everything else stays
-- exactly as collapsed as you left it.
--
-- Typing the pattern only highlights what is already on screen — nothing is
-- expanded, and no directory is scanned, until you press <CR> (or n / N).

-- The active search. `direction` is the one the search was started in, so `n`
-- repeats that way and `N` reverses, as in vim.
--
-- Deliberately no "current match" index: every jump is computed from where the
-- cursor is right now, so moving around the tree by hand and then pressing `n`
-- continues from there, exactly as a real `n` would.
local active = { term = nil, matches = {}, dirs = {}, direction = 1 }

--- Order paths the way neo-tree renders them: a component is a directory if
--- there is more path after it (or the scanner reported it as one), and
--- directories are listed before files.
local function display_order(a, b)
  local pa = vim.split(a, '/', { plain = true })
  local pb = vim.split(b, '/', { plain = true })
  for i = 1, math.max(#pa, #pb) do
    if pa[i] ~= pb[i] then
      if pa[i] == nil then return true end
      if pb[i] == nil then return false end
      -- `== true` keeps these boolean: a bare table lookup yields nil, and
      -- `nil ~= false` would make two plain files look like different kinds.
      local a_is_dir = i < #pa or active.dirs[a] == true
      local b_is_dir = i < #pb or active.dirs[b] == true
      if a_is_dir ~= b_is_dir then return a_is_dir end
      return pa[i] < pb[i]
    end
  end
  return false
end

--- Put the cursor on `path`, expanding only what is needed to see it: a node
--- already in the tree just needs its ancestors expanded (`focus_node` does
--- that itself), while one that has never been scanned needs `navigate` to
--- load the directories along the way.
local function reveal(state, path)
  if state.tree:get_node(path) then
    require('neo-tree.ui.renderer').focus_node(state, path)
  else
    require('neo-tree.sources.filesystem').navigate(state, state.path, path)
  end
end

--- Find every path matching `term` and hand the results to `callback` as
--- `(matches, dirs)`, unsorted — the caller has to fold in what it knows about
--- directories before ordering them. Purely a scan: the tree is not touched.
local function collect(state, term, callback)
  local matches, dirs = {}, {}
  require('neo-tree.sources.filesystem.lib.filter_external').find_files {
    path = state.path,
    term = term,
    limit = state.search_limit or 50,
    filtered_items = state.filtered_items,
    find_command = state.find_command,
    find_args = state.find_args,
    find_by_full_path_words = state.find_by_full_path_words,
    -- Directories come back with a trailing slash, which never matches a node
    -- id. Strip it, but remember it: that slash is the only signal that a
    -- match is a directory rather than a file.
    on_insert = function(err, path)
      if err then return end
      local id = path:gsub('/+$', '')
      if id ~= path then dirs[id] = true end
      table.insert(matches, id)
    end,
    on_exit = vim.schedule_wrap(function() callback(matches, dirs) end),
  }
end

--- Index of the first match past `from` in `direction`, or nil to wrap.
local function match_after(matches, from, direction)
  if not from then return nil end
  if direction > 0 then
    for i, path in ipairs(matches) do
      if display_order(from, path) then return i end
    end
  else
    for i = #matches, 1, -1 do
      if display_order(matches[i], from) then return i end
    end
  end
end

--- Read a pattern, highlighting what it matches on screen as it is typed.
--- Returns nil if cancelled. Only the rendered rows can highlight, which is
--- the point: nothing expands until the pattern is accepted.
local function read_pattern(prompt)
  local restore = vim.fn.getreg '/'
  local pattern = ''

  while true do
    vim.fn.setreg('/', pattern == '' and '' or ('\\V' .. vim.fn.escape(pattern, '\\')))
    vim.o.hlsearch = true
    vim.api.nvim_echo({ { prompt .. pattern } }, false, {})
    vim.cmd.redraw()

    local ok, char = pcall(vim.fn.getcharstr)
    if not ok then char = vim.keycode '<Esc>' end -- <C-c>

    -- Special keys arrive as a K_SPECIAL sequence, not the ASCII control
    -- code: <BS> is the three bytes 0x80 'k' 'b'. `keytrans` turns whatever
    -- came in into the name you would write in a mapping.
    local key = vim.fn.keytrans(char)

    if key == '<CR>' or key == '<NL>' then
      break
    elseif key == '<Esc>' then
      pattern = ''
      break
    elseif key == '<BS>' or key == '<C-H>' or key == '<Del>' then
      pattern = vim.fn.strcharpart(pattern, 0, vim.fn.strchars(pattern) - 1)
      if pattern == '' then break end -- backspaced past the start, as in vim
    elseif key == '<C-U>' then
      pattern = ''
    elseif key == '<C-W>' then
      pattern = pattern:gsub('%S+%s*$', '')
    elseif char:byte(1) == 128 or char:byte(1) < 0x20 then
      -- any other special or control key: ignore it
    else
      pattern = pattern .. char
    end
  end

  vim.api.nvim_echo({ { '' } }, false, {})
  if pattern == '' then
    vim.fn.setreg('/', restore)
    vim.o.hlsearch = false
    return nil
  end
  vim.fn.histadd('search', pattern)
  return pattern
end

--- Jump to the nearest match past the cursor, wrapping (and saying so) at the
--- ends. This is the whole of what both `/` and `n` do once the match list
--- exists — they differ only in that `/` builds the list first.
local function jump(state, direction)
  if #active.matches == 0 then return end

  local node = state.tree:get_node()
  local from = node and node:get_id()
  -- The scanner only knows about the paths it matched, so the node the cursor
  -- happens to be on has to be classified here. Without this a directory
  -- under the cursor compares as a file, and everything below it looks like it
  -- comes first.
  if from and node.type == 'directory' then active.dirs[from] = true end

  local index = match_after(active.matches, from, direction)
  if not index then
    index = direction > 0 and 1 or #active.matches
    vim.notify(
      direction > 0 and 'search hit BOTTOM, continuing at TOP' or 'search hit TOP, continuing at BOTTOM',
      vim.log.levels.INFO
    )
  end
  reveal(state, active.matches[index])
end

--- `/` and `?`. Build the match list, then jump to the first one past the
--- cursor in `direction`.
local function search_tree(direction)
  return function(state)
    local term = read_pattern(direction > 0 and '/' or '?')
    if not term then return end

    collect(state, term, function(matches, dirs)
      if #matches == 0 then
        vim.notify('Pattern not found: ' .. term, vim.log.levels.WARN)
        return
      end

      active.dirs = dirs -- display_order consults this while sorting
      table.sort(matches, display_order)
      active.term, active.matches, active.direction = term, matches, direction

      jump(state, direction)

      if #matches >= (state.search_limit or 50) then
        vim.notify(('Stopped at %d matches (search_limit)'):format(#matches), vim.log.levels.WARN)
      end
    end)
  end
end

--- `n` and `N`. `sign` is +1 to repeat the search's own direction, -1 to
--- reverse it. With no search active, fall through to the builtin keys.
local function repeat_search(sign)
  return function(state)
    if not active.term then
      vim.api.nvim_feedkeys(sign > 0 and 'n' or 'N', 'n', false)
      return
    end

    jump(state, sign * active.direction)
  end
end

require('neo-tree').setup {
  close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
  window = {
    mappings = {
      -- default: show_help; `?` searches the whole tree, backwards
      ['?'] = { search_tree(-1), desc = 'search tree backward' },
      ['n'] = { repeat_search(1), desc = 'next match (search direction)' },
      ['N'] = { repeat_search(-1), desc = 'previous match' },
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
        -- default: fuzzy_finder; `/` searches the whole tree instead, with
        -- n/N walking the matches.
        ['/'] = { search_tree(1), desc = 'search tree' },
      },
    },
  },
}

vim.keymap.set('n', '<leader>f', '<cmd>Neotree position=float toggle=true reveal=true<CR>', { desc = '[F]ile tree' })

-- vim: ts=2 sts=2 sw=2 et
