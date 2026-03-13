local add = vim.pack.add
local now_if_args, later = Config.now_if_args, Config.later

-- Treesitter and textobjects are needed early when opening files directly.
now_if_args(function()
  local ts_update = function() vim.cmd('TSUpdate') end
  Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

  add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  local languages = {
    'bash',
    'c',
    'cpp',
    'css',
    'html',
    'javascript',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'rust',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
  }

  local missing = vim.tbl_filter(function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end, languages)

  if #missing > 0 then require('nvim-treesitter').install(missing) end

  require('nvim-treesitter-textobjects').setup({
    move = { set_jumps = true },
  })

  local move = require('nvim-treesitter-textobjects.move')
  local goto_next_start = function(query)
    return function() move.goto_next_start(query, 'textobjects') end
  end
  local goto_next_end = function(query)
    return function() move.goto_next_end(query, 'textobjects') end
  end
  local goto_prev_start = function(query)
    return function() move.goto_previous_start(query, 'textobjects') end
  end
  local goto_prev_end = function(query)
    return function() move.goto_previous_end(query, 'textobjects') end
  end

  Config.map({ 'n', 'x', 'o' }, ']f', goto_next_start('@function.outer'), { desc = 'Next function start' })
  Config.map({ 'n', 'x', 'o' }, ']c', goto_next_start('@class.outer'), { desc = 'Next class start' })
  Config.map({ 'n', 'x', 'o' }, ']a', goto_next_start('@parameter.inner'), { desc = 'Next parameter start' })
  Config.map({ 'n', 'x', 'o' }, ']F', goto_next_end('@function.outer'), { desc = 'Next function end' })
  Config.map({ 'n', 'x', 'o' }, ']C', goto_next_end('@class.outer'), { desc = 'Next class end' })
  Config.map({ 'n', 'x', 'o' }, ']A', goto_next_end('@parameter.inner'), { desc = 'Next parameter end' })
  Config.map({ 'n', 'x', 'o' }, '[f', goto_prev_start('@function.outer'), { desc = 'Previous function start' })
  Config.map({ 'n', 'x', 'o' }, '[c', goto_prev_start('@class.outer'), { desc = 'Previous class start' })
  Config.map({ 'n', 'x', 'o' }, '[a', goto_prev_start('@parameter.inner'), { desc = 'Previous parameter start' })
  Config.map({ 'n', 'x', 'o' }, '[F', goto_prev_end('@function.outer'), { desc = 'Previous function end' })
  Config.map({ 'n', 'x', 'o' }, '[C', goto_prev_end('@class.outer'), { desc = 'Previous class end' })
  Config.map({ 'n', 'x', 'o' }, '[A', goto_prev_end('@parameter.inner'), { desc = 'Previous parameter end' })

  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end

  Config.new_autocmd('FileType', filetypes, function(ev)
    local ft = vim.bo[ev.buf].filetype
    if ft:find('chezmoitmpl') then return end

    local lang = vim.treesitter.language.get_lang(ft)
    if lang then
      pcall(vim.treesitter.language.add, lang)
      pcall(vim.treesitter.start, ev.buf, lang)
    end
  end, 'Start tree-sitter')
end)

-- LSP stack: Mason installs tools, LazyDev enriches Lua, native LSP enables servers.
now_if_args(function()
  add({
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    'https://github.com/b0o/SchemaStore.nvim',
    'https://github.com/folke/lazydev.nvim',
  })

  local servers = {
    'bashls',
    'clangd',
    'cssls',
    'emmet_language_server',
    'html',
    'jsonls',
    'lua_ls',
    'basedpyright',
    'tailwindcss',
    'vtsls',
  }
  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = servers,
    automatic_enable = false,
  })

  local tool_installer_ensure = vim.list_extend(vim.deepcopy(servers), {
    'clang-format',
    'prettier',
    'ruff',
    'shfmt',
    'stylua',
  })

  require('mason-tool-installer').setup({
    ensure_installed = tool_installer_ensure,
    auto_update = false,
    run_on_start = true,
    start_delay = 250,
    debounce_hours = 8,
  })

  require('lazydev').setup({
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      'mini.nvim',
    },
  })

  vim.lsp.enable(servers)
end)

-- Formatting stays separate from the LSP bootstrapping above.
later(function()
  add({ 'https://github.com/stevearc/conform.nvim' })

  require('conform').setup({
    notify_on_error = true,
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      bash = { 'shfmt' },
      c = { 'clang_format' },
      cpp = { 'clang_format' },
      css = { 'prettier' },
      html = { 'prettier' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      lua = { 'stylua' },
      markdown = { 'prettier' },
      python = { 'ruff_format' },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      yaml = { 'prettier' },
      zsh = { 'shfmt' },
    },
  })
end)

-- External snippet collection layered under your own mini.snippets files.
later(function()
  add({ 'https://github.com/rafamadriz/friendly-snippets' })
end)

-- Oil is the only file explorer in this config, so it gets its own block.
later(function()
  add({
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
  })

  require('oil').setup({
    columns = { 'icon' },
    default_file_explorer = true,
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = true,
    },
    keymaps = {
      ['q'] = { 'actions.close', mode = 'n' },
      ['g.'] = 'actions.toggle_hidden',
    },
    float = {
      max_width = 40,
      max_height = 25,
    },
  })

  Config.new_autocmd('VimResized', '*', function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local config = vim.api.nvim_win_get_config(win)
      local buf = vim.api.nvim_win_get_buf(win)
      if config.relative ~= '' and vim.bo[buf].filetype == 'oil' then
        config.row = math.floor((vim.o.lines - config.height) / 2)
        config.col = math.floor((vim.o.columns - config.width) / 2)
        vim.api.nvim_win_set_config(win, config)
      end
    end
  end, 'Recenter floating oil windows')
end)

-- Markdown extras stay filetype-lazy.
Config.on_filetype({ 'gitcommit', 'markdown', 'text' }, function()
  add({ 'https://github.com/bullets-vim/bullets.vim' })
  vim.g.bullets_enabled_file_types = { 'gitcommit', 'markdown', 'text' }
end)

Config.on_filetype('markdown', function()
  add({ 'https://github.com/MeanderingProgrammer/render-markdown.nvim' })

  require('render-markdown').setup({
    file_types = { 'markdown' },
    latex = { enabled = true },
  })
end)
