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
		vim.keymap.set("n", "<C-a>", ":Neotree filesystem toggle left<CR>", { desc = "[a] Open Neotree" })
		vim.keymap.set("n", "<leader>a", ":Neotree focus<CR>", { desc = "[a] Change the focus back to Neotree" })
	end,
}
