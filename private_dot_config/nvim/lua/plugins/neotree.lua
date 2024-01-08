return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim",
	},
	config = function()
		-- Neo-Tree Keymaps
		vim.keymap.set("n", "<C-a>", ":Neotree filesystem reveal left<CR>", { desc = "[a] Open Neotree" })
	end,
}
