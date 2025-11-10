-- ======================
-- Neovim Keymaps Config
-- ======================

-- [[ Basic ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- [[ Diagnostics ]]
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })

-- [[ Terminal ]]
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- [[ Save & Quit ]]
vim.keymap.set("n", "zz", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<Tab><Tab>", ":wq<CR>", { desc = "Save and quit" })
vim.keymap.set("n", "<Tab>q", ":q!<CR>", { desc = "Quit without saving" })

-- [[ Buffer Management ]]
vim.keymap.set("n", "<leader>gn", "<C-^>", { desc = "Switch to previous buffer" })

-- [[ Colemak-DH Motion Remaps ]]
vim.keymap.set({ "n", "v" }, "m", "h", { noremap = true })
vim.keymap.set({ "n", "v" }, "n", "j", { noremap = true })
vim.keymap.set({ "n", "v" }, "e", "k", { noremap = true })
vim.keymap.set({ "n", "v" }, "k", "l", { noremap = true })
vim.keymap.set("n", "l", "n", { noremap = true })

-- [[ Insert Mode Symbols (Alt mappings) ]]
vim.keymap.set("i", "<M-e>", "=", { noremap = true, silent = true })
vim.keymap.set("i", "<M-u>", "+", { noremap = true, silent = true })
vim.keymap.set("i", "<M-l>", "-", { noremap = true, silent = true })
vim.keymap.set("i", "<M-o>", "_", { noremap = true, silent = true })

-- [[ Text Objects Editing ]]
vim.keymap.set("n", "tl", "ci(", { noremap = true, silent = true, desc = "Change inside ()" })
vim.keymap.set("n", "tu", "ci{", { noremap = true, silent = true, desc = "Change inside {}" })
vim.keymap.set("n", "ty", "ci[", { noremap = true, silent = true, desc = "Change inside []" })
vim.keymap.set("n", "ti", 'ci"', { noremap = true, silent = true, desc = "Change inside double quotes" })
vim.keymap.set("n", "to", "ci'", { noremap = true, silent = true, desc = "Change inside single quotes" })
vim.keymap.set("n", "tw", "ciw", { noremap = true, silent = true, desc = "Change current word" })
