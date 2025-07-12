-- Set nvim-cmp
local cmp = require("cmp")
cmp.setup({
   snippet = {
      expand = function(args)
         vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
   },
   window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
   },
   mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
   }),
   sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "vsnip" }, -- For vsnip users.
   }, {
      { name = "buffer" },
   }),
})

-- Hover control
function hover_diagnostics_or_lsp()
   local cursor_pos = vim.api.nvim_win_get_cursor(0)
   local cursor_line = cursor_pos[1] - 1 -- Convert to 0-based indexing
   local cursor_col = cursor_pos[2]

   -- Get all diagnostics for the current buffer
   local diagnostics = vim.diagnostic.get(0)

   -- Iterate over all diagnostics
   for _, diag in ipairs(diagnostics) do
      local start_line = diag.lnum
      local start_col = diag.col
      local end_line = diag.end_lnum or start_line
      local end_col = diag.end_col or start_col

      if
         start_line ~= nil
         and end_line ~= nil
         and start_col ~= nil
         and end_col ~= nil
         and cursor_line >= start_line
         and cursor_line <= end_line
         and cursor_col >= start_col
         and cursor_col <= end_col
      then
         vim.diagnostic.open_float()
         return
      end
   end

   -- If no diagnostic found at the cursor, show the regular LSP hover
   vim.lsp.buf.hover()
end

-- Keymap to use the function (you can map it to 'hh' or any other key)
vim.keymap.set("n", "<C-h>", hover_diagnostics_or_lsp, { noremap = true, silent = true })
