local M = {}

local function declared_plugins()
  local declared = {}
  local config_root = vim.fn.stdpath('config')
  local lua_files = vim.fn.globpath(config_root, '**/*.lua', false, true)

  for _, path in ipairs(lua_files) do
    local lines = vim.fn.readfile(path)
    for _, text in ipairs(lines) do
      for repo in text:gmatch('https://github%.com/[%w%._%-]+/([%w%._%-]+)') do
        declared[repo:gsub('%.git$', '')] = true
      end
    end
  end

  return declared
end

-- "Unused" should mean "installed on disk but no longer declared in config".
local function unused_plugins()
  local unused = {}
  local declared = declared_plugins()

  for _, plugin in ipairs(vim.pack.get()) do
    local name = plugin.spec and plugin.spec.name or nil
    if name and not declared[name] then table.insert(unused, name) end
  end

  table.sort(unused)
  return unused
end

-- Remove plugins that are present on disk but no longer active in the config.
function M.clean()
  local unused = unused_plugins()
  if #unused == 0 then
    print('No unused plugins.')
    return
  end

  local choice = vim.fn.confirm('Remove unused plugins?', '&Yes\n&No', 2)
  if choice == 1 then vim.pack.del(unused) end
end

-- Show plugins through `vim.ui.select()` so the picker can stay frontend-agnostic.
function M.list()
  local plugins = vim.pack.get()
  if not plugins or #plugins == 0 then
    print('No plugins found.')
    return
  end

  local unused_set = {}
  for _, name in ipairs(unused_plugins()) do
    unused_set[name] = true
  end

  table.sort(plugins, function(a, b)
    local an = (a.spec and a.spec.name) or ''
    local bn = (b.spec and b.spec.name) or ''
    local au = unused_set[an] and 1 or 0
    local bu = unused_set[bn] and 1 or 0
    if au ~= bu then return au > bu end
    return an < bn
  end)

  vim.ui.select(plugins, {
    prompt = 'VimPack plugins',
    format_item = function(plugin)
      local name = (plugin.spec and plugin.spec.name) or '(unknown)'
      return unused_set[name] and (name .. ' (unused)') or name
    end,
  }, function(choice)
    if not choice then return end

    local name = (choice.spec and choice.spec.name) or '(unknown)'
    print(unused_set[name] and (name .. ' (unused)') or name)
  end)
end

-- Thin wrapper so keymaps do not need to know the `vim.pack` API details.
function M.update()
  vim.pack.update()
end

return M
