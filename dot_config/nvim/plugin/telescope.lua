-- telescope.nvim
Config.later(function()
	vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim" }, { load = true })
	vim.pack.add({ "https://github.com/nvim-telescope/telescope.nvim" }, { load = true })
	vim.pack.add({ "https://github.com/nvim-telescope/telescope-ui-select.nvim" }, { load = true })

	require "telescope".setup({
		defaults = {
			preview = { treesitter = true },
			color_devicons = true,
			sorting_strategy = "ascending",
			border = true,
			borderchars = {
				-- divider-only look: no outer edges; leave gaps at corners
				prompt = { " ", " ", "─", " ", " ", " ", " ", " " },
				results = { " ", "│", " ", " ", " ", " ", " ", " " },
				preview = { " ", " ", " ", " ", " ", " ", " ", " " },
			},
			path_displays = { "smart" },
			layout_config = {
				height = function(_, _, max_lines)
					return max_lines
				end,
				width = function(_, max_columns, _)
					return max_columns
				end,
				prompt_position = "top",
				preview_cutoff = 40,
			},
		},
		extensions = {
			["ui-select"] = require("telescope.themes").get_dropdown({}),
		},
	})

	require("telescope").load_extension("ui-select")
	local builtin = require("telescope.builtin")

	-- keymaps
	Config.map({ "n", "v", "x" }, "<leader><space>", builtin.find_files, { desc = "Pick files" })
	Config.map({ "n", "v", "x" }, "<leader>sk", builtin.keymaps, { desc = "[S]earch [k]eymaps" })
	Config.map({ "n", "v", "x" }, "<leader>sh", builtin.help_tags, { desc = "[S]earch [h]elp" })
	Config.map({ "n", "v", "x" }, "<leader>sH", builtin.highlights, { desc = "[S]earch [H]ighlights" })
	Config.map({ "n", "v", "x" }, "<leader>sg", builtin.live_grep, { desc = "[S]earch [G]rep" })

	-- spelling suggestions
	Config.map("n", "z=", builtin.spell_suggest, { desc = "Spelling suggestions" })
end)
