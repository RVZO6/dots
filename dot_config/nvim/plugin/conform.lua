local conform_ready = false

local function setup_conform()
	if conform_ready then
		return
	end
	conform_ready = true

	vim.pack.add({
		"https://github.com/stevearc/conform.nvim",
	}, { load = true })

	require("conform").setup({
		notify_on_error = true,
		formatters_by_ft = {
			lua = { "stylua" },
			bash = { "shfmt" },
			sh = { "shfmt" },
			zsh = { "shfmt" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			["markdown.chezmoitmpl"] = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			go = { "gofumpt" },
			rust = { "rustfmt" },
			python = { "ruff_format", "black" },
		},
	})
end

Config.ensure_conform = setup_conform
Config.on_event("InsertEnter", setup_conform)
Config.on_event("CmdlineEnter", setup_conform)
