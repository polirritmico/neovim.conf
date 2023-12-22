-------------
-- Globals --
-------------

--- Variables
MyUser = "polirritmico"
MyConfigPath = vim.fn.stdpath("config") .. "/lua/" .. MyUser .. "/"
MyPluginConfigPath = vim.fn.stdpath("config") .. "/after/plugin/"
MyPluginsPath = vim.fn.expand("$HOME") .. "/Informática/Programación"

--- Helper functions
local utils = require(MyUser .. ".utils")
P = utils.custom_print
CustomFoldText = utils.fold_text
