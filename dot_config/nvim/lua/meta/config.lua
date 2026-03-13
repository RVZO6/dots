---@meta _

---@alias ConfigWhen 'now'|'later'

---@class Config
---@field map fun(mode: string|string[], lhs: string, rhs: string|function, opts?: table)
---@field now fun(f: function)
---@field later fun(f: function)
---@field now_if_args fun(f: function)
---@field new_autocmd fun(event: string|string[], pattern: string|string[]|nil, callback: function, desc?: string, opts?: table)
---@field on_event fun(event: string|string[], fn: function, opts?: table)
---@field on_filetype fun(filetypes: string|string[], fn: function, opts?: table)
---@field on_packchanged fun(plugin_name: string, kinds: string[], callback: function, desc?: string)

---@type Config
Config = {}
