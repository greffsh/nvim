vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "<leader>w", ":w!<CR>", { desc = "Force write" })
vim.keymap.set("n", "<leader>q", ":q!<CR>", { desc = "Force quit" })

-- Window navigation with wrapping in all directions
local function wrap_window(direction, opposite)
	local current_win = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. direction)
	local new_win = vim.api.nvim_get_current_win()
	if current_win == new_win then
		-- Hit edge, wrap to opposite side
		vim.cmd("wincmd " .. opposite)
	end
end

vim.keymap.set("n", "<C-w>l", function()
	wrap_window("l", "h")
end, { noremap = true, desc = "Move right or wrap to left" })
vim.keymap.set("n", "<C-w>h", function()
	wrap_window("h", "l")
end, { noremap = true, desc = "Move left or wrap to right" })
vim.keymap.set("n", "<C-w>j", function()
	wrap_window("j", "k")
end, { noremap = true, desc = "Move down or wrap to top" })
vim.keymap.set("n", "<C-w>k", function()
	wrap_window("k", "j")
end, { noremap = true, desc = "Move up or wrap to bottom" })

-- File-level back/forward navigation (replaces jumplist <C-o>/<C-i>)
local file_history = {}
local file_history_idx = 0
local navigating = false

local function record_buf(buf)
	if navigating then
		return
	end
	-- Only track normal file buffers (skip neo-tree, telescope, quickfix, etc.)
	if vim.bo[buf].buftype ~= "" then
		return
	end
	local name = vim.api.nvim_buf_get_name(buf)
	if name == "" then
		return
	end
	if file_history[file_history_idx] == buf then
		return
	end
	-- Truncate forward history when visiting a new file
	for i = file_history_idx + 1, #file_history do
		file_history[i] = nil
	end
	table.insert(file_history, buf)
	file_history_idx = #file_history
end

vim.api.nvim_create_augroup("FileHistory", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
	group = "FileHistory",
	callback = function(ev)
		record_buf(ev.buf)
	end,
})

vim.keymap.set("n", "<A-o>", function()
	navigating = true
	while file_history_idx > 1 do
		file_history_idx = file_history_idx - 1
		local target = file_history[file_history_idx]
		if target and vim.api.nvim_buf_is_valid(target) then
			vim.api.nvim_set_current_buf(target)
			break
		end
	end
	navigating = false
end, { noremap = true, desc = "Go to previously visited file" })

vim.keymap.set("n", "<A-i>", function()
	navigating = true
	while file_history_idx < #file_history do
		file_history_idx = file_history_idx + 1
		local target = file_history[file_history_idx]
		if target and vim.api.nvim_buf_is_valid(target) then
			vim.api.nvim_set_current_buf(target)
			break
		end
	end
	navigating = false
end, { noremap = true, desc = "Go to next visited file" })

vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = "YankHighlight",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

vim.diagnostic.config({
	underline = true,
	virtual_text = false,
	signs = {
		text = {
			-- [vim.diagnostic.severity.ERROR] = "●",
			-- [vim.diagnostic.severity.WARN] = "●",
			-- [vim.diagnostic.severity.INFO] = "●",
			-- [vim.diagnostic.severity.HINT] = "●",
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "⚠",
			[vim.diagnostic.severity.INFO] = "ℹ",
			[vim.diagnostic.severity.HINT] = "→",
		},
	},
})
