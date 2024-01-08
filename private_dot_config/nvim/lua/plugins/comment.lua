return {
	"numToStr/Comment.nvim",
	opts = {
		padding = true,
		ignore = nil,
		toggler = {
			---Line-comment toggle keymap
			line = "gcc",
			---Block-comment toggle keymap
			block = "gbc",
		},
		mappings = {
			basic = true,
			extra = true,
		},
	},
	lazy = false,
}
