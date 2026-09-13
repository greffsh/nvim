return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>gs", builtin.git_status, {
				desc = "Git changed files",
			})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			local actions = require("telescope.actions")

			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-q>"] = false,
							["<C-e>"] = actions.send_to_qflist + actions.open_qflist,
						},
						n = {
							["<C-q>"] = false,
							["<C-e>"] = actions.send_to_qflist + actions.open_qflist,
						},
					},
					layout_config = {
						horizontal = {
							preview_width = 0.6,
							preview_cutoff = 80,
						},
					},
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					winblend = 0,
					preview = {
						treesitter = false, -- Disable treesitter preview if it causes issues
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
							winblend = 0,
						}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
