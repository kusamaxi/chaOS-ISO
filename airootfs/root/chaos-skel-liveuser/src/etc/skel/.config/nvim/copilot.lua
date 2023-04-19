return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "VimEnter",
		config = function()
			vim.defer_fn(function()
				require("copilot").setup({
					filetypes = {
						yaml = true,
						markdown = false,
						help = false,
						gitcommit = false,
						gitrebase = false,
						hgcommit = false,
						svn = false,
						cvs = false,
						["."] = false,
					},
					suggestion = {
						enabled = true,
						auto_trigger = true,
						keymap = {},
					},
				})
			end, 100)
		end,
	},
}
