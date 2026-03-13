local M = {}

local util = require('theme.util')

-- JSX/TSX link captures can span whitespace, so keep the color but drop underline.
local function apply_react_link_overrides()
  local hl = vim.api.nvim_get_hl(0, { name = '@markup.link.label' })
  hl.underline = false
  hl.undercurl = false
  hl.cterm = hl.cterm or {}
  hl.cterm.underline = false

  vim.api.nvim_set_hl(0, '@markup.link.label.tsx', hl)
  vim.api.nvim_set_hl(0, '@markup.link.label.jsx', hl)
end

-- Keep the buffer bar readable without introducing a larger global highlight policy.
local function apply_ui_overrides()
  local normal_fg = util.get_fg('Normal', 0xdddddd)
  local muted_fg = util.get_fg('Comment', normal_fg)
  local accent_fg = util.get_fg('Title', normal_fg)

  vim.api.nvim_set_hl(0, 'MiniTablineCurrent', {
    fg = accent_fg,
    bg = 'NONE',
    ctermbg = 'NONE',
    bold = true,
  })
end

function M.setup()
  vim.pack.add({ 'https://github.com/vague-theme/vague.nvim' })
  require('vague').setup({ transparent = true })
  vim.cmd.colorscheme('vague')
  apply_react_link_overrides()
  apply_ui_overrides()
end

return M
