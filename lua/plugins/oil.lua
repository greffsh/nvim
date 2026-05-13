return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@diagnostic disable-next-line: undefined-doc-name
	---@type oil.SetupOpts
	opts = {},
	-- Optional dependencies
	--dependencies = { { "echasnovski/mini.icons", opts = {} } },
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"refractalize/oil-git-status.nvim",
	},
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = true,
			},
			win_options = {
				signcolumn = "yes:2",
			},
		})
		require("oil-git-status").setup()
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
