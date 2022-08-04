-- This file is sourced as nvim launches, before the "main" screen appears
-- Create commands or keymaps here

vim.api.nvim_create_user_command("Precommit", "lua require('precommit').execute()", {})
