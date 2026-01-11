local theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim-mini-base16.lua")
local has_omarchy = vim.fn.filereadable(theme_file) == 1

if has_omarchy then
	-- Omarchy System (Linux Desktop)
	local palette = dofile(theme_file)

	Config.now(function()
		vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })
		require("mini.base16").setup({ palette = palette })
	end)

	Config.later(function()
		local c = palette

		-- Transparent statusline
		vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
		vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })

		-- Spell undercurl
		for _, group in ipairs({
			"SpellBad", "SpellCap", "SpellRare", "SpellLocal",
			"DiagnosticUnderlineError", "DiagnosticUnderlineWarn",
			"DiagnosticUnderlineInfo", "DiagnosticUnderlineHint",
		}) do
			local current = vim.api.nvim_get_hl(0, { name = group })
			vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", current, { undercurl = true }))
		end

		-- RenderMarkdown (basic setup)
		vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = c.base0B })
		vim.api.nvim_set_hl(0, "RenderMarkdownTableRow", { fg = c.base0E })
		vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = c.base01 })

		vim.api.nvim_set_hl(0, "@markup.strong", { fg = c.base0E, bold = true })
		vim.api.nvim_set_hl(0, "@markup.italic", { fg = c.base0E, italic = true })
		vim.api.nvim_set_hl(0, "@markup.heading.1", { fg = c.base08, bold = true })
		vim.api.nvim_set_hl(0, "@markup.heading.2", { fg = c.base09, bold = true })
		vim.api.nvim_set_hl(0, "@markup.heading.3", { fg = c.base0B, bold = true })
		vim.api.nvim_set_hl(0, "@markup.heading.4", { fg = c.base0D, bold = true })
		vim.api.nvim_set_hl(0, "@markup.heading.5", { fg = c.base0A, bold = true })
		vim.api.nvim_set_hl(0, "@markup.heading.6", { fg = c.base0F, bold = true })
	end)

	-- Auto-reload on theme change
	vim.api.nvim_create_autocmd({ "BufWritePost", "FileChangedShellPost" }, {
		pattern = theme_file,
		callback = function()
			package.loaded["mini.base16"] = nil
			local palette = dofile(theme_file)
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
