--- Globals

-- Improved loader that byte-compile and caches lua files (experimental)
vim.loader.enable()

---@type boolean Workstation machine or laptop
Workstation = vim.fn.hostname() == "hal-9002"

-- Helper functions

local u = require("utils") ---@type Utils
P = u.helpers.print_wrapper

-- Paths

---@type string Path of the neovim config folder (`~/.config/nvim`).
---@diagnostic disable [assign-type-mismatch]
NeovimPath = vim.fn.stdpath("config")
---@type string Path of the lua config (`nvim/lua/config/`).
MyConfigPath = NeovimPath .. "/lua/config/"
---@type string Path of my custom plugins sources `outside` Nvim's rtp.
MyPluginsPath = Workstation and vim.fn.expand("$USR_PROJECTS_DIR/Neovim/")
  or vim.fn.expand("$USR_PROJECTS_DIR/")
---@type string Path to store scratch notes (`~/.local/share/nvim/scratchs`)
ScratchNotesPath = vim.fn.stdpath("data") .. "/scratch"

-- Check paths
assert(vim.fn.finddir(MyConfigPath) ~= "", "Unexpected: Missing configuration path?!")
if vim.fn.finddir(MyPluginsPath) == "" then
  vim.notify("Missing personal plugins path.", vim.log.levels.WARN)
end

-- Set global variables for vimscript env
vim.api.nvim_set_var("NeovimPath", NeovimPath)
vim.api.nvim_set_var("MyConfigPath", MyConfigPath)

--- Load configs

u.config.load_config("settings")
u.config.load_config("mappings")
if not u.config.detected_errors() then
  require("config.lazy")
end
