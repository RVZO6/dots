-- mini.pick
vim.pack.add({ 'https://github.com/nvim-mini/mini.pick', 'https://github.com/nvim-mini/mini.extra', 'https://github.com/nvim-mini/mini.icons' })

-- setup
require('mini.icons').setup()

-- centre window
require('mini.pick').setup({
	window = {
		config = function()
			local height = math.floor(0.6 * vim.o.lines)
			local width = math.floor(0.4 * vim.o.columns)
			return {
				anchor = 'NW',
				height = height,
				width = width,
				row = math.floor(0.5 * (vim.o.lines - height)),
				col = math.floor(0.5 * (vim.o.columns - width)),
			}
		end
	}
})
require('mini.extra').setup()

-- keymaps
map({ "n", "v", "x" }, "<leader><space>",
	function() MiniPick.builtin.files() end, { desc = "Pick files" })

-- map({ "n", "v", "x" }, "<leader>fc",
-- 	function()
-- 		MiniPick.builtin.files(nil, {
-- 			source = { cwd = vim.fn.stdpath('config'), name = 'Config' }
-- 		})
-- 	end, { desc = "[F]ind [c]onfig" })

map({ "n", "v", "x" }, "<leader>sk",
	function() MiniExtra.pickers.keymaps() end, { desc = "[S]earch [k]eymaps" })

map({ "n", "v", "x" }, "<leader>sh",
	function() MiniPick.builtin.help() end, { desc = "[S]earch [h]elp" })

map({ "n", "v", "x" }, "<leader>sH",
	function() MiniExtra.pickers.hl_groups() end, { desc = "[S]earch [H]ighlights" })
