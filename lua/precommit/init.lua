---@return fun()
local function quit_map()
	return function()
		vim.cmd.quit({ bang = true })
	end
end

---@param height number
---@return integer
local function relative_height(height)
	return math.floor(height * vim.o.lines)
end

---@param width number
---@return integer
local function relative_width(width)
	return math.floor(width * vim.o.columns)
end

---@param height integer
---@return integer
local function center_height(height)
	return math.floor((vim.o.lines - height) / 2)
end

---@param width integer
---@return integer
local function center_width(width)
	return math.floor((vim.o.columns - width) / 2)
end

---@param buf integer
local function set_local_keymaps(buf)
	vim.keymap.set("n", "q", quit_map(), {
		silent = true,
		buffer = buf,
		desc = "Close pre-commit window",
	})
	vim.keymap.set("n", "<Esc>", quit_map(), {
		silent = true,
		buffer = buf,
		desc = "Close pre-commit window",
	})
end

---@param buf integer
local function set_local_options(buf)
	vim.api.nvim_set_option_value("filetype", "precommit", { buf = buf })
	-- or
	-- vim.api.nvim_set_option_value("filetype", "precommit", { scope = "local" })
end

---@return vim.api.keyset.win_config
local function gen_window_opts()
	local width = relative_width(0.9)
	local height = relative_height(0.9)

	---@type vim.api.keyset.win_config
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

---@class pre_commit.nvim
local M = {}

function M.execute()
	vim.api.nvim_command("update")
	local filename = vim.fn.expand("%")

	vim.notify("Running Pre-commit...", vim.log.levels.INFO)

	vim.fn.jobstart({ "pre-commit", "run", "--files", filename }, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if not data then
				vim.notify("Pre-commit failed to send data", vim.log.levels.ERROR)
			end

			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, true, data)
			vim.api.nvim_open_win(buf, true, gen_window_opts())
			set_local_keymaps(buf)
			set_local_options(buf)
		end,
	})
end

return M
