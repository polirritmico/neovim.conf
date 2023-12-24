--- Mason Tool Installer

return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    enabled = false,
    lazy = false,
}

-- TODO: autoinstall debugpy, and then install pytest inside its venv

-- local function install_pytest_inside_debygpy_venv(event)
--     local function debugpy_installed_check(_event)
--         for _, pkg in pairs(_event) do
--             if pkg == "debugpy" then return true end
--         end
--         return false
--     end
--     if not debugpy_installed_check(event) then return end
--
--     local ok, mason_registry, debugpy
--     ok, mason_registry = pcall(require, "mason-registry")
--     if not ok then
--         vim.notify("[mason-tool-installer] Missing mason-registry.", vim.log.levels.ERROR)
--         return
--     end
--     ok, debugpy = pcall(mason_registry.get_package, mason_registry, "debugpy")
--     if not ok then
--         vim.notify("[mason-tool-installer] debugpy missing from mason-registry.", vim.log.levels.ERROR)
--         return
--     end
--
--     local venv_path = debugpy:get_install_path() .. "/venv/bin/"
--     local cmd_str = "source " .. venv_path .. "activate; python -m pip install pytest; deactivate"
--     vim.api.nvim_cmd(vim.api.nvim_parse_cmd(cmd_str, {}))
-- end

