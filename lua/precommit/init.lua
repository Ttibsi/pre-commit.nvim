local M = {}

local function relative_height(height)
	return math.floor(height * vim.o.lines)
end
local function relative_width(width)
	return math.floor(width * vim.o.columns)
end
local function center_height(height)
	return (vim.o.lines - height) / 2
end
local function center_width(width)
	return (vim.o.columns - width) / 2
end

local function set_local_keymaps(win, buf)
	vim.keymap.set("n", "q", "<cmd>q!<cr>", {
		silent = true,
		buffer = buf,
		desc = "close pre-commit window",
	})
	vim.keymap.set("n", "<esc>", "<cmd>q!<cr>", {
		silent = true,
		buffer = buf,
		desc = "close pre-commit window",
	})
end
local function set_local_options(win, buf)
	vim.cmd([[setlocal filetype=precommit]])
end

local function make_window_opts()
	local width = relative_width(0.9)
	local height = relative_height(0.9)
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		col = center_width(width),
		row = center_height(height),
		anchor = "NW",
		style = "minimal",
		border = "single",
	}
	return opts
end

M.execute = function()
	vim.api.nvim_command("update")
	local filename = vim.fn.expand("%")

	vim.notify("Running Pre-commit...", vim.log.levels.INFO)

	vim.fn.jobstart({ "pre-commit", "run", "--files", filename }, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if not data then
				vim.notify(
					"Pre-commit failed to send data",
					vim.log.levels.ERROR
				)
			end

			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, true, data)
			local opts = make_window_opts()
			local win = vim.api.nvim_open_win(buf, true, opts)
			set_local_keymaps(win, buf)
			set_local_options(win, buf)
		end,
	})
end

return M
