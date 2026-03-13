vim.g.mapleader = ' '

-- Core runtime behavior.
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- Editor state and persistence.
vim.o.swapfile = false
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"
-- '100   remember marks for the last 100 files
-- <50    save up to 50 lines per register
-- s10    skip registers larger than 10kb
-- :1000  save last 1000 command-line history entries
-- /100   save last 100 search history entries
-- @100   save last 100 input-line history entries
-- h      disable hlsearch on shada load
vim.o.updatetime = 250

-- Window and UI defaults.
vim.o.breakindentopt = 'list:-1'
vim.o.cursorlineopt = 'screenline,number'
vim.o.laststatus = 3
vim.o.signcolumn = 'yes'
vim.o.relativenumber = true
vim.o.pumborder = 'single'
vim.o.winborder = 'single'
vim.o.pumheight = 10
vim.o.pummaxwidth = 100
vim.o.scrolloff = 8
vim.o.shortmess = 'CFOSWaco'

-- remove end of buffer ~ fillchar
vim.o.fillchars = 'eob: '

-- Editing and text behavior.
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.formatoptions = 'rqnl1j'
-- word = a-Z, 0-9, _, extended latin chars, and - (dash)
vim.o.iskeyword = '@,48-57,_,192-255,-'
vim.o.shiftwidth = 2
vim.o.spell = false
-- for spell checking, camelcased compound words are treated as two words
vim.o.spelloptions = 'camel'
vim.o.tabstop = 2

-- Built-in completion behavior used by `mini.completion`.
vim.o.complete = '.,w,b,kspell'
vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'
vim.o.completetimeout = 100

-- Small quality-of-life autocommands.
local formatoptions_fix = function()
  vim.cmd('setlocal formatoptions-=c formatoptions-=o')
end
Config.new_autocmd('FileType', nil, formatoptions_fix, "Keep 'o' from continuing comments")

Config.new_autocmd('InsertEnter', '*', function()
  vim.cmd('nohlsearch')
end, 'Clear search highlight on insert')

Config.new_autocmd('BufWinEnter', '*', function()
  if vim.bo.buftype == 'help' then vim.cmd('wincmd L') end
end, 'Open help windows on the right')

-- Keep diagnostics readable without turning every line into UI noise.
local diagnostic_opts = {
  signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },
  underline = { severity = { min = 'HINT', max = 'ERROR' } },
  virtual_lines = false,
  virtual_text = {
    current_line = true,
    severity = { min = 'ERROR', max = 'ERROR' },
  },
  update_in_insert = false,
}

Config.later(function() vim.diagnostic.config(diagnostic_opts) end)
