return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},
	event = { "BufReadPre", "BufNewFile" }, -- Lazy load on buffer events
	opts = {
		inlay_hints = {
			enabled = true,
			exclude = { "vue" }, -- Filetypes for which inlay hints are disabled
		},
		codelens = {
			enabled = true,
		},
	},
	config = function(_, opts)
		-- Setup mason.nvim for managing LSP servers
		require("mason").setup({
			ui = {
				border = "rounded",
				icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
			},
		})

		-- Setup mason-lspconfig to automatically install LSP servers
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "pyright", "clangd" },
			automatic_installation = true,
		})

		-- Get LSP capabilities from blink.cmp
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Define on_attach function for LSP keybindings and functionality
		local on_attach = function(client, bufnr)
			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			-- map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
			-- map("n", "K", vim.lsp.buf.hover, "Hover")
			-- map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
			-- map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
		end

		if vim.fn.has("nvim-0.10") == 1 and opts.inlay_hints.enabled then
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local buffer = args.buf
					if
						client
						and client:supports_method("textDocument/inlayHint")
						and vim.api.nvim_buf_is_valid(buffer)
						and vim.bo[buffer].buftype == ""
						and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
					then
						vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
					end
				end,
			})
		end

		-- Enable CodeLens
		if vim.fn.has("nvim-0.10") == 1 and opts.codelens.enabled and vim.lsp.codelens then
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local buffer = args.buf
					if client and client.supports_method("textDocument/codeLens") then
						vim.lsp.codelens.refresh({ bufnr = buffer })
						vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
							buffer = buffer,
							callback = function()
								vim.lsp.codelens.refresh({ bufnr = buffer })
							end,
						})
					end
				end,
			})
		end

		-- Define LSP server configurations
		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						diagnostics = { globals = { "vim" } },
						hint = { enable = true },
						codeLens = { enable = true }, -- Enable CodeLens for lua_ls
					},
				},
			},
			pyright = {},
			rust_analyzer = {
				cmd = { "rust-analyzer" }, -- <- will use the rustup-provided one
				settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						checkOnSave = { command = "clippy" },
					},
				},
			},
			clangd = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--header-insertion=never",
				},
				init_options = {
					clangdFileStatus = true,
				},
			},
		}

		-- Setup each LSP server with capabilities and on_attach
		local lspconfig = require("lspconfig")
		for server, config in pairs(servers) do
			config.capabilities = capabilities
			config.on_attach = on_attach
			lspconfig[server].setup(config)
		end

		-- Configure diagnostics UI
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
			},
			severity_sort = true,
			underline = true,
			update_in_insert = false,
			float = { border = "rounded" },
			signs = true,
		})
	end,
}
