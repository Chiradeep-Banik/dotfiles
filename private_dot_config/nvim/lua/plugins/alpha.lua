--[[ 
	Plugin to modify the home screen
]]
return {
	"goolord/alpha-nvim",
	config = function()
		require("alpha").setup(require("alpha.themes.dashboard").config)
	end,
}
