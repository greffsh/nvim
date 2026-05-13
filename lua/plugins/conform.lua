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
				"rustfmt",
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
			local function select_formatter(bufnr)
				local cwd = vim.fn.getcwd()
				if vim.fn.filereadable(cwd .. "/biome.json") == 1 then
					return { "biome" }
				else
					return { "prettierd" }
				end
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
				},
				format_on_save = {
					timeout_ms = 2000,
					lsp_fallback = false,
				},
			}
		end,
	},
}
