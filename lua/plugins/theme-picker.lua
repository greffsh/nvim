return {
	"zaldih/themery.nvim",
	lazy = false,
	keys = {
		{ "<leader>th", ":Themery<CR>", desc = "Theme picker" },
	},
	config = function()
		require("themery").setup({
			themes = {
				"gruvbox",
				{
					name = "gruvbox-light",
					colorscheme = "gruvbox",
					before = [[vim.o.background = "light"]],
				},
				"catppuccin-latte",
				"catppuccin-frappe",
				"catppuccin-macchiato",
				"catppuccin-mocha",
				"kanagawa",
			},
			livePreview = true,
		})
	end,
}
