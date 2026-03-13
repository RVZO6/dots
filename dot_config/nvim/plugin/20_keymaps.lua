local map = vim.keymap.set

local nmap = function(lhs, rhs, desc, opts)
  map('n', lhs, rhs, vim.tbl_extend('force', { desc = desc }, opts or {}))
end

local xmap = function(lhs, rhs, desc, opts)
  map('x', lhs, rhs, vim.tbl_extend('force', { desc = desc }, opts or {}))
end

local tmap = function(lhs, rhs, desc, opts)
  map('t', lhs, rhs, vim.tbl_extend('force', { desc = desc }, opts or {}))
end

local imap = function(lhs, rhs, desc, opts)
  map('i', lhs, rhs, vim.tbl_extend('force', { desc = desc }, opts or {}))
end

local nmap_leader = function(suffix, rhs, desc, opts)
  nmap('<Leader>' .. suffix, rhs, desc, opts)
end

local xmap_leader = function(suffix, rhs, desc, opts)
  xmap('<Leader>' .. suffix, rhs, desc, opts)
end

local edit_plugin_file = function(filename)
  return string.format('<Cmd>edit %s/plugin/%s<CR>', vim.fn.stdpath('config'), filename)
end

local pick_files_in = function(cwd)
  return function()
    MiniPick.builtin.files({}, { source = { cwd = cwd } })
  end
end

local toggle_qf = function()
  local qf = vim.fn.getqflist({ winid = true })
  vim.cmd(qf.winid ~= 0 and 'cclose' or 'copen')
end

local toggle_loc = function()
  local loc = vim.fn.getloclist(0, { winid = true })
  vim.cmd(loc.winid ~= 0 and 'lclose' or 'lopen')
end

local pick_spelling = function()
  MiniExtra.pickers.spellsuggest()
end

-- Global habits and motion tweaks.
map({ 'n', 'x' }, '<Leader>y', '"+y', { desc = 'Yank to system clipboard' })
map({ 'n', 'x' }, '<Leader>d', '"+d', { desc = 'Delete to system clipboard' })

map({ 'n', 'v', 'x' }, ';', ':', { desc = 'Command mode ergonomics' })
map({ 'n', 'v', 'x' }, ':', ';', { desc = 'Swap ; and :' })

nmap('j', "v:count == 0 ? 'gj' : 'j'", 'Move down by screen line', { expr = true, silent = true })
nmap('k', "v:count == 0 ? 'gk' : 'k'", 'Move up by screen line', { expr = true, silent = true })
nmap('<Esc>', '<Cmd>nohlsearch<CR>', 'Clear search highlights')
nmap('<C-d>', '<C-d>zz', 'Scroll down and center')
nmap('<C-u>', '<C-u>zz', 'Scroll up and center')
nmap('n', 'nzzzv', 'Next search result centered')
nmap('N', 'Nzzzv', 'Previous search result centered')
nmap('gK', 'kJ', 'Join line above')
nmap('z=', pick_spelling, 'Spell suggestions')
nmap('[p', '<Cmd>exe "put! " . v:register<CR>', 'Paste above')
nmap(']p', '<Cmd>exe "put " . v:register<CR>', 'Paste below')
nmap('[b', '<Cmd>bprevious<CR>', 'Previous buffer')
nmap(']b', '<Cmd>bnext<CR>', 'Next buffer')
nmap('<C-q>', toggle_qf, 'Toggle quickfix list')
nmap('yp', function()
  vim.fn.setreg('+', vim.fn.expand('%:p:~'))
end, 'Yank buffer path')

xmap('.', 'norm! .', 'Repeat last normal command')
imap('<C-v>', '<C-r><C-p>"', 'Paste literal register text')
tmap('<Esc>', '<C-\\><C-n>', 'Terminal normal mode')

-- Buffer workflow stays primary; tabs are intentionally not part of this config.
nmap_leader('ba', '<Cmd>b#<CR>', 'Alternate buffer')
nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>', 'Delete buffer')
nmap_leader('bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>', 'Delete buffer!')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', 'Wipeout buffer')
nmap_leader('bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', 'Wipeout buffer!')
nmap_leader('bs', function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, 'Scratch buffer')

-- Explorer is a direct action; config editing lives under `<Leader>c`.
nmap_leader('e', '<Cmd>Oil<CR>', 'Open explorer')
nmap_leader('ci', '<Cmd>edit $MYVIMRC<CR>', 'Edit init.lua')
nmap_leader('ck', edit_plugin_file('20_keymaps.lua'), 'Edit keymaps')
nmap_leader('cm', edit_plugin_file('30_mini.lua'), 'Edit mini config')
nmap_leader('cn', '<Cmd>lua MiniNotify.show_history()<CR>', 'Notification history')
nmap_leader('co', edit_plugin_file('10_options.lua'), 'Edit options')
nmap_leader('cp', edit_plugin_file('40_plugins.lua'), 'Edit plugins')

