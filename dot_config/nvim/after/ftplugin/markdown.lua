local is_float = vim.api.nvim_win_get_config(0).relative ~= ''
local is_real_file = vim.bo.buftype == '' and not is_float

vim.wo.wrap = true
vim.wo.spell = is_real_file
vim.opt_local.conceallevel = 2
vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

pcall(vim.keymap.del, 'n', 'gO', { buffer = 0 })
