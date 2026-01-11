Config.now(function()
	vim.g["chezmoi#use_tmp_buffer"] = true
	-- vim.pack.add({ "https://github.com/alker0/chezmoi.vim" })
end)

Config.later(function()
	vim.pack.add(
		{ "https://github.com/xvzc/chezmoi.nvim", "https://github.com/nvim-lua/plenary.nvim", "https://github.com/alker0/chezmoi.vim" }, { load = true })
end)

Config.map("n", "<leader>fc", function()
	require("chezmoi.pick").mini()
end, { desc = "find chezmoi" })
