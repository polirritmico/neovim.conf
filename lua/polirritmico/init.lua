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
MyPluginsPath = Workstation and vim.fn.expand("$HOME/Informática/Programación/")
    or vim.fn.expand("$HOME/Proyectos/")

assert(vim.fn.finddir(MyConfigPath) ~= "", "Error: Missing configuration path?!")
assert(vim.fn.finddir(MyPluginConfigPath) ~= "", "Error: Missing plugins path.")
assert(vim.fn.finddir(MyPluginsPath) ~= "", "Error: Missing personal plugins path.")

-- Set variables for vimscript env
vim.api.nvim_set_var("MyUser", MyUser)
vim.api.nvim_set_var("MyConfigPath", MyConfigPath)

------------------
-- Load configs --
------------------

utils.load_config("settings")
utils.load_config("mappings")

if not utils.detected_errors() then
    require(MyUser .. ".lazy")
end
