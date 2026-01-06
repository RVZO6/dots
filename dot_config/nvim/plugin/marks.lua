-- marks.nvim
vim.pack.add({ "https://github.com/chentoast/marks.nvim" })

-- setup
require("marks").setup({
	builtin_marks = { "<", ">", "^" },
})
