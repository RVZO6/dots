-- Set makeprg for Rust files to use cargo build instead of default make
-- This allows running :make to compile Rust projects with cargo
-- Location: after/ftplugin so it runs after Rust filetype is detected

vim.cmd([[
	setlocal makeprg=cargo\ build
]])
