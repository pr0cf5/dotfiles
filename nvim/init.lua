-- configure lazy
require("config.lazy")

-- basics
require("config.core")

-- configure LSP
require("config.lsp.python")
require("config.lsp.solidity")
require("config.lsp.others")

-- configure nvim-tree
require("config.plugins.nvim-tree")

-- configure cmp and hover behavior
require("config.plugins.cmp")

-- configure copilot
require("config.plugins.copilot")

-- configure xrefs 
require("config.plugins.xrefs")

-- configure formatter
require("config.plugins.formatter")

-- configure rename
require("config.lsp.rename")
