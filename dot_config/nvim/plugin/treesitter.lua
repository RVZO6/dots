-- treesitter
Config.now_if_args(function()
	vim.pack.add({
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter",             version = 'main' },
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = 'main' },
	}, { load = true })

	-- Treesitter parsers to install
	local ts_parsers = { "bash", "c", "cpp", "lua", "python", "rust", }

	-- Setup nvim-treesitter
	local nts = require("nvim-treesitter")
	local missing_parsers = {}
	for _, lang in ipairs(ts_parsers) do
		if #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 then
			table.insert(missing_parsers, lang)
		end
	end
	if #missing_parsers > 0 then
		nts.install(missing_parsers)
	end

	-- Setup nvim-treesitter-textobjects (only for movement, mini.ai handles selection)
	require("nvim-treesitter-textobjects").setup({
		move = {
			set_jumps = true, -- whether to set jumps in the jumplist
		},
	})

	-- Movement keymaps (normal, visual, and operator-pending modes)
	-- Note: Text object selection (af, if, ac, ic, etc.) is handled by mini.ai
	local move = require("nvim-treesitter-textobjects.move")

	local goto_next_start = function(query)
		return function()
			move.goto_next_start(query, "textobjects")
		end
	end

	local goto_next_end = function(query)
		return function()
			move.goto_next_end(query, "textobjects")
		end
	end

	local goto_prev_start = function(query)
		return function()
			move.goto_previous_start(query, "textobjects")
		end
	end

	local goto_prev_end = function(query)
		return function()
			move.goto_previous_end(query, "textobjects")
		end
	end

	-- Next start
	Config.map({ "n", "x", "o" }, "]f", goto_next_start("@function.outer"), { desc = "Next function start" })
	Config.map({ "n", "x", "o" }, "]c", goto_next_start("@class.outer"), { desc = "Next class start" })
	Config.map({ "n", "x", "o" }, "]a", goto_next_start("@parameter.inner"), { desc = "Next parameter start" })
	Config.map({ "n", "x", "o" }, "]l", goto_next_start("@loop.outer"), { desc = "Next loop start" })
	Config.map({ "n", "x", "o" }, "]b", goto_next_start("@block.outer"), { desc = "Next block start" })

	-- Next end
	Config.map({ "n", "x", "o" }, "]F", goto_next_end("@function.outer"), { desc = "Next function end" })
	Config.map({ "n", "x", "o" }, "]C", goto_next_end("@class.outer"), { desc = "Next class end" })
	Config.map({ "n", "x", "o" }, "]A", goto_next_end("@parameter.inner"), { desc = "Next parameter end" })
	Config.map({ "n", "x", "o" }, "]L", goto_next_end("@loop.outer"), { desc = "Next loop end" })
	Config.map({ "n", "x", "o" }, "]B", goto_next_end("@block.outer"), { desc = "Next block end" })

	-- Previous start
	Config.map({ "n", "x", "o" }, "[f", goto_prev_start("@function.outer"), { desc = "Previous function start" })
	Config.map({ "n", "x", "o" }, "[c", goto_prev_start("@class.outer"), { desc = "Previous class start" })
	Config.map({ "n", "x", "o" }, "[a", goto_prev_start("@parameter.inner"), { desc = "Previous parameter start" })
	Config.map({ "n", "x", "o" }, "[l", goto_prev_start("@loop.outer"), { desc = "Previous loop start" })
	Config.map({ "n", "x", "o" }, "[b", goto_prev_start("@block.outer"), { desc = "Previous block start" })

	-- Previous end
	Config.map({ "n", "x", "o" }, "[F", goto_prev_end("@function.outer"), { desc = "Previous function end" })
	Config.map({ "n", "x", "o" }, "[C", goto_prev_end("@class.outer"), { desc = "Previous class end" })
	Config.map({ "n", "x", "o" }, "[A", goto_prev_end("@parameter.inner"), { desc = "Previous parameter end" })
	Config.map({ "n", "x", "o" }, "[L", goto_prev_end("@loop.outer"), { desc = "Previous loop end" })
	Config.map({ "n", "x", "o" }, "[B", goto_prev_end("@block.outer"), { desc = "Previous block end" })

	-- Autocmds
	-- Auto-update parsers when plugins change
	vim.api.nvim_create_autocmd('PackChanged', {
		callback = function(ev)
			local data = ev and ev.data or nil
			if not data or not data.spec or data.spec.name ~= "nvim-treesitter" then
				return
			end
			if data.kind == "update" then
				nts.update()
			end
		end
	})

	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local filetype = args.match
			if string.find(filetype, 'chezmoitmpl') then
				return
			end
			local lang = vim.treesitter.language.get_lang(filetype)
			if lang and vim.treesitter.language.add(lang) then
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				vim.treesitter.start()
			end
		end
	})

	-- Disable spell checking by default
	-- If you want spell checking, enable it per filetype or manually with :setlocal spell
	-- Treesitter automatically uses @spell captures to mark comments/strings for checking
	vim.opt.spell = false

	-- Optional: If you want spell checking only on specific filetypes (like markdown, text, etc.)
	-- vim.api.nvim_create_autocmd("FileType", {
	--   pattern = { "markdown", "text", "gitcommit" },
	--   callback = function()
	--     vim.opt_local.spell = true
	--     vim.opt_local.spelllang = "en_us"
	--   end
	-- })
end)
