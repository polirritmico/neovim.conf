---Functions for text-based writing tasks beyond code.
---@class UtilsWriting
local Writing = {}

-- NOTE: To create the compiled dict from dic and aff files use:
-- `:mkspell output input`. e.g. For `es_CL.aff` and `es_CL.dic` files, the
-- command should be: `:mkspell es es_CL` (in config/spell dir).

---Enables spell checkers for the specified language.
---@param lang string Language ISO-like string. _E.g. es_CL, es, en, etc._
function Writing.dict_on(lang)
  if vim.api.nvim_get_option_value("spelllang", {}) ~= lang then
    vim.opt.spelllang = lang
  end
  vim.opt.spell = true
  vim.notify("Spell enabled " .. lang)
end

---Disable spell checkers and unset the `spelllang` variable.
function Writing.dict_off()
  if vim.api.nvim_get_option_value("spelllang", {}) == "" then
    return
  end
  vim.opt.spelllang = ""
  vim.opt.spell = false
  vim.notify("Spell disabled")
end

---This function enables the **TwoColumns** mode, which splits the current
---buffer into two synced column-like windows, resembling newspapers articles.
---- **Usage**: `:TwoColumns`. To end just close one of the windows.
function Writing.set_two_columns_mode()
  vim.cmd([[
    command! TwoColumns exe "normal zR" | set noscrollbind | vsplit
      \ | set scrollbind | wincmd w | exe "normal \<c-f>" | set scrollbind | wincmd p
  ]])
end

return Writing
