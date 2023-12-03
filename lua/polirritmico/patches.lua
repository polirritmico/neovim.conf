--- Lazy Pre/After patcher
M = {}

---@param path string
---@param cmd string[] git command to execute
---@patam error_level number? log level for errors. Hide if nil or false
local git_execute = function(path, cmd, error_level)
    local command = { "git", "-C", path, unpack(cmd) }
    local command_output = vim.fn.system(command)
    if vim.v.shell_error ~= 0 then
        if error_level then
            M.error(command, command_output, error_level)
        end
        return { success = false, output = command_output }
    end
    return { success = true, output = command_output }
end


------------------------------------------------------------------------------


local patches_path = vim.fn.stdpath("config") .. "/patches/"
local lazy_path = vim.fn.stdpath("data") .. "/lazy/"

---@param name string Name of the plugin repository
---@param plugin_path string Full path of the plugin repository
M.restore_repo = function(name, plugin_path)
    vim.notify("[patches: " .. name .. "] Restoring plugin repository ...", 0)
    git_execute(plugin_path, { "restore", "." })
    vim.notify("[patches: " .. name .. "] Done", 0)
end

---@param name string Name of the plugin repository
---@param patch_path string Full path of the patch file
---@param plugin_path string Full path of the plugin repository
M.apply_patch = function(name, patch_path, plugin_path)
    vim.notify("[patches: " .. name .. "] Applying patch...", 0)
    git_execute(plugin_path, { "apply", "--ignore-space-change", patch_path })
    vim.notify("[patches: " .. name .. "] Done", 0)
end

local group_id = vim.api.nvim_create_augroup("LazyPatches", {})

vim.api.nvim_create_autocmd("User", {
    desc = "Apply/clean patches when Lazy events are triggered.",
    pattern = {
        "LazySync*", -- before/after running sync.
        "LazyInstall*", -- before/after an install
        "LazyUpdate*", -- before/after an update
        "LazyCheck*", -- before/after checking for updates
    },
    group = group_id,
    callback = function(info)
        -- vim.notify(vim.inspect(info), 0)
        for patch in vim.fs.dir(patches_path) do
            local patch_path = patches_path .. patch
            local repo_path = lazy_path .. patch:gsub("%.patch", "")
            -- if vim.uv.fs_stat(repo_path) then
            if vim.loop.fs_stat(repo_path) then
                M.restore_repo(patch, repo_path)
                if not info.match:match("Pre$") then
                    M.apply_patch(patch, patch_path, repo_path)
                end
            end
        end
    end,
})


M.restore_all = function()
    for patch in vim.fs.dir(patches_path) do
        local repo_path = lazy_path .. patch:gsub("%.patch", "")
        M.restore_repo(patch, repo_path)
    end
end

M.apply_all = function()
    for patch in vim.fs.dir(patches_path) do
        local patch_path = patches_path .. patch
        local repo_path = lazy_path .. patch:gsub("%.patch", "")
        M.apply_patch(patch, patch_path, repo_path)
    end
end

return M
