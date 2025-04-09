return {
	"brenoprata10/nvim-highlight-colors",
	event = { "BufReadPre", "BufNewFile" }, -- lazy load on open file
	config = function()
		require("nvim-highlight-colors").setup({
			render = "virtual", -- or "background" or "foreground"
			enable_named_colors = true,
			enable_tailwind = true,
		})
	end,
}
