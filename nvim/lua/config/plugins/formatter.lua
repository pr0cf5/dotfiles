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
		json = {
			function()
				return {
					exe = "jq",
					args = { "." },
					stdin = true,
				}
			end,
		},
		python = {
			function()
				return {
					exe = "black",
					args = { "-" },
					stdin = true,
				}
			end,
		},
		rust = {
			function()
				return {
					exe = "rustfmt",
					args = { "--emit=stdout" },
					stdin = true,
				}
			end,
		},
		solidity = {
			function () 
				return {
					exe = "npx",
					args = { "prettier --plugin=prettier-plugin-solidity --stdin-filepath", vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end
		
		}
	},
})

vim.api.nvim_create_user_command("Format", function()
	vim.cmd("FormatWrite")
end, { desc = "Format the current buffer using formatter.nvim" })
