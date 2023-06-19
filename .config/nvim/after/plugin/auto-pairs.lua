-- Auto-pairs
if type(packer_plugins) ~= "table" or packer_plugins["auto-pairs"] == nil then
	return
end

vim.g.AutoPairsFlyMode = 0 -- Enables/disables Fly mode

