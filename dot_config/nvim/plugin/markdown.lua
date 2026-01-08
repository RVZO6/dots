-- markdown stuff
Config.later(function()
  vim.pack.add({ 'https://github.com/bullets-vim/bullets.vim',
    'https://github.com/MeanderingProgrammer/render-markdown.nvim' }, { load = true })

  require("render-markdown").setup({
		latex = {
			enabled = true
		},
    code = {
      -- language_border = "",
      -- disable_background = true
    },
  })
end)
