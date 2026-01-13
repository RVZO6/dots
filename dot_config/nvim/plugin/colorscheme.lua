local theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
local config_file = vim.fn.expand("~/.config/nvim/plugin/colorscheme.lua")

-- Store last modification time to detect external changes
local last_mtime = 0

--- Apply aether theme with current palette
--- This function contains all of logic needed to load/reload the theme
local function apply_aether_theme()
	-- Reloads palette file
	local palette = dofile(theme_file)

	-- Clear and reload aether
	package.loaded["aether"] = nil
	package.loaded["aether.config"] = nil

	-- Setup with new colors
	require("aether").setup({
		transparent = false,
		colors = palette,
	})

	-- Apply colorscheme
	vim.cmd.colorscheme("aether")

	-- Re-apply custom highlights
	vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
	vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })

	-- Update mtime tracker using vim.fn.getftime
	last_mtime = vim.fn.getftime(theme_file)
end

--- Check if theme file has been modified externally
local function check_external_changes()
	local current_mtime = vim.fn.getftime(theme_file)
	if current_mtime > last_mtime then
		apply_aether_theme()
	end
end

if vim.fn.filereadable(theme_file) == 1 then
	-- Omarchy System (Linux Desktop)
	Config.now(function()
		vim.pack.add({
			{
				src = "https://github.com/bjarneo/aether.nvim",
				version = "v2"
			}
		})

		-- Initial load
		apply_aether_theme()

		-- Watch for internal changes (when Neovim writes our config)
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = config_file,
			callback = function()
				apply_aether_theme()
			end,
			desc = "Reload aether theme when config file is saved (internal)"
		})

		-- Watch for external changes (when Omarchy updates theme)
		-- This triggers on FocusGained to avoid constant polling
		vim.api.nvim_create_autocmd("FocusGained", {
			callback = check_external_changes,
			desc = "Check for external theme changes when focus is gained"
		})
	end)
else
	-- macOS / Non-Omarchy (Vague Theme)
	Config.now(function()
		vim.pack.add({ "https://github.com/vague-theme/vague.nvim" })
	end)

	Config.now(function()
		require("vague").setup({
			transparent = true,
			on_highlights = function(hl, c)
				-- Keep your existing Vague fixes here
				hl.RenderMarkdownBullet     = { fg = c.plus }
				hl.RenderMarkdownTableRow   = { fg = c.keyword }
				hl.RenderMarkdownCode       = { bg = c.line }
				hl.RenderMarkdownCodeBorder = { bg = c.visual }

				hl["@markup.strong"]        = { fg = c.keyword, gui = "bold" }
				hl["@markup.italic"]        = { fg = c.keyword, gui = "italic" }
				hl["@markup.heading.1"]     = { fg = c.constant, gui = "bold" }
				hl["@markup.heading.2"]     = { fg = c.parameter, gui = "bold" }
				hl["@markup.heading.3"]     = { fg = c.type, gui = "bold" }
				hl["@markup.heading.4"]     = { fg = c.operator, gui = "bold" }
				hl["@markup.heading.5"]     = { fg = c.plus, gui = "bold" }
				hl["@markup.heading.6"]     = { fg = c.func, gui = "bold" }

				hl.RenderMarkdownH1Bg       = { bg = "#31304d" }
				hl.RenderMarkdownH2Bg       = { bg = "#4c324e" }
				hl.RenderMarkdownH3Bg       = { bg = "#243b41" }
				hl.RenderMarkdownH4Bg       = { bg = "#384758" }
				hl.RenderMarkdownH5Bg       = { bg = "#355615" }
				hl.RenderMarkdownH6Bg       = { bg = "#72393a" }
				hl.SpellBad                 = { sp = c.error, gui = "undercurl" }
				hl.SpellCap                 = { sp = c.warning, gui = "undercurl" }
				hl.SpellLocal               = { sp = c.hint, gui = "undercurl" }
				hl.SpellRare                = { sp = c.plus, gui = "undercurl" }
			end,
		})
		vim.cmd("colorscheme vague")
		vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
		vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })
	end)
end
