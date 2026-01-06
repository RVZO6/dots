-- global for plugin files
map = vim.keymap.set

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
-- vim.o.mouse = "" -- disable mouse (vim hard mode)
-- vim.o.clipboard = "unnamedplus"
-- trying system clipboard as <space> + y/d
-- consider have <leader>y = normal and y is +y???
map({ "n", "x" }, "<leader>y", '"+y')
map({ "n", "x" }, "<leader>d", '"+d')
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

-------KEYMAPS-------

map({ "n", "v", "x" }, "<leader>o", "<Cmd>source %<CR>", { desc = "Source " .. vim.fn.expand("$MYVIMRC") })
map({ "n", "v", "x" }, "<leader>cf", vim.lsp.buf.format, { desc = "Format current buffer" })
map("n", "<C-s>", "<cmd>write<CR>", { desc = "Save buffer" })
map("n", "<leader>w", "<C-w>", { desc = "window management" })
map({ "n", "v", "x" }, "<C-c>", "<cmd>quitall!<CR>", { desc = "Save buffer" })
-- mark stuff
map("n", "<C-m>", "`")
-- tab management
map({ "n", "t" }, "<Leader>t", "<Cmd>tabnew<CR>")
map({ "n", "t" }, "<Leader>x", "<Cmd>tabclose<CR>")
for i = 1, 8 do
	map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end
-- swap ; and : for *ergonomics*
map({ "n", "v", "x" }, ";", ":")
map({ "n", "v", "x" }, ":", ";")

-- normal mode improvements
map("v", ".", "norm! .", { desc = "Repeat last normal mode command in visual" })
map("n", "gK", "<Cmd>exec 'norm! K'< .norm! gJ'< .norm! `<'<CR>", { desc = "Join lines in reverse order" })
map("n", "j", "gj", { desc = "Move by display line (soft wrap)" })
map("n", "k", "gk", { desc = "Move by display line (soft wrap)" })

-- keep cursor centered when scrolling/searching
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- quick actions
map("n", "<leader>a", ":edit #<CR>", { desc = "Jump to alternate file" })
map("n", "<C-q>", ":copen<CR>", { silent = true, desc = "Open quickfix list" })
map("n", "<leader>c", "1z=", { desc = "Auto-fix spelling (first suggestion)" })


-------AUTOCOMMANDS--------

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
			higroup = "IncSearch",
			timeout = 150,
		})
	end,
})

