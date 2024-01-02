-------------
-- Globals --
-------------

MyUser = "polirritmico"
Workstation = true

--- Helper functions
local utils = require(MyUser .. ".utils")
P = utils.custom_print
CustomFoldText = utils.fold_text

--- Set paths
MyConfigPath = vim.fn.stdpath("config") .. "/lua/" .. MyUser .. "/"
MyPluginConfigPath = MyConfigPath .. "plugins/"
MyPluginsPath = vim.fn.finddir(vim.fn.expand("$HOME/Informática/Programación/"))
if MyPluginsPath == "" then
    MyPluginsPath = vim.fn.expand("$HOME/Proyectos/")
end

assert(vim.fn.finddir(MyConfigPath) ~= "", "Error: Missing configuration path?!")
assert(vim.fn.finddir(MyPluginConfigPath) ~= "", "Error: Missing plugins path.")
assert(vim.fn.finddir(MyPluginsPath) ~= "", "Error: Missing personal plugins path.")

------------------
-- Load configs --
------------------

utils.load_config("settings")
utils.load_config("mappings")

if not utils.detected_errors() then
    require(MyUser .. ".lazy")
end
