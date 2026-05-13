return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "-", "<cmd>Yazi<cr>", desc = "Open yazi at current file" },
		{ "<leader>y", "<cmd>Yazi<cr>", desc = "Open yazi at current file" },
		{ "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "Open yazi in working directory" },
		{ "<c-up>", "<cmd>Yazi toggle<cr>", desc = "Resume last yazi session" },
	},
	---@type YaziConfig
	opts = {
		open_for_directories = true,
		keymaps = {
			show_help = "<f1>",
		},
	},
}
