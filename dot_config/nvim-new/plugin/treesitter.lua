-- treesitter
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = 'main' },
})

-- Treesitter parsers to install
local ts_parsers = { "bash", "c", "cpp", "lua", "python", "rust", }

-- setup
local nts = require("nvim-treesitter")
nts.install(ts_parsers)

-- autocmds
-- Auto-update parsers when plugins change
vim.api.nvim_create_autocmd('PackChanged', {
	callback = function() nts.update() end
})

-- Enable treesitter highlighting and indents
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local filetype = args.match
		local lang = vim.treesitter.language.get_lang(filetype)
		if lang and vim.treesitter.language.add(lang) then -- Check lang exists first
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			vim.treesitter.start()
		end
	end
})
