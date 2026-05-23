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
			local ts_inlay_hints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
				parameterTypes = { enabled = false },
				propertyDeclarationTypes = { enabled = false },
				variableTypes = { enabled = false },
			}
			vim.lsp.config("vtsls", {
				settings = {
					typescript = { inlayHints = ts_inlay_hints },
					javascript = { inlayHints = ts_inlay_hints },
				},
			})
			vim.lsp.config("pyright", {
				root_markers = { "pyproject.toml", "setup.py", "requirements.txt", "pyrightconfig.json" },
			})
			vim.lsp.config("tailwindcss", {
				filetypes = {
					"html",
					"css",
					"scss",
					"javascriptreact",
					"typescriptreact",
					"svelte",
					"vue",
				},
				root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local markers = require("lspconfig.util").insert_package_json({
						"tailwind.config.js",
						"tailwind.config.ts",
						"tailwind.config.cjs",
						"tailwind.config.mjs",
						"postcss.config.js",
						"postcss.config.ts",
					}, "tailwindcss", fname)
					local found = vim.fs.find(markers, { path = fname, upward = true })[1]
					if found then
						on_dir(vim.fs.dirname(found))
					end
				end,
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

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client:supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
					end
				end,
			})

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
