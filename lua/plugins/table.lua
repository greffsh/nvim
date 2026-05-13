return {
	"dhruvasagar/vim-table-mode",
	ft = { "markdown", "text", "org" },
	config = function()
		-- Enable table mode for markdown files automatically
		vim.g.table_mode_corner = "|"
		vim.g.table_mode_corner_corner = "|"
		vim.g.table_mode_header_fillchar = "-"

		-- Use markdown-compatible tables by default
		vim.g.table_mode_delimiter = "|"

		-- Disable default mappings if you want custom ones
		-- vim.g.table_mode_disable_mappings = 1
	end,
	keys = {
		{ "<leader>tm", "<cmd>TableModeToggle<cr>", desc = "Toggle Table Mode" },
		{ "<leader>tt", "<cmd>Tableize<cr>", desc = "Tableize", mode = "v" },
		-- { "<leader>tr", "<cmd>TableModeRealign<cr>", desc = "Realign Table" },
	},
}
