-- LSP
Config.later(function()
  vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' }, { load = true })

  -- LSP servers to enable
  local lsp_servers = { "lua_ls", "clangd", "gopls", "basedpyright" }

  -- setup
  vim.lsp.enable(lsp_servers)
end)
