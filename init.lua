--- Globals

-- Improved loader that byte-compile and caches lua files (experimental)
vim.loader.enable()

---@type boolean Workstation machine or laptop
Workstation = vim.fn.hostname() == "hal-9002"

---Path of the neovim config folder (`~/.config/nvim`).
NeovimPath = vim.fn.stdpath("config") --[[@as string]]

---Path of the lua config (`nvim/lua/config/`).
MyConfigPath = NeovimPath .. "/lua/config/"

---Path of my custom plugins sources `outside` Nvim's rtp. (`$USR_PROJECTS_DIR/Neovim/`)
MyPluginsPath = vim.fn.expand("$USR_PROJECTS_DIR/" .. (Workstation and "Neovim/" or ""))

---Path to store scratch notes (`~/.local/share/nvim/scratchs/`)
ScratchNotesPath = vim.fn.stdpath("data") .. "/scratch/"

-- Check paths
assert(vim.fn.finddir(MyConfigPath) ~= "", "Unexpected: Missing configuration path?!")
if vim.fn.finddir(MyPluginsPath) == "" then
  vim.notify("Missing personal plugins path.", vim.log.levels.WARN)
end

-- Set global variables for vimscript env
vim.api.nvim_set_var("NeovimPath", NeovimPath)
vim.api.nvim_set_var("MyConfigPath", MyConfigPath)

--- Helper functions

local u = require("utils") ---@type Utils
u.load_utils({ debug = false })

--- Load configs

u.load("config.settings")
u.load("config.mappings")
if not u.detected_errors() then
  u.load("config.lazy")
  assert(not u.detected_errors())
end
