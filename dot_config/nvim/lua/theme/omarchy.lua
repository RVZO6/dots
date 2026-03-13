local M = {}
local util = require('theme.util')

-- Omarchy writes its current palette to a Lua file outside this config.
local function palette_paths()
  return {
    vim.fn.stdpath('config') .. '/lua/omarchy_theme.lua',
    vim.fn.expand('~/.config/nvim/lua/omarchy_theme.lua'),
  }
end

local function load_palette()
  for _, path in ipairs(palette_paths()) do
    if vim.fn.filereadable(path) == 1 then return dofile(path) end
  end

  vim.notify('Omarchy theme palette not found.', vim.log.levels.WARN)
  return nil
end

-- Match the old Omarchy setup: clear the groups that should stay transparent.
local function apply_overrides()
  util.clear_backgrounds({
    'LineNr',
    'CursorLineNr',
    'LineNrAbove',
    'LineNrBelow',
    'Number',
    'Normal',
    'NormalFloat',
    'NormalNC',
    'SignColumn',
    'CursorLine',
    'Folded',
    'EndOfBuffer',
    'PaneClose',
    'GitSignsAdd',
    'GitSignsChange',
    'GitSignsDelete',
    'GitSignsUntracked',
    'GitSignsTopdelete',
    'GitSignsChangedelete',
    'SnacksPickerNormal',
    'SnacksPickerTitle',
    'SnacksPickerSelected',
    'SnacksPickerMatching',
    'SnacksPickerBorder',
    'SnacksPickerPrompt',
    'StatusLine',
    'StatusLineNC',
  })
end

-- Omarchy clears `CursorLine`, so picker selection needs a local replacement.
local function apply_picker_overrides(palette)
  vim.api.nvim_set_hl(0, 'MiniPickMatchCurrent', {
    fg = nil,
    bg = palette.base02,
    ctermbg = 'NONE',
  })
  vim.api.nvim_set_hl(0, 'MiniPickPreviewLine', {
    fg = nil,
    bg = palette.base02,
    ctermbg = 'NONE',
  })
end

local function apply_react_link_overrides()
  local hl = vim.api.nvim_get_hl(0, { name = '@markup.link.label' })
  hl.underline = false
  hl.undercurl = false
  hl.cterm = hl.cterm or {}
  hl.cterm.underline = false

  vim.api.nvim_set_hl(0, '@markup.link.label.tsx', hl)
  vim.api.nvim_set_hl(0, '@markup.link.label.jsx', hl)
end

-- Reapply the full palette stack whenever Omarchy rotates themes.
local function apply()
  local palette = load_palette()
  if not palette then return end

  require('mini.base16').setup({ palette = palette })
  apply_overrides()
  apply_picker_overrides(palette)
  apply_react_link_overrides()
end

function M.setup()
  apply()
  Config.new_autocmd('Signal', 'SIGUSR1', function()
    apply()
  end, 'Reload Omarchy palette')
end

return M
