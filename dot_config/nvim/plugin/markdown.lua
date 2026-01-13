-- markdown stuff
Config.later(function()
  vim.pack.add({ 'https://github.com/bullets-vim/bullets.vim',
    'https://github.com/MeanderingProgrammer/render-markdown.nvim' }, { load = true })

  -- pcall(function()
  --   vim.treesitter.language.register('markdown', 'markdown.chezmoitmpl')
  -- end)

  require("render-markdown").setup({
    file_types = { "markdown", "markdown.chezmoitmpl" },
    latex = {
      enabled = true,
    },
    code = {
      -- language_border = "",
      -- disable_background = true
    },
  })
end)
