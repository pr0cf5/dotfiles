vim.api.nvim_create_user_command("Rename", function()
	-- Highlight all instances of the current symbol
	vim.lsp.buf.document_highlight()

	-- Prompt the user for the new name
	local current_name = vim.fn.expand("<cword>") -- Current symbol under the cursor
	local new_name = vim.fn.input("Rename [" .. current_name .. "] to: ")

	-- If the user cancels or leaves the input empty, do nothing
	if new_name == "" or new_name == nil then
		print("Rename canceled")
		vim.lsp.buf.clear_references()
		return
	end

	-- Perform the rename
	vim.lsp.buf.rename(new_name)

	-- Clear highlights after the rename
	vim.defer_fn(function()
		vim.lsp.buf.clear_references()
	end, 100) -- Add a slight delay to ensure smooth clearing
end, {})
