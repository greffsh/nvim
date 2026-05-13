return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "LspAttach",
	priority = 1000,
	config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "ghost",
			transparent_bg = true,
			transparent_cursorline = true,
			options = {
				show_source = { enabled = false },
				set_arrow_to_diag_color = true,
			},
		})
		vim.diagnostic.config({ virtual_text = false })
	end,
}
