-- mini.ai
Config.later(function()
	vim.pack.add({"https://github.com/nvim-mini/mini.ai"})
  local ai = require("mini.ai")
  local extra = require("mini.extra")
  ai.setup({
    n_lines = 500,
    custom_textobjects = {
      -- g: Entire buffer (Global) - "yig" = Yank Inner Global (everything)
      g = extra.gen_ai_spec.buffer(),

      -- f: Function (using Treesitter)
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),

      -- c: Class (using Treesitter)
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),

      -- o: Block/Control flow (using Treesitter) - "Block/Other"
      o = ai.gen_spec.treesitter({
        a = { "@block.outer", "@loop.outer", "@conditional.outer" },
        i = { "@block.inner", "@loop.inner", "@conditional.inner" },
      }),
    },
  })
end)
