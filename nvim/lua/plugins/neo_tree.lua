return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", {})
		-- Key mapping to switch focus between Neo-tree and code window
		vim.keymap.set("n", "<C-t>", function()
			-- Check if Neo-tree is open and focus it or the other window
			if vim.fn.bufname():match("Neotree") then
				vim.cmd("wincmd p") -- Switch to the previous window
			else
				-- Move to Neo-tree if it's open
				vim.cmd("Neotree focus")
			end
		end, { desc = "Switch focus between Neo-tree and the code window" })
		require("neo-tree").setup({

			enable_git_status = true,
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
				},
			},
		})
	end,
}
