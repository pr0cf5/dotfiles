local function get_offset_encoding()
   local bufnr = vim.api.nvim_get_current_buf()
   local clients = vim.lsp.get_clients({ bufnr = bufnr })
   for _, client in ipairs(clients) do
      if client.offset_encoding then
         return client.offset_encoding
      end
   end
   return "utf-16"
end

local function jump_to_location(result, method, position_encoding)
   if not result or vim.tbl_isempty(result) then
      print("No " .. method .. " found")
      return
   end

   local location = result[1]
   local uri = location.uri or location.targetUri
   local opts = { focus = true, reuse_win = true }
   vim.lsp.util.show_document(result[1], position_encoding, opts)
end

-- Jump to definition, opening a new tab if needed
function go_to_definition()
   local winid = vim.api.nvim_get_current_win()
   local position_encoding = get_offset_encoding()
   local params = vim.lsp.util.make_position_params(winid, position_encoding)
   vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, _, _)
      jump_to_location(result, "definition", position_encoding)
   end)
end

-- Jump to type definition, opening a new tab if needed
function go_to_type_definition()
   local winid = vim.api.nvim_get_current_win()
   local position_encoding = get_offset_encoding()
   local params = vim.lsp.util.make_position_params(winid, position_encoding)
   vim.lsp.buf_request(0, "textDocument/typeDefinition", params, function(_, result, _, _)
      jump_to_location(result, "type definition", position_encoding)
   end)
end

vim.api.nvim_set_keymap("n", "gd", "<cmd>lua go_to_definition()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gdd", "<cmd>lua go_to_type_definition()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", { noremap = true, silent = true })
