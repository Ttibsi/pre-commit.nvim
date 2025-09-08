---@class pre_commit.nvim
local M = {}

---@type pre_commit.Opts
M.options = {}

local function quit_map()
	vim.cmd.quit({ bang = true })
end

---@param height number
---@return integer
local function relative_height(height)
	if vim.fn.has("nvim-0.11") == 1 then
		vim.validate("height", height, "number", false)
	else
		vim.validate({ height = { height, "number" } })
	end

	return math.floor(height * vim.o.lines)
end

---@param width number
---@return integer
local function relative_width(width)
	if vim.fn.has("nvim-0.11") == 1 then
		vim.validate("width", width, "number", false)
	else
		vim.validate({ width = { width, "number" } })
	end

	return math.floor(width * vim.o.columns)
end

---@param height integer
---@return integer
local function center_height(height)
	if vim.fn.has("nvim-0.11") == 1 then
		vim.validate("height", height, "number", false)
	else
		vim.validate({ height = { height, "number" } })
	end

	return math.floor((vim.o.lines - height) / 2)
end

---@param width integer
---@return integer
local function center_width(width)
	if vim.fn.has("nvim-0.11") == 1 then
		vim.validate("width", width, "number", false)
	else
		vim.validate({ width = { width, "number" } })
	end

	return math.floor((vim.o.columns - width) / 2)
end

---@param buf integer
local function set_local_keymaps(buf)
	if vim.fn.has("nvim-0.11") == 1 then
		vim.validate("buf", buf, "number", false, "integer")
	else
		vim.validate({ buf = { buf, "number" } })
	end

	vim.keymap.set("n", "q", quit_map, {
		silent = true,
		buffer = buf,
		desc = "Close pre-commit window",
	})
	vim.keymap.set("n", "<Esc>", quit_map, {
		silent = true,
		buffer = buf,
		desc = "Close pre-commit window",
	})
end

---@param buf integer
local function set_local_options(buf)
	if vim.fn.has("nvim-0.11") == 1 then
		vim.validate("buf", buf, "number", false, "integer")
	else
		vim.validate({ buf = { buf, "number" } })
	end

	vim.api.nvim_set_option_value("filetype", "precommit", { buf = buf })
	-- or
	-- vim.api.nvim_set_option_value("filetype", "precommit", { scope = "local" })

	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
	vim.api.nvim_set_option_value("number", false, { scope = "local" })
	vim.api.nvim_set_option_value("signcolumn", "no", { scope = "local" })
	vim.api.nvim_set_option_value("modifiable", false, { scope = "local" })
end

---@return vim.api.keyset.win_config
local function gen_window_opts()
	local width = relative_width(M.options.width_factor or 0.9)
	local height = relative_height(M.options.height_factor or 0.9)

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
		zindex = M.options.zindex or 60,
	}
	return opts
end

---@param opts pre_commit.Opts
function M.setup(opts)
	if vim.fn.has("nvim-0.11") == 1 then
		vim.validate("opts", opts, "table", true, "pre_commit.Opts")
	else
		vim.validate({ opts = { opts, { "nil", "table" } } })
	end
	opts = opts or {}

	---@class pre_commit.Opts
	local defaults = {
		width_factor = 0.9,
		height_factor = 0.9,
		zindex = 60,
	}

	M.options = vim.tbl_deep_extend("keep", opts, defaults)
end

function M.execute()
	vim.cmd.update()
	vim.notify("Running Pre-commit...", vim.log.levels.INFO)
	local filename = vim.fn.expand("%")

	vim.fn.jobstart({ "pre-commit", "run", "--files", filename }, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if not data then
				error("Pre-commit failed to send data", vim.log.levels.ERROR)
			end

			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, true, data)
			local opts = gen_window_opts()
			vim.api.nvim_open_win(buf, true, opts)
			set_local_keymaps(buf)
			set_local_options(buf)
		end,
	})
end

return M

-- vim:ts=4:sts=4:sw=0:noet:ai:si:sta:
