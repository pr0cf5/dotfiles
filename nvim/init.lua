-- configure lazy
require("config.lazy")

-- basics
require("config.core")

-- configure LSP
require("config.lsp.python")
require("config.lsp.solidity")
require("config.lsp.others")
require("config.lsp.typescript")

-- configure nvim-tree
require("config.plugins.nvim-tree")

-- configure codeql
require("config.plugins.codeql")

-- configure cmp and hover behavior
require("config.plugins.cmp")

-- configure ai related tools 
require("config.plugins.ai")

-- configure xrefs
require("config.plugins.xrefs")

-- configure formatter
require("config.plugins.formatter")

-- configure rename
require("config.lsp.rename")