-- Picker entrypoints standardized under `<Leader>f`.
nmap_leader('fb', '<Cmd>Pick buffers<CR>', 'Buffers')
nmap_leader('fc', pick_files_in(vim.fn.stdpath('config')), 'Config files')
nmap_leader('fd', '<Cmd>Pick diagnostic scope="all"<CR>', 'Workspace diagnostics')
nmap_leader('fD', '<Cmd>Pick diagnostic scope="current"<CR>', 'Buffer diagnostics')
nmap_leader('ff', '<Cmd>Pick files<CR>', 'Files')
nmap_leader('fg', '<Cmd>Pick grep_live<CR>', 'Grep')
nmap_leader('fG', '<Cmd>Pick grep pattern="<cword>"<CR>', 'Grep current word')
nmap_leader('fh', '<Cmd>Pick help<CR>', 'Help tags')
nmap_leader('fk', '<Cmd>Pick keymaps<CR>', 'Keymaps')
nmap_leader('fo', '<Cmd>Pick oldfiles<CR>', 'Recent files')
nmap_leader('fr', '<Cmd>Pick resume<CR>', 'Resume last picker')
nmap_leader('fs', '<Cmd>Pick lsp scope="workspace_symbol_live"<CR>', 'Workspace symbols')
nmap_leader('fS', '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Document symbols')

-- LSP actions stay under `<Leader>l` for both normal and visual mode.
nmap_leader('la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'Code actions')
nmap_leader('ld', '<Cmd>lua vim.diagnostic.open_float()<CR>', 'Line diagnostics')
nmap_leader('lf', '<Cmd>lua require("conform").format({ async = true, lsp_format = "fallback" })<CR>', 'Format')
nmap_leader('lh', '<Cmd>lua vim.lsp.buf.hover()<CR>', 'Hover')
nmap_leader('li', '<Cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementation')
nmap_leader('lr', '<Cmd>lua vim.lsp.buf.rename()<CR>', 'Rename')
nmap_leader('lR', '<Cmd>lua vim.lsp.buf.references()<CR>', 'References')
nmap_leader('ls', '<Cmd>lua vim.lsp.buf.definition()<CR>', 'Definition')
nmap_leader('lt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type definition')
xmap_leader('lf', '<Cmd>lua require("conform").format({ async = true, lsp_format = "fallback" })<CR>', 'Format selection')

-- Native package-manager helpers are wrapped in `lua/pack.lua`.
nmap_leader('pc', function() require('pack').clean() end, 'Pack clean')
nmap_leader('pl', function() require('pack').list() end, 'Pack list')
nmap_leader('pu', function() require('pack').update() end, 'Pack update')

-- Spelling helpers complement the built-in `[s`, `]s`, and mini.basics toggles.
nmap_leader('sa', '1z=', 'Apply first spelling suggestion')
nmap_leader('sp', pick_spelling, 'Pick spelling suggestion')

-- Terminal toggle is exposed both as a leader action and a direct control key.
nmap_leader('tt', function()
  require('terminal').toggle()
end, 'Toggle terminal')

-- UI toggles that are local enough to flip during editing.
nmap('\\m', function()
  require('render-markdown').buf_toggle()
end, 'Toggle markdown render')
nmap('\\q', toggle_qf, 'Toggle quickfix list')
nmap('\\Q', toggle_loc, 'Toggle location list')
nmap('\\t', function()
  Config.toggle_buffer_bar()
end, 'Toggle buffer bar')
-- nmap_leader('us', function()
--   vim.wo.spell = not vim.wo.spell
-- end, 'Toggle spell')
-- nmap_leader('uw', function()
--   vim.wo.wrap = not vim.wo.wrap
-- end, 'Toggle wrap')

-- Direct terminal toggle bindings for normal/insert/terminal mode.
map({ 'n', 'i', 't' }, '<C-/>', function()
  require('terminal').toggle()
end, { desc = 'Toggle terminal' })
map({ 'n', 'i', 't' }, '<C-_>', function()
  require('terminal').toggle()
end, { desc = 'Toggle terminal' })

-- Snippet and completion glue sits here because it is mostly keymap behavior.
map({ 'i', 's' }, '<C-j>', function()
  MiniSnippets.expand()
end, { desc = 'Expand snippet' })
map({ 'i', 's' }, '<C-l>', function()
  if MiniSnippets.session.get() then
    MiniSnippets.session.jump('next')
  else
    return '<Right>'
  end
end, { desc = 'Next snippet tabstop', expr = true })
map({ 'i', 's' }, '<C-h>', function()
  if MiniSnippets.session.get() then
    MiniSnippets.session.jump('prev')
  else
    return '<Left>'
  end
end, { desc = 'Previous snippet tabstop', expr = true })
imap('<CR>', function()
  if vim.fn.pumvisible() == 1 then return '<C-y>' end
  return MiniPairs.cr()
end, 'Accept completion or newline with pairs', { expr = true })
