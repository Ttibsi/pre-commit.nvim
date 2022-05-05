-- :lua require("precommit").PreCommit()
local function PreCommit()
    print('hello pre-commit')

    -- Check if pre-commit is installed
        -- If not, give user an error
    -- Save current buffer
    -- Open a new vertical split
    -- Run pre-commit in the new split and display output
        -- ideally with colour
    -- Reload buffer if needed
end

return {
    PreCommit = PreCommit
}
