return {
	"romus204/tree-sitter-manager.nvim",
	lazy = false,
	config = function()
		require("tree-sitter-manager").setup({
			auto_install = true,
			highlight = true,
		})
	end,
}
