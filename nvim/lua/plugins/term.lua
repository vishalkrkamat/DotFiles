return {
	"akinsho/toggleterm.nvim",
	version = "*", -- You can specify a tag or version
	config = function()
		require("toggleterm").setup({
			-- General configuration options
			size = 20, -- Size of the terminal window
			open_mapping = [[<c-o>]], -- Key mapping to toggle terminal
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2, -- Darkens the terminal background
			start_in_insert = true, -- Start in insert mode
			persist_size = true,
			direction = "horizontal", -- You can use 'vertical', 'horizontal', or 'float'
		})
	end,
}
