Config.later(function()
  vim.pack.add({ "https://github.com/xvzc/chezmoi.nvim", "https://github.com/nvim-lua/plenary.nvim" }, { load = true })
end)

Config.map("n", "<leader>fc", function()
	require("chezmoi.pick").mini()
end, { desc = "find chezmoi" })
