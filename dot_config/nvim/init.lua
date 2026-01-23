-- Bootstrap with mini
-- technically not needed but its easier. will remove later maybe
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- Setup 'mini.deps' for access to `now` and `later` helpers
require("mini.deps").setup()

-- Define global config table for sharing between modules
_G.Config = {}
Config.map = vim.keymap.set

-- Define lazy helpers
Config.now = MiniDeps.now
Config.now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later
Config.later = MiniDeps.later

-- options
vim.opt.termguicolors = false
vim.g.mapleader = " "
vim.opt.swapfile = false
vim.opt.relativenumber = true
vim.opt.winborder = "single"
vim.opt.spell = true
vim.opt.splitright = true
vim.opt.pumborder = "single"
vim.opt.cmdheight = 0
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.laststatus = 3
vim.opt.cursorcolumn = false
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
-- text wrapping -- maybe int make only md/text files??
vim.opt.wrap = true
vim.opt.linebreak = true
-- vim.opt.mouse = "" -- disable mouse (vim hard mode)
-- vim.opt.clipboard = "unnamedplus"
-- trying system clipboard as <space> + y/d
-- consider have <leader>y = normal and y is +y???
Config.map({ "n", "x" }, "<leader>y", '"+y')
Config.map({ "n", "x" }, "<leader>d", '"+d')
vim.opt.ignorecase = true -- mainly for mini.pick
vim.opt.undofile = true
vim.opt.fillchars = {
	eob = " ",
}
-- insert the recording status into the statusline
vim.opt.statusline = vim.o.statusline:gsub(
	"%%m",
	"%%m %%{reg_recording()!=''?' @'.reg_recording():''}"
)

-------KEY MAPS-------

Config.map({ "n", "v", "x" }, "<leader>o", "<Cmd>source %<CR>", { desc = "Source " .. vim.fn.expand("$MYVIMRC") })
Config.map({ "n", "v", "x" }, "<leader>cf", vim.lsp.buf.format, { desc = "Format current buffer" })
Config.map("n", "<C-s>", "<cmd>write<CR>", { desc = "Save buffer" })
-- remap = true makes it so that subsequent binds work, e.g. <leader>wd
Config.map("n", "<leader>w", "<C-w>", { remap = true, desc = "window management" })
Config.map({ "n", "v", "x" }, "<C-c>", "<cmd>quitall!<CR>", { desc = "Save buffer" })

-- mark stuff
Config.map("n", "<C-m>", "`")

-- tab management
Config.map({ "n", "t" }, "<Leader>t", "<Cmd>tabnew<CR>")
Config.map({ "n", "t" }, "<Leader>x", "<Cmd>tabclose<CR>")
for i = 1, 8 do
	Config.map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end

-- swap ; and : for *ergonomics*
Config.map({ "n", "v", "x" }, ";", ":")
Config.map({ "n", "v", "x" }, ":", ";")

-- normal mode improvements
Config.map("v", ".", "norm! .", { desc = "Repeat last normal mode command in visual" })
Config.map("n", "gK", "kJ", { desc = "Join line above to current line" })
Config.map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
Config.map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- keep cursor centered when scrolling/searching
Config.map("n", "<C-d>", "<C-d>zz")
Config.map("n", "<C-u>", "<C-u>zz")
Config.map("n", "n", "nzzzv")
Config.map("n", "N", "Nzzzv")

-- quick actions
Config.map("n", "<leader>a", ":edit #<CR>", { desc = "Jump to alternate file" })
Config.map("n", "<C-q>", ":copen<CR>", { silent = true, desc = "Open quickfix list" })
Config.map("n", "<leader>cs", "1z=", { desc = "Auto-fix spelling (first suggestion)" })
Config.map("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, { desc = "Code Action" })
Config.map("n", "yp", function()
	vim.fn.setreg("+", vim.fn.expand("%:p:~"))
end, { desc = "Yank path with ~" })
Config.map('i', '<C-v>', '<C-r><C-p>"', {
	noremap = true,
	silent = true,
	desc = "Paste from default register with fixed indentation"
})

-- spell suggest
Config.map("n", "z=", "<Cmd>Pick spellsuggest<CR>", { desc = "Spelling suggestions" })
Config.map("n", "<leader>us", function()
	-- Use vim.wo (window option) because 'spell' is a window-local setting
	vim.wo.spell = not vim.wo.spell
end, { desc = "Toggle Spell Check" })

-- paste above and below
Config.map("n", "[p", '<Cmd>exe "put! " . v:register<CR>', { desc = "Paste Above" })
Config.map("n", "]p", '<Cmd>exe "put "  . v:register<CR>', { desc = "Paste Below" })

------AUTO COMMANDS (mostly) --------

-- no hl on insert OR if press esc
vim.api.nvim_create_autocmd('InsertEnter', {
	pattern = '*',
	command = 'set nohlsearch',
})
vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = "Clear search highlights" })

--hl yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	callback = function()
		vim.hl.on_yank({
			higroup = "DiffText",
			timeout = 150,
		})
	end,
})

-- help windows on right
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	callback = function()
		if vim.bo.buftype == 'help' then
			vim.cmd("wincmd L")
		end
	end,
})
