-- MAYBE Config.now_if_args?? because if i go right into a file. 
-- luasnip
Config.later(function()
  vim.pack.add({ "https://github.com/L3MON4D3/LuaSnip" }, { load = true })

  -- setup
  local ls = require("luasnip")
  ls.setup({ enable_autosnippets = true })
  require("luasnip.loaders.from_lua").load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })

  -- keymaps
  Config.map({ "i", "s" }, "<C-e>", function() ls.expand_or_jump() end, { silent = true })
  Config.map({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
  -- Config.map({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })
end)
