-- snacks.nvim picker
Config.later(function()
	vim.pack.add({ "https://github.com/folke/snacks.nvim" }, { load = true })

  require("snacks").setup({
    picker = {
      layout = { fullscreen = true },
    },
  })

	local picker = require("snacks.picker")

	Config.map({ "n", "v", "x" }, "<leader><space>", function()
		picker.files()
	end, { desc = "Pick files" })

	Config.map({ "n", "v", "x" }, "<leader>sg", function()
		picker.grep()
	end, { desc = "[S]earch [G]rep" })

	Config.map({ "n", "v", "x" }, "<leader>sk", function()
		picker.keymaps()
	end, { desc = "[S]earch [k]eymaps" })

	Config.map({ "n", "v", "x" }, "<leader>sh", function()
		picker.help()
	end, { desc = "[S]earch [h]elp" })

	Config.map({ "n", "v", "x" }, "<leader>sH", function()
		picker.highlights()
	end, { desc = "[S]earch [H]ighlights" })

	Config.map("n", "z=", function()
		picker.spelling()
	end, { desc = "Spelling suggestions" })
end)
