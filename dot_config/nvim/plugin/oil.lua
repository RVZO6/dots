-- oil.nvim
vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

-- config
local min_width = 40
local max_width = 0.3
local max_height = 0.6

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
		max_width = max_width,
		max_height = max_height,
		-- use override to set min_width and keep centered
		override = function(conf)
			if conf.width < min_width then
				conf.width = min_width
				-- recalculate col to keep centered
				conf.col = math.floor((vim.o.columns - conf.width) / 2)
			end
			return conf
		end,
	},
})

-- keymaps
map("n", "<leader>e", function()
	oil.open_float()
end, { desc = "Open parent directory" })

-- autocmds
-- recenter oil float on window resize using nvim_win_set_config
vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local cfg = vim.api.nvim_win_get_config(win)
			if vim.bo[buf].filetype == "oil" and cfg.relative ~= "" then
				local width = math.max(math.floor(max_width * vim.o.columns), min_width)
				local height = math.floor(max_height * vim.o.lines)
				vim.api.nvim_win_set_config(win, {
					relative = cfg.relative,
					width = width,
					height = height,
					row = math.floor((vim.o.lines - height) / 2),
					col = math.floor((vim.o.columns - width) / 2),
				})
				return
			end
		end
	end,
})
