return {
	"zaldih/themery.nvim",
	lazy = false,
	keys = {
		{ "<leader>th", ":Themery<CR>", desc = "Theme picker" },
	},
	config = function()
		require("themery").setup({
			themes = {
				-- always add custom configs here so then can be loaded with the theme picker
				"onedark_vivid",
				"nightfox",
				"everforest",
				{
					name ="gruvbox-light",
					colorscheme = "gruvbox",
					before = [[vim.o.background = "light"]]
				},
				"catppuccin-frappe",
				"catppuccin-latte",
				"catppuccin-mocha",
				"catppuccin-macchiato",
				"ayu",
				"ayu-dark",
				"kanagawa",
				{
					name = "solarized",
					colorscheme = "solarized",
					before = [[vim.o.background = "light"]],
				},
			},
			livePreview = true,
		})
	end,
}
