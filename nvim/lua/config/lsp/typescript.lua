-- solidity
local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

configs.ts_ls.config = {
   default_config = {
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
   },
}

lspconfig.ts_ls.setup({})
