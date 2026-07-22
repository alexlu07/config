local function gh(repo) return 'https://github.com/' .. repo end

-- Because lua is a real programming language, you can also have some logic to your installation -
-- like only installing a plugin if a condition is met.
--
-- Here we only install `nvim-web-devicons` (which adds pretty icons) if we have a Nerd Font,
-- since otherwise the icons won't display properly.
if vim.g.have_nerd_font then vim.pack.add { gh 'nvim-tree/nvim-web-devicons' } end

-- vim: ts=2 sts=2 sw=2 et
