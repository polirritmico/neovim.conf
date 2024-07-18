--- Globals

-- Improved loader that byte-compile and caches lua files (experimental)
vim.loader.enable()

---@type boolean Workstation machine or laptop
Workstation = vim.fn.hostname() == "hal-9002"

-- Helper functions

local ok, u = pcall(require, "utils") ---@type boolean, Utils
if not ok then
  vim.notify("Error loading utils. Using fallback config", vim.log.levels.ERROR)
  require("config.fallback.settings")
  require("config.fallback.mappings")
  return
end

-- Paths

---Path of the neovim config folder (`~/.config/nvim`).
NeovimPath = vim.fn.stdpath("config") --[[@as string]]
---Path of the lua config (`nvim/lua/config/`).
MyConfigPath = NeovimPath .. "/lua/config/"
---Path of my custom plugins sources `outside` Nvim's rtp. (`$USR_PROJECTS_DIR/Neovim/`)
MyPluginsPath = vim.fn.expand("$USR_PROJECTS_DIR/" .. (Workstation and "Neovim/" or ""))
---Path to store scratch notes (`~/.local/share/nvim/scratchs`)
ScratchNotesPath = vim.fn.stdpath("data") .. "/scratch/"

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
