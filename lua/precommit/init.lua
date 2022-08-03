local M = {}

M.foo = function()
	print("3")
end

M.execute = function()
	vim.api.nvim_command("write")

	vim.api.nvim_command("vnew")
	vim.api.nvim_create_buf({}, {})
	local split_buffer = vim.api.nvim_get_current_buf()

	vim.api.nvim_buf_set_lines(split_buffer, 0, 0, false, { "Running Pre-commit..." })

	vim.fn.jobstart({ "pre-commit", "run", "--files", "%" }, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data then
				vim.api.nvim_buf_set_lines(split_buffer, -1, -1, false, data)
			end
		end,
	})
end

return M
