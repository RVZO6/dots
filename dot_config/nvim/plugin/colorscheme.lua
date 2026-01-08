-- colorscheme
-- vim.pack.add({ "https://github.com/mellow-theme/mellow.nvim" })
-- vim.g.mellow_transparent = true
-- vim.cmd([[ colorscheme mellow ]])
-- vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })

vim.pack.add({ "https://github.com/vague-theme/vague.nvim" })

-- setup
require("vague").setup({
	transparent = true,
	on_highlights = function(hl, c)
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

		-- Inverted lightness from base colors + darkened by 5
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
