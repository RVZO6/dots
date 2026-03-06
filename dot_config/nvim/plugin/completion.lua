local blink_ready = false

local function setup_blink()
	if blink_ready then
		return
	end
	blink_ready = true

	vim.pack.add({
		{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	}, { load = true })

	local ok, blink = pcall(require, "blink.cmp")
	if not ok then
		return
	end

	blink.setup({
		signature = {
			enabled = false,
		},
		keymap = { preset = "default" },
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},
	})
end

Config.on_event("InsertEnter", setup_blink)
Config.on_event("CmdlineEnter", setup_blink)
