return {
	"numToStr/Comment.nvim",
	opts = {
		-- Comment.nvim does not have a built-in entry for Neovim's `env` filetype.
		pre_hook = function()
			if vim.bo.filetype == "env" then
				return "# %s"
			end
		end,
	},
	lazy = false,
}
