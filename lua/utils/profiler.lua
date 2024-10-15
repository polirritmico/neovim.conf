---Utils profiler wrapper for [https://github.com/stevearc/profile.nvim](https://github.com/stevearc/profile.nvim)
---@class UtilsProfiler
---@field setup fun(manual_start: boolean):UtilsProfiler|nil
---@field start? function
---@field stop? function
local UtilsProfiler = {}

---Setup the profiler
---
---> ***WARNING:*** This uses **a lot** of memory so keep it short (like >5MB/s).
---
---**Usage:**
---
---- **Automatic profile:**
---  1. Set the start point with `require("utils.profiler").setup()`
---  2. Set the end point with the `stop` function or manually press <F11> to
---     stop the recording:
---  ```lua
---  local profiler = require("utils.profiler").setup()
---  -- code section to profile...
---  profiler.stop()
---  ```
---  3. Start Neovim with the env variable: `NVIM_PROFILE=1 nvim`. Without this
---     no automatic or manual profile is enabled.
---  4. The output json log profile could be open with Firefox here:
---     [https://profiler.firefox.com/](https://profiler.firefox.com/)
---
---- **Basic profile (manual mode):**
---  1. Setup the profiler in manual mode: `require("utils.profiler").setup(true)`
---  2. Press the <F11> key to start/stop the recording or use the `start` and
---     `stop` functions:
---  ```lua
---  local profiler = require("utils.profiler").setup(true)
---  profiler.start()
---  -- code section to profile...
---  profiler.stop()
---  ```
---> **Notes:**
---> - `steverarc/profile.nvim` must be installed in the lazy path, but no
---    lazy.nvim intervention is required.
---> - `Noice` must be disable or the plugin would raise errors
---@param manual_start? boolean Set to `true` to enable the manual mode.
---@return UtilsProfiler
function UtilsProfiler.setup(manual_start)
  local key = "<F11>"
  local mod_profiler_path = vim.fn.stdpath("data") .. "/lazy/profile.nvim"
  local profiler_mod

  local function load_profiler()
    vim.opt.rtp:append(mod_profiler_path)
    profiler_mod = require("profile")
    -- Only run the setup once
    UtilsProfiler.setup = function() end
  end

  local function start()
    if not profiler_mod.is_recording() then
      vim.notify("Profiling...")
      profiler_mod.start("*")
    end
  end

  ---@param filename string
  local function write_profile_file(filename)
    if filename then
      profiler_mod.export(filename)
      vim.notify(string.format("\nDone. Wrote %s", filename))
      -- The Firefox profiler needs a valid json object, so lets use jq:
      if vim.fn.executable("jq") == 1 then
        vim.notify("Formating the profile log with jq...")
        local out = vim.system({ "jq", ".", filename }):wait()
        local file = io.open(filename, "w")
        if file then
          file:write(out.stdout)
          file:close()
          vim.notify("Formatted.")
        else
          vim.notify("Could not write the file " .. filename)
          return
        end
        vim.notify("Done. Open with https://profiler.firefox.com/")
      else
        vim.notify("'jq' not found. Unformatted profile log", vim.log.levels.WARN)
      end
    else
      vim.notify(string.format("Discarded profile"))
    end
  end

  local function stop()
    if profiler_mod.is_recording() then
      profiler_mod.stop()

      local input_opts = {
        prompt = "Save profile to: ",
        completion = "file",
        default = "profile.json",
      }
      vim.ui.input(input_opts, write_profile_file)
    end
  end

  local function toggler()
    if profiler_mod.is_recording() then
      stop()
    else
      start()
    end
  end

  if manual_start == true then
    -- start: key or start()
    -- stop: key or stop()
    load_profiler()
    UtilsProfiler.start = start
    UtilsProfiler.stop = stop
    vim.keymap.set("", key, toggler)
  elseif os.getenv("NVIM_PROFILE") then
    -- start: Auto
    -- stop: key or stop()
    load_profiler()
    UtilsProfiler.start = function() end
    UtilsProfiler.stop = stop
    vim.keymap.set("", key, UtilsProfiler.stop)

    vim.notify("Profiling...")
    profiler_mod.instrument_autocmds()
    profiler_mod.start("*")
  else
    -- start: None. Error msg.
    -- stop: None
    UtilsProfiler.stop = function() end
    UtilsProfiler.start = function()
      local msg = "Use `NVIM_PROFILE=1` or `set_profiler(true)` to enable the profiler"
      vim.notify(msg, vim.log.levels.ERROR)
    end
    vim.keymap.set("", key, UtilsProfiler.start)
  end

  return UtilsProfiler
end

return UtilsProfiler
