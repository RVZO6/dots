-- Bootstrap with mini
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
vim.g.mapleader = " "
vim.o.swapfile = false
vim.o.relativenumber = true
vim.o.winborder = "single"
vim.o.pumborder = "single"
vim.o.cmdheight = 0
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.laststatus = 3
vim.o.cursorcolumn = false
vim.o.scrolloff = 8
vim.o.signcolumn = "yes"
vim.o.smartindent = true
-- text wrapping -- maybe make only md/text files??
vim.opt.wrap = true
vim.opt.linebreak = true
-- vim.o.mouse = "" -- disable mouse (vim hard mode)
-- vim.o.clipboard = "unnamedplus"
-- trying system clipboard as <space> + y/d
-- consider have <leader>y = normal and y is +y???
Config.map({ "n", "x" }, "<leader>y", '"+y')
Config.map({ "n", "x" }, "<leader>d", '"+d')
vim.o.ignorecase = true -- mainly for mini.pick
vim.o.undofile = true
vim.opt.fillchars = {
	eob = " ",
}
-- insert the recording status into the statusline
vim.o.statusline = vim.o.statusline:gsub(
	"%%m",
	"%%m %%{reg_recording()!=''?' @'.reg_recording():''}"
)

-------KEY MAPS-------

Config.map({ "n", "v", "x" }, "<leader>o", "<Cmd>source %<CR>", { desc = "Source " .. vim.fn.expand("$MYVIMRC") })
Config.map({ "n", "v", "x" }, "<leader>cf", vim.lsp.buf.format, { desc = "Format current buffer" })
Config.map("n", "<C-s>", "<cmd>write<CR>", { desc = "Save buffer" })
Config.map("n", "<leader>w", "<C-w>", { desc = "window management" })
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
Config.map("n", "<leader>c", "1z=", { desc = "Auto-fix spelling (first suggestion)" })
Config.map("n", "yp", function()
	vim.fn.setreg("+", vim.fn.expand("%:p:~"))
end, { desc = "Yank path with ~" })

-- spell suggest
Config.map("n", "z=", "<Cmd>Pick spellsuggest<CR>", { desc = "Spelling suggestions" })

-- paste above and below
Config.map("n", "[p", '<Cmd>exe "put! " . v:register<CR>', { desc = "Paste Above" })
Config.map("n", "]p", '<Cmd>exe "put "  . v:register<CR>', { desc = "Paste Below" })

------AUTOCOMMANDS--------

-- no hl on insert
vim.api.nvim_create_autocmd('InsertEnter', {
	pattern = '*',
	command = 'set nohlsearch',
})

--hl yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	callback = function()
		vim.highlight.on_yank({
			higroup = "DiffText",
			timeout = 150,
		})
	end,
})
