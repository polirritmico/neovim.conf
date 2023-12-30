-------------
-- Globals --
-------------

MyUser = "polirritmico"

--- Set paths
local utils = require(MyUser .. ".utils")

MyConfigPath = vim.fn.stdpath("config") .. "/lua/" .. MyUser .. "/"
MyPluginConfigPath = MyConfigPath .. "plugins/"
local custom_plugins_path = vim.fn.expand("$HOME/Informática/Programación/")
MyPluginsPath = utils.check_paths(custom_plugins_path) and custom_plugins_path
    or vim.fn.expand("$HOME/Proyectos/")

assert(vim.fn.finddir(MyConfigPath) ~= "", "Error: Missing configuration path?!")
assert(vim.fn.finddir(MyPluginConfigPath) ~= "", "Error: Missing plugins path.")
assert(vim.fn.finddir(MyPluginsPath) ~= "", "Error: Missing personal plugins path.")

--- Helper functions
P = utils.custom_print
CustomFoldText = utils.fold_text

------------------
-- Load configs --
------------------

utils.load_config("settings")
utils.load_config("mappings")

if not utils.detected_errors() then
    require(MyUser .. ".lazy")
end
