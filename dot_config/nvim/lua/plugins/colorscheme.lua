return {
	{
		"mellow-theme/mellow.nvim",
		config = function()
			vim.g.mellow_transparent = true
			vim.cmd([[colorscheme Mellow]])
			vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
			vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
			for _, group in ipairs({
				"SpellBad",
				"SpellCap",
				"SpellRare",
				"SpellLocal",
				"DiagnosticUnderlineError",
				"DiagnosticUnderlineWarn",
				"DiagnosticUnderlineInfo",
				"DiagnosticUnderlineHint",
				"Underlined",
			}) do
				local current = vim.api.nvim_get_hl(0, { name = group })
				vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", current, { undercurl = true }))
			end
		end,
	},
	-- NOTE: fuck
	-- {
	--   "LazyVim/LazyVim",
	--   opts = {
	--     colorscheme = "mellow",
	--   },
	-- },
}
