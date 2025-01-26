local function jump_to_location(result, method)
	if not result or vim.tbl_isempty(result) then
		print("No " .. method .. " found")
		return
	end

	local location = result[1]
	local uri = location.uri or location.targetUri
	local bufnr = vim.uri_to_bufnr(uri)
	local current_bufnr = vim.api.nvim_get_current_buf()

	-- If the definition or type definition is in another file, open it in a new tab
	if bufnr ~= current_bufnr then
		vim.cmd("tabnew")
		vim.lsp.util.jump_to_location(result[1])
	else
		-- Otherwise, just jump to the location in the same file
		vim.lsp.util.jump_to_location(result[1])
	end
end

-- Jump to definition, opening a new tab if needed
function go_to_definition()
	local params = vim.lsp.util.make_position_params()
	vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, _, _)
		jump_to_location(result, "definition")
	end)
end

-- Jump to type definition, opening a new tab if needed
function go_to_type_definition()
	local params = vim.lsp.util.make_position_params()
	vim.lsp.buf_request(0, "textDocument/typeDefinition", params, function(_, result, _, _)
		jump_to_location(result, "type definition")
	end)
end

vim.api.nvim_set_keymap("n", "gd", "<cmd>lua go_to_definition()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gdd", "<cmd>lua go_to_type_definition()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", { noremap = true, silent = true })
