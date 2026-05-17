return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config("*", { capabilities = capabilities })

			vim.lsp.config("lua_ls", {
				settings = { Lua = { diagnostics = { globals = { "vim" } } } },
			})
			vim.lsp.config("vtsls", {
				root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
			})
			vim.lsp.config("biome", {
				root_markers = { "biome.json", "biome.jsonc" },
			})
			vim.lsp.config("pyright", {
				root_markers = { "pyproject.toml", "setup.py", "requirements.txt", "pyrightconfig.json" },
			})
			vim.lsp.config("rust_analyzer", {
				root_markers = { "Cargo.toml" },
			})
			vim.lsp.config("tailwindcss", {
				root_markers = {
					"tailwind.config.js",
					"tailwind.config.ts",
					"tailwind.config.cjs",
					"tailwind.config.mjs",
				},
			})

			local emmet_capabilities = vim.deepcopy(capabilities)
			emmet_capabilities.textDocument.completion.completionItem.snippetSupport = true
			vim.lsp.config("emmet_ls", {
				capabilities = emmet_capabilities,
				filetypes = { "typescriptreact", "javascriptreact", "tsx", "jsx" },
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"vtsls",
					"html",
					"cssls",
					"tailwindcss",
					"emmet_ls",
					"jsonls",
					"marksman",
					"pyright",
					"rust_analyzer",
					"biome",
					"tinymist",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config("gleam", {
				cmd = { "gleam", "lsp" },
				filetypes = { "gleam" },
				root_markers = { "gleam.toml", ".git" },
				capabilities = capabilities,
			})
			vim.lsp.enable("gleam")

			vim.lsp.inlay_hint.enable(true)

			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover({
					border = "rounded",
					max_height = 80,
					max_width = 80,
					wrap = true,
				})
			end, { desc = "LSP: Hover" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })
			vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "LSP: Code actions" })
		end,
	},
}
