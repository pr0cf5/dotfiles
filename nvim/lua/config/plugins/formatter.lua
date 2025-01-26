require("formatter").setup({
	filetype = {
		lua = {
			function()
				return {
					exe = "stylua",
					args = { "--search-parent-directories", "-" },
					stdin = true,
				}
			end,
		},
	},
})

vim.api.nvim_create_user_command("Format", function()
	vim.cmd("FormatWrite")
end, { desc = "Format the current buffer using formatter.nvim" })
