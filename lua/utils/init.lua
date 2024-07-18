---A collection of custom helper functions.
---@class Utils
local Utils = {}

Utils.autocmd = require("utils.autocmd")
Utils.config = require("utils.config")
Utils.custom = require("utils.custom")
Utils.helpers = require("utils.helpers")
Utils.plugins = require("utils.plugins")
Utils.writing = require("utils.writing")

P = Utils.helpers.print_wrapper

return Utils
