return {
	"navarasu/onedark.nvim",
	lazy = false,
	name = "onedark",
	priority = 1000,
	config = function()
		-- Onedark Theme configs
		require("onedark").setup({
			style = "darker",
		})
		require("onedark").load()
	end,
}
