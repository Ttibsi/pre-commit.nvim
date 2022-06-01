-- :lua require("precommit").PreCommit()
local function PreCommit()
    local cmd = "pre-commit run --files %"

    -- Check if pre-commit is installed
        -- If not, give user an error
    if os.execute("python3 -m pip list | grep pre-commit") ~= 0 then
        print("Pre-commit is not installed")
    elseif os.execute("git ls-files | grep pre-commit") == 256 then
        print("No pre-commit-config found")
    else
        print('hello pre-commit')
    end

    -- Save current buffer
    vim.api.nvim_command('write')

    -- Open a new vertical split
    vim.cmd[[ 85vsplit ]]

    -- Run pre-commit in the new split and display output
        -- ideally with colour
    vim.api.nvim_call_function('termopen ', {cmd})

    -- Reload buffer if needed
    vim.api.nvim_command('e %')

end

return {
    PreCommit = PreCommit
}
