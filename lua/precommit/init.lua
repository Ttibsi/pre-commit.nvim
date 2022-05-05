-- :lua require("precommit").PreCommit()
local function PreCommit()
 
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
    -- Open a new vertical split
    -- Run pre-commit in the new split and display output
        -- ideally with colour
    -- Reload buffer if needed
end

return {
    PreCommit = PreCommit
}
