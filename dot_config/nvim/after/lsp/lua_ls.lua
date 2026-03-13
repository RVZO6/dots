return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  on_attach = function(client, _)
    if client.server_capabilities.completionProvider then
      client.server_capabilities.completionProvider.triggerCharacters = { '.', ':', '#', '(' }
    end
  end,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'Config' },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.fn.stdpath('config') .. '/lua/meta',
        },
      },
    },
  },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
}
