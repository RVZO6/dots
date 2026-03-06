-- markdown stuff
Config.now_if_args(function()
  vim.g.bullets_enabled_file_types = { "markdown", "markdown.chezmoitmpl", "text", "gitcommit" }
  vim.pack.add({ 'https://github.com/bullets-vim/bullets.vim' }, { load = true })

  local ft = vim.bo.filetype
  if ft == "markdown" or ft == "markdown.chezmoitmpl" then
    vim.schedule(function()
      vim.cmd('doautocmd <nomodeline> FileType')
    end)
  end
end)

Config.later(function()
  vim.pack.add({ 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }, { load = true })

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
