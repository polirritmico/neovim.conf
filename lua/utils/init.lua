---A collection of custom helper functions.
---@class Utils
---@field autocmd UtilsAutoCmds
---@field config UtilsConfig
---@field custom UtilsCustom
---@field helpers UtilsHelpers
---@field plugins UtilsPlugins
---@field writing UtilsWriting
local Utils = {}

---Load the loaders
local ok, loaders = pcall(require, "utils.loaders")
if not ok then
  vim.cmd("edit " .. NeovimPath .. "/lua/utils/loaders.lua")
  error(string.format("Can't load 'utils.loaders':\n\n%s\n", loaders))
end

Utils.load = loaders.load_config
Utils.check_errors = loaders.check_errors

---Helper function to require utils submodules with protected calls.
---@param opts? {debug?: boolean}
function Utils.load_utils(opts)
  local load = loaders.load_config

  Utils.autocmd = load("utils.autocmd")
  Utils.config = load("utils.config")
  Utils.custom = load("utils.custom")
  Utils.helpers = load("utils.helpers")
  Utils.plugins = load("utils.plugins")
  Utils.writing = load("utils.writing")

  assert(loaders.check_errors())

  if opts and opts.debug then
    Utils.helpers.set_debug()
  end
end

return Utils
