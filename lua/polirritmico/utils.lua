local Utils = {}

-- Helper functions

---A wrapper of `vim.keymap.set` function.
---@param mode string|table Mode short-name
---@param key string Left-hand side of the mapping, the keys to be pressed.
---@param command string|function Right-hand side of the mapping, could be a Lua function.
---@param description? string Optional human-readable description of the mapping, default to nil.
---@param verbose? boolean Optional set to true to disable the silent-mode. Default to false.
function Utils.set_keymap(mode, key, command, description, verbose)
    local silent = verbose == nil or not verbose
    if description == nil or description == "" then
	vim.keymap.set(mode, key, command, {silent = silent})
    else
	vim.keymap.set(mode, key, command, {silent = silent, desc = description})
    end
end


---Wrapper function to pretty print variables instead of getting memory addresses.
---@vararg any
---@return any
function Utils.custom_print(...)
    local args = {...}
    local mapped = {}
    for _, variable in pairs(args) do
        table.insert(mapped, vim.inspect(variable))
    end
    print(unpack(mapped))

    return unpack(args)
end


---Function used to set a custom text when called by a fold action like zc.
---Should be setted with opt.foldtext = "v:lua.CustomFoldText()"
function Utils.fold_text()
    local first_line = vim.fn.getline(vim.v.foldstart)
    local last_line = vim.fn.getline(vim.v.foldend):gsub("^%s*", "")
    local lines_count = tostring(vim.v.foldend - vim.v.foldstart)
    local space_width = vim.api.nvim_get_option("textwidth") - #first_line - #last_line - #lines_count - 10
    return string.format(
        "%s  %s %s (%d L)", first_line, last_line, string.rep(".", space_width), lines_count
    )
end

return Utils
