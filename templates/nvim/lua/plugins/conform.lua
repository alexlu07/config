local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Formatting ]]
vim.pack.add { gh 'stevearc/conform.nvim' }
require('conform').setup {
  notify_on_error = false,
  -- format_on_save = function(bufnr)
  --   -- You can specify filetypes to autoformat on save here:
  --   local enabled_filetypes = {
  --     python = true,
  --     rust = true,
  --     c = true,
  --     cpp = true,
  --     java = true,
  --     javascript = true,
  --     typescript = true,
  --     html = true,
  --     css = true,
  --     json = true,
  --     yaml = true,
  --     sh = true,
  --   }
  --   if enabled_filetypes[vim.bo[bufnr].filetype] then
  --     return { timeout_ms = 500 }
  --   else
  --     return nil
  --   end
  -- end,
  default_format_opts = {
    lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
  },
  -- You can also specify external formatters in here.
  formatters_by_ft = {
    python = { "ruff_format" }, -- or {"isort", "black"}
    rust = { "rustfmt" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    java = { "google_java_format" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    html = { "prettierd" },
    css = { "prettierd" },
    json = { "prettierd" },
    yaml = { "prettierd" },
    sh = { "shfmt" },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })

-- vim: ts=2 sts=2 sw=2 et
