local M = {}

function M.setup()
  if vim.env.NVIM_DISABLE_COLORSCHEME == '1' then return end

  -- macOS uses the local Vague setup; Omarchy uses the external palette file.
  local has_omarchy = vim.fn.isdirectory(vim.fn.expand('~/.config/omarchy')) == 1
  if has_omarchy then
    require('theme.omarchy').setup()
  else
    require('theme.macos').setup()
  end
end

return M
