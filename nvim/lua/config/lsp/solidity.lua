-- solidity
local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

configs.solidity = {
   default_config = {
      cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
      filetypes = { "solidity" },
      root_dir = lspconfig.util.find_git_ancestor,
   },
}

lspconfig.solidity.setup({})
