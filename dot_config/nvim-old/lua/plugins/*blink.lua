return {
  "saghen/blink.cmp",
  opts = {
    -- 1. Your existing visual styling
    completion = {
      menu = {
        border = "rounded",
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
      },
    },

    -- 2. The logic for Manual Snippets vs Automatic LSP
    sources = {
      providers = {
        snippets = {
          -- Only show snippets if completion was triggered manually (e.g. <C-space>)
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind == "manual"
          end,
          score_offset = 100, -- Optional: Puts snippets at the top when they are visible
        },
      },
    },

    -- 3. The trigger keybind
    keymap = {
      preset = "default",
      -- Pressing <C-space> will trigger the manual mode and show your snippets
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    },
  },
}
