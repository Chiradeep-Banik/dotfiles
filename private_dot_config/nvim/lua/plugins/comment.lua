-- Plugin to convert ant line into comments

return {
	"numToStr/Comment.nvim",
	opts = {
		padding = true,
		ignore = nil,
		toggler = {
			---Line-comment toggle keymap
			line = "<C-_>",
		},
		opleader = {
			---Line-comment keymap
			line = "<C-_>",
			---Block-comment keymap
			block = "gb",
		},
		mappings = {
			basic = true,
			extra = true,
		},
	},
	lazy = false,
}
