---@diagnostic disable: unused-local
return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"prettierd",
				"biome",
				"ruff",
				"prettypst",
			},
			run_on_start = true,
			auto_update = false,
		},
	},
	{
		"stevearc/conform.nvim",
		opts = function()
			local prettier_markers = {
				".prettierrc",
				".prettierrc.json",
				".prettierrc.yaml",
				".prettierrc.yml",
				".prettierrc.js",
				".prettierrc.cjs",
				".prettierrc.mjs",
				".prettierrc.toml",
				"prettier.config.js",
				"prettier.config.cjs",
				"prettier.config.mjs",
			}

			local function select_formatter(bufnr)
				local file = vim.api.nvim_buf_get_name(bufnr)
				if vim.fs.root(file, { "biome.json", "biome.jsonc" }) then
					return { "biome" }
				end
				if vim.fs.root(file, prettier_markers) then
					return { "prettierd" }
				end
				return {}
			end

			return {
				formatters = {
					biome = {
						args = { "check", "--write", "--unsafe", "--stdin-file-path", "$FILENAME" },
					},
					ruff_format = {
						command = "ruff",
						args = { "format", "--stdin-filename", "$FILENAME", "-" },
						stdin = true,
					},
				},
				formatters_by_ft = {
					javascript = select_formatter,
					typescript = select_formatter,
					javascriptreact = select_formatter,
					typescriptreact = select_formatter,
					html = select_formatter,
					css = select_formatter,
					scss = { "prettierd" },
					json = { "prettierd" },
					jsonc = { "prettierd" },
					markdown = { "prettierd" },
					["markdown.mdx"] = { "prettierd" },
					lua = { "stylua" },
					python = { "ruff_format" },
					rust = { "rustfmt" },
					typst = { "prettypst" },
					go = { "gofumpt" },
					gleam = { "gleam" },
				},
				format_on_save = {
					timeout_ms = 2000,
					lsp_fallback = "never",
				},
			}
		end,
	},
}
