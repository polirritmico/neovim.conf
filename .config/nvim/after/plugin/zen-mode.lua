-- Zen Mode
if type(packer_plugins) ~= "table" or packer_plugins["zen-mode"] == nil then
	return
end

require("zen-mode").setup({
    window = {
        width = 91,
        height = 1,
        --options = {
        --    cursorline = false,
        --},
    },
})
