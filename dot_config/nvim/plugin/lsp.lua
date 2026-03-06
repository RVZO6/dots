local lsp_ready = false

local function setup_lsp()
	if lsp_ready then
		return
	end
	lsp_ready = true

	vim.pack.add({
		'https://github.com/mason-org/mason.nvim',
		'https://github.com/mason-org/mason-lspconfig.nvim',
		'https://github.com/neovim/nvim-lspconfig',
	}, { load = true })
	vim.pack.add({ 'https://github.com/b0o/SchemaStore.nvim' }, { load = true })

	local lsp_servers = {
		"lua_ls",
		"tailwindcss",
		"autotools_ls",
		"vtsls",
		"bashls",
		"jsonls",
		"clangd",
		"gopls",
		"basedpyright",
		"html",
		"emmet_language_server",
	}

	require("mason").setup()
	require("mason-lspconfig").setup({
		automatic_enable = false,
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			Config.map("n", "<C-s>", function()
				vim.lsp.buf.signature_help()
			end, { buffer = args.buf, desc = "LSP signature help" })
		end,
	})

	vim.lsp.enable(lsp_servers)
end

Config.ensure_lsp = setup_lsp
Config.now_if_args(setup_lsp)
