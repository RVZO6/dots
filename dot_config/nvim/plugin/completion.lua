-- blink.cmp (commented out to try built-in completion)
-- vim.pack.add({ { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") } })
--
-- -- setup
-- require("blink.cmp").setup({
-- 	sources = {
-- 		-- add lazydev to your completion providers
-- 		default = { "lazydev", "lsp", "path", "snippets", "buffer" },
-- 		providers = {
-- 			lazydev = {
-- 				name = "LazyDev",
-- 				module = "lazydev.integrations.blink",
-- 				-- make lazydev completions top priority (see `:h blink.cmp`)
-- 				score_offset = 100,
-- 			},
-- 		},
-- 	},
-- })

-- built-in completion (Neovim 0.11+)
vim.o.completeopt = "menuone,noselect,popup"

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client:supports_method("textDocument/completion") then
			-- trigger autocompletion on every printable keypress
			local chars = {}
			for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

-- C-y confirms first item if nothing selected
map("i", "<C-y>", function()
	if vim.fn.pumvisible() == 1 then
		local info = vim.fn.complete_info({ "selected" })
		if info.selected == -1 then
			return "<C-n><C-y>"
		end
	end
	return "<C-y>"
end, { expr = true })
