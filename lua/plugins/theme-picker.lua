return {
	"zaldih/themery.nvim",
	lazy = false,
	keys = {
		{ "<leader>th", ":Themery<CR>", desc = "Theme picker" },
	},
	config = function()
		require("themery").setup({
			themes = {
				{
					name = "gruvbox",
					colorscheme = "gruvbox",
					before = [[vim.o.background = "dark"]],
				},
				{
					name = "gruvbox-light",
					colorscheme = "gruvbox",
					before = [[vim.o.background = "light"]],
				},
				{
					name = "catppuccin-latte",
					colorscheme = "catppuccin-latte",
					before = [[vim.o.background = "light"]],
				},
				{
					name = "catppuccin-frappe",
					colorscheme = "catppuccin-frappe",
					before = [[vim.o.background = "dark"]],
				},
				{
					name = "catppuccin-macchiato",
					colorscheme = "catppuccin-macchiato",
					before = [[vim.o.background = "dark"]],
				},
				{
					name = "catppuccin-mocha",
					colorscheme = "catppuccin-mocha",
					before = [[vim.o.background = "dark"]],
				},
				{
					name = "kanagawa",
					colorscheme = "kanagawa",
					before = [[vim.o.background = "dark"]],
				},
				{
					name = "koda",
					colorscheme = "koda",
					before = [[vim.o.background = "dark"]],
				},
				{
					name = "bonatto dark",
					colorscheme = "atomonedark_matte",
					before = [[vim.o.background = "dark"]],
				},
				{
					name = "bonatto light",
					colorscheme = "atomonelight_matte",
					before = [[vim.o.background = "light"]],
				},
				{
					name = "one half light",
					colorscheme = "onehalflight",
					before = [[vim.o.background = "light"]],
				},
				{
					name = "one half dark",
					colorscheme = "onehalfdark",
					before = [[vim.o.background = "dark"]],
				},
			},
			livePreview = true,
		})
	end,
}
