return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		--Telescope Configs
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[f] Fuzzily search files" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[h] Fuzzily search help tags" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[g] Fuzzily Live Grep" })
		vim.keymap.set("n", "<leader>f/", function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })
	end,
}
