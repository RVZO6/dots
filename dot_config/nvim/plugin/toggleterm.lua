local term_buf = nil
local term_win = nil

local function toggle_terminal()
	-- -- If terminal window is visible, hide it
	-- if term_win and vim.api.nvim_win_is_valid(term_win) then
	-- 	vim.api.nvim_win_hide(term_win)
	-- 	term_win = nil
	-- 	return
	-- end
	--
	-- -- If buffer doesn't exist, create it
	-- if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
	-- 	vim.cmd('botright 10split')
	-- 	vim.cmd('terminal')
	-- 	term_buf = vim.api.nvim_get_current_buf()
	-- 	vim.bo[term_buf].buflisted = false
	-- else
	-- 	-- Buffer exists, just show it
	-- 	vim.cmd('botright 10split')
	-- 	vim.api.nvim_set_current_buf(term_buf)
	-- end
	--
	-- term_win = vim.api.nvim_get_current_win()
	-- vim.cmd('startinsert')
	Snacks.terminal.toggle()
end

-- Ghostty (Kitty/CSI-u) reports Ctrl+/ as <C-/>; tmux often normalizes it to <C-_>.
Config.map({ 'n', 'i', 't' }, '<C-/>', toggle_terminal, { desc = 'Toggle terminal' })
Config.map({ 'n', 'i', 't' }, '<C-_>', toggle_terminal, { desc = 'Toggle terminal' })
