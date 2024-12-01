-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

--  See `:help hlsearch`
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

vim.keymap.set("t", "<C-u>", [[<C-\><C-n>:w<CR>:!gcc % -o %:r && ./%:r<CR>]], { noremap = true, silent = true })
-- Map Ctrl + u in terminal mode
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

local function toggle_vsplit()
	local windows = vim.api.nvim_tabpage_list_wins(0)
	if #windows > 1 then
		-- If more than one window is open, close the last one
		vim.cmd("close")
	else
		-- If only one window is open, perform a vertical split
		vim.cmd("vsplit")
	end
end

vim.keymap.set("n", "vs", toggle_vsplit, { noremap = true, silent = true })
--vim.keymap.set("n", "vs", "<cmd>vsplit<CR>", { noremap = true, silent = true })
--
-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')
