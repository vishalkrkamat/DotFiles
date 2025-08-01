-- [[ Leader Key Settings ]]
-- Set <Space> as the leader key (must be set before plugins are loaded)
vim.g.mapleader = " "
vim.g.maplocalleader = ";"

-- [[ UI Enhancements ]]
vim.g.have_nerd_font = true -- Enable Nerd Font support
vim.g.snacks_animate = true -- Custom plugin flag (presumably for animations)

-- [[ General Options ]]
vim.opt.number = true -- Show absolute line numbers
vim.opt.relativenumber = false -- Show relative line numbers
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.showmode = false -- Hide mode (handled by statusline)
vim.opt.clipboard = "unnamedplus" -- Sync clipboard with OS
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive search...
vim.opt.smartcase = true -- ...unless capital letters are used
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.updatetime = 250 -- Faster completion
vim.opt.timeoutlen = 300 -- Shorter wait time for mapped sequences
vim.opt.splitright = true -- Vertical splits to the right
vim.opt.splitbelow = true -- Horizontal splits below
vim.opt.list = true -- Show invisible characters
vim.opt.listchars = { tab = "| ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split" -- Live preview of substitutions
vim.opt.cursorline = true -- Highlight current line
vim.opt.scrolloff = 10 -- Lines of context

-- Tabs & Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Disable line wrapping
vim.opt.wrap = false

-- Disable swap/backup; persistent undo
vim.opt.swapfile = false
vim.opt.backup = false

-- [[ Autocommands ]]
-- Highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
