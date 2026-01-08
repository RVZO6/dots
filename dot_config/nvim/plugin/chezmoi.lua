-- i dont know how to get chezmoi.vim setup with the highlights
-- maybe search for lazyvim setup that was good
-- i want snippets (with C-e) OR completion hookin for template snippets 
Config.later(function()
  vim.pack.add({ "https://github.com/xvzc/chezmoi.nvim", "https://github.com/nvim-lua/plenary.nvim", "https://github.com/alker0/chezmoi.vim" }, { load = true })
end)

Config.map("n", "<leader>fc", function()
	require("chezmoi.pick").mini()
end, { desc = "find chezmoi" })
