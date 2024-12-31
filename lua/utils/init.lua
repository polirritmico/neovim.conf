---A collection of custom helper functions.
---@class MyUtils
---@field autocmd MyUtilsAutoCmds
---@field config MyUtilsConfig
---@field custom MyUtilsCustom
---@field helpers MyUtilsHelpers
---@field plugins MyUtilsPlugins
---@field writing MyUtilsWriting
local MyUtils = {}

---Load the loaders
local ok, loaders = pcall(require, "utils.loaders")
if not ok then
  vim.cmd("edit " .. NeovimPath .. "/lua/utils/loaders.lua")
  error(string.format("Can't load 'utils.loaders':\n\n%s\n", loaders))
end

MyUtils.load = loaders.load_config
MyUtils.check_errors = loaders.check_errors

---Helper function to require utils submodules with protected calls.
---
---Could set a DAP debug session through `opts.debug` and `opts.auto_init`.
---@param opts? {debug?: boolean, auto_start?: boolean}
function MyUtils.load_utils(opts)
  if opts and opts.debug then
    loaders.set_debugger(opts.auto_start)
  end

  local load = loaders.load_config
  MyUtils.autocmd = load("utils.autocmd")
  MyUtils.config = load("utils.config")
  MyUtils.custom = load("utils.custom")
  MyUtils.helpers = load("utils.helpers")
  MyUtils.plugins = load("utils.plugins")
  MyUtils.writing = load("utils.writing")

  assert(loaders.check_errors())
end

return MyUtils
