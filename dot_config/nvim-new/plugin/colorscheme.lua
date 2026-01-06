-- colorscheme
-- vim.pack.add({ "https://github.com/mellow-theme/mellow.nvim" })
-- vim.g.mellow_transparent = true
-- vim.cmd([[ colorscheme mellow ]])
-- vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })

vim.pack.add({
	"https://github.com/vague-theme/vague.nvim",
})

-- setup
require("vague").setup({
	transparent = true
})

vim.cmd("colorscheme vague")
vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })
