local theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim-mini-base16.lua")
local has_omarchy = vim.fn.filereadable(theme_file) == 1

if has_omarchy then
	-- Omarchy System (Linux Desktop)
	local palette = dofile(theme_file)

	Config.now(function()
		require("mini.base16").setup({ palette = palette })
	end)

	-- Auto-reload on theme change
	vim.api.nvim_create_autocmd({ "BufWritePost", "FileChangedShellPost" }, {
		pattern = theme_file,
		callback = function()
			package.loaded["mini.base16"] = nil
			require("mini.base16").setup({ palette = palette })
			vim.cmd("redraw!")
		end,
	})
else
	-- macOS / Non-Omarchy (Vague Theme)
	Config.now(function()
		vim.pack.add({ "https://github.com/vague-theme/vague.nvim" })
	end)

	Config.now(function()
		require("vague").setup({
			transparent = true,
			on_highlights = function(hl, c)
				-- Keep your existing Vague fixes here
				hl.RenderMarkdownBullet     = { fg = c.plus }
				hl.RenderMarkdownTableRow   = { fg = c.keyword }
				hl.RenderMarkdownCode       = { bg = c.line }
				hl.RenderMarkdownCodeBorder = { bg = c.visual }

				hl["@markup.strong"]        = { fg = c.keyword, gui = "bold" }
				hl["@markup.italic"]        = { fg = c.keyword, gui = "italic" }
				hl["@markup.heading.1"]     = { fg = c.constant, gui = "bold" }
				hl["@markup.heading.2"]     = { fg = c.parameter, gui = "bold" }
				hl["@markup.heading.3"]     = { fg = c.type, gui = "bold" }
				hl["@markup.heading.4"]     = { fg = c.operator, gui = "bold" }
				hl["@markup.heading.5"]     = { fg = c.plus, gui = "bold" }
				hl["@markup.heading.6"]     = { fg = c.func, gui = "bold" }

				hl.RenderMarkdownH1Bg       = { bg = "#31304d" }
				hl.RenderMarkdownH2Bg       = { bg = "#4c324e" }
				hl.RenderMarkdownH3Bg       = { bg = "#243b41" }
				hl.RenderMarkdownH4Bg       = { bg = "#384758" }
				hl.RenderMarkdownH5Bg       = { bg = "#355615" }
				hl.RenderMarkdownH6Bg       = { bg = "#72393a" }
				hl.SpellBad                 = { sp = c.error, gui = "undercurl" }
				hl.SpellCap                 = { sp = c.warning, gui = "undercurl" }
				hl.SpellLocal               = { sp = c.hint, gui = "undercurl" }
				hl.SpellRare                = { sp = c.plus, gui = "undercurl" }
			end,
		})
		vim.cmd("colorscheme vague")
		vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
		vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })
	end)
end
