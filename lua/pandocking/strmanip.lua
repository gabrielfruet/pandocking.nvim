local M = {}

--- @param fstring string
--- @return string | nil substitute_fstring_or_error
function M.subs(fstring, values)
    local required_vars = M.extract_fstring_vars(fstring)

    local result = fstring

    for _, var in pairs(required_vars) do
        local value = values[var]
        if value == nil then
            return nil
        end
        result = M.substitute_fstring_var(result, var, value)
    end

    return result
end

--- @param fstring string
--- @return string[] variables
function M.extract_fstring_vars(fstring)
    local vars = {}
    local seen = {}

    for var in fstring:gmatch("{([%w_]+)}") do
        if not seen[var] then
            table.insert(vars, var)
            seen[var] = true
        end
    end

    return vars
end

--- @param fstring string
--- @param variable string
--- @param value string
--- @return string substituted_fstring
function M.substitute_fstring_var(fstring, variable, value)
    local pattern = string.format("{%s}", variable)
    local result = fstring:gsub(pattern, value)

    return result
end


return M
