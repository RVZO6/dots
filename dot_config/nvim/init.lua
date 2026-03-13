-- Bootstrap shared helpers first. The numbered plugin files then consume this API.

if vim.loader then
  vim.loader.enable()
end

vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tohtml = 1
vim.g.loaded_tutor = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

_G.Config = {}
Config.map = vim.keymap.set

-- Load `mini.misc` early so the rest of the config can use safe scheduling helpers.
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

local misc = require('mini.misc')
Config.now = function(f) misc.safely('now', f) end
Config.later = function(f) misc.safely('later', f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later

local function safe_config_call(name, fn, ...)
  local ok, err = pcall(fn, ...)
  if ok then return end

  vim.schedule(function()
    vim.notify(('Config step failed (%s): %s'):format(name, err), vim.log.levels.ERROR)
  end)
end

local augroup = vim.api.nvim_create_augroup('config', {})

-- Shared autocommand helpers keep later files small and consistent.
Config.new_autocmd = function(event, pattern, callback, desc, opts)
  local au_opts = vim.tbl_extend('force', {
    group = augroup,
    pattern = pattern,
    callback = callback,
    desc = desc,
  }, opts or {})
  vim.api.nvim_create_autocmd(event, au_opts)
end

Config.on_event = function(event, fn, opts)
  local options = vim.tbl_extend('force', {
    once = true,
    callback = function(args)
      safe_config_call('event:' .. event, fn, args)
    end,
  }, opts or {})
  vim.api.nvim_create_autocmd(event, options)
end

Config.on_filetype = function(filetypes, fn, opts)
  local options = vim.tbl_extend('force', { pattern = filetypes }, opts or {})
  Config.on_event('FileType', fn, options)
end

-- `after/lsp/*.lua` gets these PackChanged hooks to react to plugin updates.
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  Config.new_autocmd('PackChanged', '*', f, desc)
end
