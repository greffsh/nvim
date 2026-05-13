return {
	"folke/trouble.nvim",
	opts = {
		keys = {
			["<cr>"] = "jump_close",
		},
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>e",
			"<cmd>Trouble diagnostics open filter.buf=0 focus=true<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>E",
			"<cmd>Trouble diagnostics toggle focus=true<cr>",
			desc = "Project Diagnostics (Trouble)",
		},
		{
			"<leader>c",
			"<cmd>Trouble diagnostics close<cr>",
			desc = "Close Trouble",
		},
	},
}
