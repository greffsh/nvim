vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.clipboard = ""

vim.keymap.set({ "n", "x" }, "y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set({ "n", "x" }, "Y", '"+Y', { desc = "Yank line to system clipboard" })

vim.keymap.set("n", "<leader>w", ":w!<CR>", { desc = "Force write" })

local function force_quit()
	if vim.bo.filetype == "lean" then
		pcall(function()
			require("lean.infoview").close()
		end)
		vim.cmd("q!")
		return
	end

	if vim.bo.filetype == "leaninfo" then
		local ok, infoview = pcall(require, "lean.infoview")
		local source_win = nil

		if ok then
			local current_infoview = infoview.get_current_infoview()
			source_win = current_infoview and current_infoview.last_window and current_infoview.last_window.id
			pcall(infoview.close)
		else
			vim.cmd("q!")
			return
		end

		if source_win and vim.api.nvim_win_is_valid(source_win) then
			vim.api.nvim_set_current_win(source_win)
			vim.cmd("q!")
		end
		return
	end

	vim.cmd("q!")
end

vim.keymap.set("n", "<leader>q", force_quit, { desc = "Force quit" })
vim.keymap.set("n", "<leader>R", ":checktime<CR>", { desc = "Reload buffer if changed on disk" })

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

-- Floating notes window (toggle ~/todo.md)
local notes_path = vim.fn.expand("~/todo.md")
local notes_win = nil

local function toggle_notes()
	-- Already open? close it (write if modified)
	if notes_win and vim.api.nvim_win_is_valid(notes_win) then
		local buf = vim.api.nvim_win_get_buf(notes_win)
		if vim.bo[buf].modified then
			vim.api.nvim_buf_call(buf, function()
				vim.cmd("silent write")
			end)
		end
		vim.api.nvim_win_close(notes_win, true)
		notes_win = nil
		return
	end

	-- Find or create the buffer for the file
	local buf = vim.fn.bufnr(notes_path, true)
	if vim.api.nvim_buf_get_name(buf) == "" then
		vim.api.nvim_buf_set_name(buf, notes_path)
	end
	vim.fn.bufload(buf)

	local width = math.floor(vim.o.columns * 0.7)
	local height = math.floor(vim.o.lines * 0.8)
	notes_win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " todo.md ",
		title_pos = "center",
	})
	-- q closes the float in this buffer only
	vim.keymap.set("n", "q", toggle_notes, { buffer = buf, desc = "Close notes float" })
end

vim.keymap.set("n", "<leader>n", toggle_notes, { desc = "Toggle floating notes (~/todo.md)" })

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
