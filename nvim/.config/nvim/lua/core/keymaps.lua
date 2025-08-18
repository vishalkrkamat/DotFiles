-- [[ Basic Keymaps ]]

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

--
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "zz", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<Tab><Tab>", ":wq<CR>", { desc = "Save and quit" })
vim.keymap.set("n", "<Tab>q", ":q!<CR>", { desc = "Quit!" })
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--

-- Remap motion keys for Colemak-DH
vim.keymap.set({ "n", "v" }, "m", "h", { noremap = true })
vim.keymap.set({ "n", "v" }, "n", "j", { noremap = true })
vim.keymap.set({ "n", "v" }, "e", "k", { noremap = true })
vim.keymap.set({ "n", "v" }, "k", "l", { noremap = true })
vim.keymap.set({ "n" }, "l", "n", { noremap = true })

-- vim.keymap.set("n", "<leader>g", ":w<CR>:term gcc % -o %< && ./%< <CR>", { silent = true })
-- Map Ctrl + u in terminal mode
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
-- vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
-- vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
-- vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
--
-- local split_winid = nil
--
-- local function toggle_hsplit()
-- 	if split_winid and vim.api.nvim_win_is_valid(split_winid) then
-- 		vim.api.nvim_win_close(split_winid, true)
-- 		split_winid = nil
-- 	else
-- 		vim.cmd("split")
-- 		split_winid = vim.api.nvim_get_current_win()
-- 	end
-- end
--
-- local function toggle_vsplit()
-- 	if split_winid and vim.api.nvim_win_is_valid(split_winid) then
-- 		vim.api.nvim_win_close(split_winid, true)
-- 		split_winid = nil
-- 	else
-- 		vim.cmd("vsplit")
-- 		split_winid = vim.api.nvim_get_current_win()
-- 	end
-- end
--
-- vim.keymap.set("n", "sh", toggle_hsplit, { noremap = true, silent = true })
-- vim.keymap.set("n", "sv", toggle_vsplit, { noremap = true, silent = true })
--
-- Delete inside () and enter insert mode
vim.keymap.set("n", "zu", "ci(", { noremap = true, silent = true, desc = "Delete inside () and insert" })

-- Delete inside {} and enter insert mode
vim.keymap.set("n", "zi", "ci{", { noremap = true, silent = true, desc = "Delete inside {} and insert" })

-- Delete inside [] and enter insert mode
vim.keymap.set("n", "zo", "ci[", { noremap = true, silent = true, desc = "Delete inside [] and insert" })

-- Delete inside double quotes and enter insert mode
vim.keymap.set("n", "zj", 'ci"', { noremap = true, silent = true, desc = "Delete inside double quotes and insert" })

-- Delete inside single quotes and enter insert mode
vim.keymap.set("n", "zk", "ci'", { noremap = true, silent = true, desc = "Delete inside single quotes and insert" })

-- Change word
vim.keymap.set("n", "zl", "ciw", { noremap = true, silent = true, desc = "Delete words and insert" })

--
-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')
