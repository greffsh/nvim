return {
	"Julian/lean.nvim",
	event = { "BufReadPre *.lean", "BufNewFile *.lean" },

	dependencies = {
		"nvim-lua/plenary.nvim",

		-- optional dependencies:

		-- a completion engine
		--    hrsh7th/nvim-cmp or Saghen/blink.cmp are popular choices

		-- 'nvim-telescope/telescope.nvim', -- for 2 Lean-specific pickers
		-- 'andymass/vim-matchup',          -- for enhanced % motion behavior
		-- 'andrewradev/switch.vim',        -- for switch support
		-- 'tomtom/tcomment_vim',           -- for commenting
	},

	opts = {
		mappings = true,
	},

	-- Keybindings (LocalLeader = \):
	--   \i     toggle infoview
	--   \p     pause/unpause infoview
	--   \x     add pin to infoview
	--   \c     clear all pins
	--   \<Tab> jump to infoview
	--   \\     reverse unicode lookup for symbol under cursor
	--   \r     restart lean server
	--   \v     view infoview options
}
