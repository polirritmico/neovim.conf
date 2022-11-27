-------------------
-- Neovim config --
-------------------

-- Using Packer as plugin manager:
--      https://github.com/wbthomason/packer.nvim
-- Config file: ~/.config/nvim/lua/plugins.lua
-- This should go after mappings
require("plugins")

-- Config file: ~/.config/nvim/lua/settings.lua
-- This should go first
require("settings")

-- Config file: ~/.config/nvim/lua/mappings.lua
require("mappings")

-- Config file: ~/.config/nvim/lua/globals.lua
-- Global helper LUA functions
require("globals")

-- Macros file: ~/.config/nvim/lua/macros.lua
require("macros")

