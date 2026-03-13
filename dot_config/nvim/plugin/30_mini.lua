local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

-- Theme first so later UI modules inherit the right highlights.
now(function()
  require('theme').setup()
end)

-- `mini.basics` fills in a few ergonomic defaults without owning all options.
now(function()
  require('mini.basics').setup({
    options = { basic = false },
    mappings = {
      windows = true,
      move_with_alt = true,
    },
  })
end)

-- Icons need to be available early because multiple plugins render files/kinds.
now(function()
  local ext3_blocklist = { scm = true, txt = true, yml = true }
  local ext4_blocklist = { json = true, yaml = true }
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
    end,
  })

  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)

-- Always-on UI pieces.
now(function() require('mini.notify').setup() end)
now(function() require('mini.statusline').setup() end)
now(function()
  require('mini.tabline').setup()

  local function update_buffer_bar()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == '' and vim.api.nvim_buf_get_name(buf) == '' then
        vim.bo[buf].buflisted = false
      end
    end

    local listed = 0
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
        listed = listed + 1
      end
    end

    if vim.g.buffer_bar_manual_hidden then
      vim.o.showtabline = 0
    else
      vim.o.showtabline = listed >= 2 and 2 or 0
    end
  end

  Config.update_buffer_bar = update_buffer_bar
  Config.toggle_buffer_bar = function()
    vim.g.buffer_bar_manual_hidden = not vim.g.buffer_bar_manual_hidden
    Config.update_buffer_bar()
    local state = vim.g.buffer_bar_manual_hidden and 'off' or 'on'
    vim.api.nvim_echo({ { 'tabline ' .. state } }, false, {})
  end

  update_buffer_bar()
  Config.new_autocmd({ 'BufAdd', 'BufDelete', 'BufEnter' }, '*', update_buffer_bar, 'Manage buffer bar visibility and unnamed buffers')
end)

-- Completion is only worth paying for early when we launched straight into files.
now_if_args(function()
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end

  require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = process_items,
    },
  })

  Config.new_autocmd('LspAttach', nil, function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  end, "Set 'omnifunc' for LSP completion")

  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

-- Session helpers that should feel invisible once enabled.
now_if_args(function()
  require('mini.misc').setup()
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)

-- Later-loaded Mini modules keep startup lighter.
later(function() require('mini.extra').setup() end)

-- Command-line tweaks: autocomplete `:` completion as you type.
later(function() require('mini.cmdline').setup() end)

-- Custom textobjects blend your old config with MiniMax defaults.
later(function()
  local ai = require('mini.ai')
  ai.setup({
    custom_textobjects = {
      g = MiniExtra.gen_ai_spec.buffer(),
      f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
      c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
      o = ai.gen_spec.treesitter({
        a = { '@block.outer', '@loop.outer', '@conditional.outer' },
        i = { '@block.inner', '@loop.inner', '@conditional.inner' },
      }),
    },
  })
end)

later(function() require('mini.bufremove').setup() end)

-- Which-key style clues live next to `mini.clue`, not in the keymap file.
later(function()
  local miniclue = require('mini.clue')
  local leader_group_clues = {
    { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
    { mode = 'n', keys = '<Leader>c', desc = '+Config' },
    { mode = 'n', keys = '<Leader>f', desc = '+Find' },
    { mode = 'n', keys = '<Leader>l', desc = '+Language' },
    { mode = 'n', keys = '<Leader>p', desc = '+Pack' },
    { mode = 'n', keys = '<Leader>s', desc = '+Spell' },
    { mode = 'n', keys = '<Leader>t', desc = '+Terminal' },
    { mode = 'n', keys = '<Leader>u', desc = '+UI/Toggle' },
    { mode = 'n', keys = '<Leader>y', desc = '+Yank' },
    { mode = 'x', keys = '<Leader>l', desc = '+Language' },
  }

  miniclue.setup({
    clues = {
      leader_group_clues,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = { 'n', 'x' }, keys = '<Leader>' },
      { mode = 'n', keys = '\\' },
      { mode = { 'n', 'x' }, keys = '[' },
      { mode = { 'n', 'x' }, keys = ']' },
      { mode = 'i', keys = '<C-x>' },
      { mode = { 'n', 'x' }, keys = 'g' },
      { mode = { 'n', 'x' }, keys = "'" },
      { mode = { 'n', 'x' }, keys = '`' },
      { mode = { 'n', 'x' }, keys = '"' },
      { mode = { 'i', 'c' }, keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },
      { mode = { 'n', 'x' }, keys = 'z' },
    },
  })
end)

-- Pairs, picker, and snippets are independent editing layers.
later(function()
  require('mini.pairs').setup({ modes = { command = true } })
end)

later(function()
  require('mini.pick').setup()
end)

later(function()
  local snippets = require('mini.snippets')
  local config_path = vim.fn.stdpath('config')

  snippets.setup({
    snippets = {
      snippets.gen_loader.from_file(config_path .. '/snippets/global.json'),
      snippets.gen_loader.from_lang(),
    },
  })
end)
