-- ~/.config/nvim/lua/plugin_keymaps.lua
local map = vim.keymap.set
local opts = { silent = true, noremap = true }

local Snacks = require("snacks")

-- 🔍 Core Find/Grep/Search
map("n", "<leader><space>", function()
	Snacks.picker.smart()
end, { desc = "Smart File Picker" })
map("n", "<leader>/", function()
	Snacks.picker.grep()
end, { desc = "Live Grep" })
map("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fo", function()
	Snacks.picker.recent()
end, { desc = "Recent Files" })
map("n", "<leader>fp", function()
	Snacks.picker.projects()
end, { desc = "Projects" })
map("n", "<leader>fc", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
map("n", "<leader>ff", function()
	Snacks.picker.files()
end, { desc = "Find Files" })

-- 📖 Help & Docs
map("n", "<leader>fh", function()
	Snacks.picker.help()
end, { desc = "Help Tags" })
map("n", "<leader>fk", function()
	Snacks.picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>fm", function()
	Snacks.picker.man()
end, { desc = "Man Pages" })

-- ⚙️ Commands
map("n", "<leader>fC", function()
	Snacks.picker.commands()
end, { desc = "Commands" })

-- 🧠 Useful Extras
map("n", "<leader>fr", function()
	Snacks.picker.resume()
end, { desc = "Resume Last Picker" })
map("n", "<leader>uC", function()
	Snacks.picker.colorschemes()
end, { desc = "Colorschemes" })
map("n", "<leader>su", function()
	Snacks.picker.undo()
end, { desc = "Undo Tree" })
map("n", "<leader>s/", function()
	Snacks.picker.search_history()
end, { desc = "Search History" })

-- 🚀 LSP Pickers (optional if you use LSP)
map("n", "gd", function()
	Snacks.picker.lsp_definitions()
end, { desc = "Go to Definition" })
map("n", "gr", function()
	Snacks.picker.lsp_references()
end, { desc = "References" })
map("n", "gI", function()
	Snacks.picker.lsp_implementations()
end, { desc = "Implementations" })
map("n", "<leader>sd", function()
	Snacks.picker.diagnostics()
end, { desc = "Workspace Diagnostics" })
map("n", "<leader>sD", function()
	Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer Diagnostics" })

-- 📂 File Explorer
map("n", "<leader>e", function()
	Snacks.explorer()
end, { desc = "File Explorer" })

-- 📣 Noice.nvim keymaps
map("n", "<leader>sn", "", { desc = "+noice" })

map("c", "<S-Enter>", function()
	require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })

map("n", "<leader>snl", function()
	require("noice").cmd("last")
end, { desc = "Noice Last Message" })

map("n", "<leader>snh", function()
	require("noice").cmd("history")
end, { desc = "Noice History" })

map("n", "<leader>sna", function()
	require("noice").cmd("all")
end, { desc = "Noice All" })

map("n", "<leader>snd", function()
	require("noice").cmd("dismiss")
end, { desc = "Dismiss All" })

map("n", "<leader>snt", function()
	require("noice").cmd("pick")
end, { desc = "Noice Picker (Telescope/FzfLua)" })

map({ "i", "n", "s" }, "<C-f>", function()
	if not require("noice.lsp").scroll(4) then
		return "<C-f>"
	end
end, vim.tbl_extend("force", opts, { expr = true, desc = "Scroll Forward" }))

map({ "i", "n", "s" }, "<C-b>", function()
	if not require("noice.lsp").scroll(-4) then
		return "<C-b>"
	end
end, vim.tbl_extend("force", opts, { expr = true, desc = "Scroll Backward" }))

-- Conform plugin keymaps
vim.keymap.set("", "<leader>f", function()
	require("conform").format({ async = true })
end, { desc = "Format buffer" })
