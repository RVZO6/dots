if vim.env.NVIM_DISABLE_COLORSCHEME == "1" then
	return
end

local is_omarchy = vim.fn.isdirectory(vim.fn.expand("~/.config/omarchy")) == 1

local function reload_omarchy_theme()
	local ok, base16 = pcall(require, "mini.base16")
	if not ok then
		vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })
		base16 = require("mini.base16")
	end

	local theme = dofile(vim.fn.expand("~/.config/nvim/lua/omarchy_theme.lua"))
	base16.setup({ palette = theme })

	local function clear_bg(...)
		for _, name in ipairs({ ... }) do
			vim.api.nvim_set_hl(0, name, { bg = "NONE" })
		end
	end
	clear_bg(
		"LineNr", "CursorLineNr", "LineNrAbove", "LineNrBelow", "Number",
		"Normal", "NormalFloat", "NormalNC", "SignColumn",
		"CursorLine", "Folded", "EndOfBuffer", "PaneClose",
		"GitSignsAdd", "GitSignsChange", "GitSignsDelete",
		"GitSignsUntracked", "GitSignsTopdelete", "GitSignsChangedelete",
		"SnacksPickerNormal", "SnacksPickerTitle", "SnacksPickerSelected",
		"SnacksPickerMatching", "SnacksPickerBorder", "SnacksPickerPrompt",
		"StatusLine", "StatusLineNC"
	)
end

if is_omarchy then
	Config.now(reload_omarchy_theme)

	vim.api.nvim_create_autocmd("Signal", {
		pattern = "SIGUSR1",
		callback = reload_omarchy_theme,
	})
else
	Config.now(function()
		vim.pack.add({ "https://github.com/vague-theme/vague.nvim" })
		require("vague").setup({ transparent = true })
		vim.cmd.colorscheme("vague")
	end)
end
