return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	opts = {
		preview = {
			enable = false,
		},
	},
	keys = {
		{
			"<leader>m",
			"<cmd>Markview<cr>",
			desc = "Toggle Markview preview",
		},
		{
			"<leader>s",
			"<cmd>Markview splitToggle<cr>",
			desc = "Toggle Markview split view",
		},
	},

	-- Completion for `blink.cmp`
	-- dependencies = { "saghen/blink.cmp" },
}
