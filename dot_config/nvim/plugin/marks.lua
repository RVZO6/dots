-- marks.nvim
Config.later(function()
  vim.pack.add({ "https://github.com/chentoast/marks.nvim" }, { load = true })

  -- setup
  require("marks").setup({
    builtin_marks = { "<", ">", "^" },
  })
end)
