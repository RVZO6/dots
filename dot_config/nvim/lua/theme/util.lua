local M = {}

-- Preserve the rest of a highlight group while forcing transparency.
function M.clear_backgrounds(groups)
  for _, group in ipairs(groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
    if ok and type(hl) == 'table' then
      hl.bg = 'NONE'
      hl.ctermbg = 'NONE'
      pcall(vim.api.nvim_set_hl, 0, group, hl)
    else
      pcall(vim.api.nvim_set_hl, 0, group, { bg = 'NONE', ctermbg = 'NONE' })
    end
  end
end

-- Read a group's foreground with a safe fallback for theme-specific overrides.
function M.get_fg(name, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
  if ok and type(hl) == 'table' and hl.fg then return hl.fg end
  return fallback
end

return M
