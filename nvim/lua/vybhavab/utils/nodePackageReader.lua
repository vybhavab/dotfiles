local xo_dependency_checked = false
local has_xo_in_dependencies = false

local function check_xo_dependency()
    if xo_dependency_checked then
        return has_xo_in_dependencies
    end
    local path = vim.fn.getcwd() .. '/package.json'
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        file:close()
        local status, json = pcall(vim.json.decode, content)
        if status then
            if json.dependencies and json.dependencies.xo or json.devDependencies and json.devDependencies.xo then
                has_xo_in_dependencies = true
            end
        end
    end
    xo_dependency_checked = true
    return has_xo_in_dependencies
end

return {
    check_xo_dependency = check_xo_dependency
}
