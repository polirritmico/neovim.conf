---A collection of custom helper functions.
---@class Utils
---@field autocmd UtilsAutoCmds
---@field config UtilsConfig
---@field custom UtilsCustom
---@field helpers UtilsHelpers
---@field plugins UtilsHelpers
---@field writing UtilsWriting
local Utils = {}

---Load the loaders
local ok, loaders = pcall(require, "utils.loaders")
if not ok then
  vim.cmd("edit " .. NeovimPath .. "/lua/utils/loaders.lua")
  error(string.format("Can't load 'utils.loaders':\n\n%s\n", loaders))
end

Utils.load = loaders.load_config
Utils.detected_errors = loaders.detected_errors

---Helper function to require utils submodules with protected calls.
---@param opts? {debug?: boolean}
function Utils.load_utils(opts)
  local load = loaders.load_config

  local debug_mode = opts and opts.debug == true
  if debug_mode then
    load("utils.helpers").set_debug()
  end

  Utils.autocmd = load("utils.autocmd") ---@type UtilsAutoCmds
  Utils.config = load("utils.config") ---@type UtilsConfig
  Utils.custom = load("utils.custom") ---@type UtilsCustom
  Utils.helpers = load("utils.helpers") ---@type UtilsHelpers
  Utils.plugins = load("utils.plugins") ---@type UtilsPlugins
  Utils.writing = load("utils.writing") ---@type UtilsWriting

  assert(not loaders.detected_errors())
end

return Utils
