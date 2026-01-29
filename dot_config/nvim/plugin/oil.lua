-- oil.nvim
Config.later(function()
	vim.pack.add({ "https://github.com/stevearc/oil.nvim", "https://github.com/nvim-tree/nvim-web-devicons" },
		{ load = true })

	-- setup
	local oil = require("oil")
	oil.setup({
		keymaps = {
			["q"] = { "actions.close", mode = "n" }
		},
		lsp_file_methods = {
			enabled = true,
			timeout_ms = 1000,
			autosave_changes = true,
		},
		columns = {
			"icon",
		},
		float = {
			max_width = 40,
			max_height = 25,
		},
	})

	-- keymaps
	-- removed float temp
	Config.map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open parent directory" })
end)

-- Recenter oil floating windows on resize
vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local config = vim.api.nvim_win_get_config(win)

			-- Check if it's a floating oil window
			if config.relative ~= "" and vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "oil" then
				config.row = math.floor((vim.o.lines - config.height) / 2)
				config.col = math.floor((vim.o.columns - config.width) / 2)
				vim.api.nvim_win_set_config(win, config)
			end
		end
	end,
})
