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
vim.keymap.set("n", "zz", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<TAB>q", "<cmd>q!<CR>", { desc = "Quit without saving" })

-- [[ Buffer Management ]]
vim.keymap.set("n", "<leader>n", "<C-^>", { desc = "Switch to previous buffer" })

local function safe_buf_delete(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	-- If buffer is modified, refuse (do NOT force)
	if vim.bo[bufnr].modified then
		vim.notify("Buffer has unsaved changes", vim.log.levels.WARN)
		return
	end

	-- Find a valid buffer to switch to
	local function get_alt_buf()
		for _, b in ipairs(vim.api.nvim_list_bufs()) do
			if b ~= bufnr and vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted then
				return b
			end
		end
		return nil
	end

	local alt = get_alt_buf()

	-- Replace buffer in all windows
	for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
		if alt then
			vim.api.nvim_win_set_buf(win, alt)
		else
			-- No other buffer exists → create empty buffer
			vim.cmd("enew")
			vim.api.nvim_win_set_buf(win, vim.api.nvim_get_current_buf())
		end
	end

	-- Finally delete the buffer
	vim.api.nvim_buf_delete(bufnr, { force = false })
end

vim.keymap.set("n", "<leader>bd", safe_buf_delete, {
	desc = "Safely delete buffer",
})

-- [[ Insert Mode Symbols (Alt mappings) ]]
vim.keymap.set("i", "<M-j>", "=", { noremap = true, silent = true })
vim.keymap.set("i", "<M-i>", "+", { noremap = true, silent = true })
vim.keymap.set("i", "<M-u>", "-", { noremap = true, silent = true })
vim.keymap.set("i", "<M-;>", "_", { noremap = true, silent = true })

-- [[ Text Objects Editing ]]
vim.keymap.set("n", "tr", "ci(", { noremap = true, silent = true, desc = "Change inside ()" })
vim.keymap.set("n", "tc", "ci{", { noremap = true, silent = true, desc = "Change inside {}" })
vim.keymap.set("n", "ts", "ci[", { noremap = true, silent = true, desc = "Change inside []" })
vim.keymap.set("n", "tu", 'ci"', { noremap = true, silent = true, desc = "Change inside double quotes" })
vim.keymap.set("n", "ti", "ci'", { noremap = true, silent = true, desc = "Change inside single quotes" })
