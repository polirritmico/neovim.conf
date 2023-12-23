-------------
-- Globals --
-------------

MyUser = "polirritmico"

--- Set paths
MyConfigPath = vim.fn.stdpath("config") .. "/lua/" .. MyUser .. "/"
MyPluginConfigPath = MyConfigPath .. "plugins/"
MyPluginsPath = vim.fn.expand("$HOME/Informática/Programación/")

assert(vim.fn.finddir(MyConfigPath) ~= "", "Error: Missing configuration path?!")
assert(vim.fn.finddir(MyPluginConfigPath) ~= "", "Error: Missing plugins path.")
assert(vim.fn.finddir(MyPluginsPath) ~= "", "Error: Missing own plugins path.")

--- Helper functions
local utils = require(MyUser .. ".utils")

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
