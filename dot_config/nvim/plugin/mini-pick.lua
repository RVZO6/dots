-- mini.pick
Config.later(function()
  -- setup
  require('mini.icons').setup()

  -- centre window
  require('mini.extra').setup(require('mini.pick').setup({
    window = {
      config = function()
        local height = math.floor(0.6 * vim.o.lines)
        local width = math.floor(0.4 * vim.o.columns)
        -- Apply minimum constraints
        local min_height = 10
        local min_width = 40
        height = math.max(height, min_height)
        width = math.max(width, min_width)
        return {
          anchor = 'NW',
          height = height,
          width = width,
          row = math.floor(0.5 * (vim.o.lines - height)),
          col = math.floor(0.5 * (vim.o.columns - width)),
        }
      end
    }
  }))
end)

-- keymaps
Config.map({ "n", "v", "x" }, "<leader><space>",
  function() MiniPick.builtin.files() end, { desc = "Pick files" })

-- Config.map({ "n", "v", "x" }, "<leader>fc",
-- 	function()
-- 		MiniPick.builtin.files(nil, {
-- 			source = { cwd = vim.fn.stdpath('config'), name = 'Config' }
-- 		})
-- 	end, { desc = "[F]ind [c]onfig" })

Config.map({ "n", "v", "x" }, "<leader>sk",
  function() MiniExtra.pickers.keymaps() end, { desc = "[S]earch [k]eymaps" })

Config.map({ "n", "v", "x" }, "<leader>sh",
  function() MiniPick.builtin.help() end, { desc = "[S]earch [h]elp" })

Config.map({ "n", "v", "x" }, "<leader>sH",
  function() MiniExtra.pickers.hl_groups() end, { desc = "[S]earch [H]ighlights" })
