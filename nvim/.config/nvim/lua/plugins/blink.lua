return {
	{
		"saghen/blink.cmp",
		version = "1.*", -- use release version for prebuilt binary
		dependencies = {
			"rafamadriz/friendly-snippets", -- optional snippets
		},
		opts = {
			keymap = { preset = "default" },
			appearance = { nerd_font_variant = "mono" },
			completion = { documentation = { auto_show = false } },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
