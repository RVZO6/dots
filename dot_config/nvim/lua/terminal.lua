local M = {}

-- One reusable terminal buffer shown in a bottom split on demand.
local state = {
  buf = nil,
  win = nil,
  height = 12,
}

local function is_valid(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function ensure_buffer()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then return state.buf end

  -- First open creates the terminal buffer and remembers it for later toggles.
  vim.cmd('botright ' .. state.height .. 'split')
  vim.cmd('terminal')

  state.win = vim.api.nvim_get_current_win()
  state.buf = vim.api.nvim_get_current_buf()

  vim.bo[state.buf].buflisted = false
  vim.bo[state.buf].bufhidden = 'hide'

  return state.buf
end

function M.toggle()
  -- If the terminal window is already visible, hide just that window.
  if is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
    state.win = nil
    return
  end

  local buf = ensure_buffer()

  -- Reopen the saved terminal buffer in a fresh bottom split when needed.
  if state.buf == buf and not is_valid(state.win) then
    vim.cmd('botright ' .. state.height .. 'split')
    state.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(state.win, buf)
  end

  vim.cmd('startinsert')
end

return M
