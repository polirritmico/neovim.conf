--- Globals

---@type string Username follows `lua` folder's module path and hold all configs.
MyUser = "polirritmico"
---@type boolean true on workstation machine or false for laptop.
Workstation = true

-- Helper functions

local utils = require(MyUser .. ".utils") ---@type Utils
P = utils.custom_print
CustomFoldText = utils.fold_text

-- Paths

---@type string -- Path of the neovim config folder
NeovimPath = vim.fn.stdpath("config")
---@type string -- Path of the lua config. (`nvim/lua/MyUser/`)
MyConfigPath = NeovimPath .. "/lua/" .. MyUser .. "/"
---@type string -- Path of my custom plugins sources outside Nvim's rtp.
MyPluginsPath = Workstation and vim.fn.expand("$HOME/Informática/Programación/")
  or vim.fn.expand("$HOME/Proyectos/")

-- Check paths
assert(vim.fn.finddir(MyConfigPath) ~= "", "Error: Missing configuration path?!")
assert(vim.fn.finddir(MyPluginsPath) ~= "", "Error: Missing personal plugins path.")

-- Set variables for vimscript env
vim.api.nvim_set_var("MyUser", MyUser)
vim.api.nvim_set_var("MyConfigPath", MyConfigPath)
vim.api.nvim_set_var("NeovimPath", NeovimPath)

--- Load configs

utils.load_config("settings")
utils.load_config("mappings")
if not utils.detected_errors() then
  require(MyUser .. ".lazy")
end
