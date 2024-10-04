-- configure lazy
require("config.lazy")

-- configure LSP
local lspconfig = require("lspconfig")
local caps = require("cmp_nvim_lsp").default_capabilities()
lspconfig.lua_ls.setup({ capabilities = caps })
lspconfig.bashls.setup({ capabilities = caps })
lspconfig.clangd.setup({ capabilities = caps })
lspconfig.rust_analyzer.setup({ capabilities = caps })
lspconfig.pyright.setup({ capabilities = caps })

-- solidity
local configs = require 'lspconfig.configs'

configs.solidity_ls_nomicfoundation = {
  default_config = {
    cmd = {'nomicfoundation-solidity-language-server', '--stdio'},
    filetypes = { 'solidity' },
    root_dir = lspconfig.util.find_git_ancestor,

  },
}

lspconfig.solidity_ls_nomicfoundation.setup {}

-- Python
local function set_python_path(path)
  -- Ensure the path is valid
  if vim.fn.filereadable(path) == 0 and vim.fn.isdirectory(path) == 0 then
    vim.api.nvim_err_writeln("Invalid Python path: " .. path)
    return
  end

  -- Reload the pyright server with the new Python interpreter path
  require('lspconfig').pyright.setup({
    settings = {
      python = {
        pythonPath = path
      },
    },
  })

  -- Restart the LSP server for Pyright to apply the new settings
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == "pyright" then
      client.stop()
      vim.cmd("LspStart pyright")
      break
    end
  end

  vim.api.nvim_out_write("Pyright Python path set to: " .. path .. "\n")
end



-- Create the :SetPythonPath command
vim.api.nvim_create_user_command("SetPythonPath", function(opts)
  set_python_path(opts.args)
end, {
  nargs = 1, -- Require exactly one argument (the Python path)
  complete = "file", -- Use file completion for the argument
})

local function set_venv_path(path)
  -- Ensure the path is valid
  if vim.fn.isdirectory(path) == 0 then
    vim.api.nvim_err_writeln("Invalid virtualenv path: " .. path)
    return
  end

  -- Set the virtual environment's Python interpreter path
  local python_interpreter = path .. "/bin/python"
  if vim.fn.filereadable(python_interpreter) == 0 then
    vim.api.nvim_err_writeln("Python interpreter not found in: " .. python_interpreter)
    return
  end

  -- Reload the Pyright server with the new virtualenv path
  require('lspconfig').pyright.setup({
    settings = {
      python = {
        venvPath = path,
        pythonPath = python_interpreter
      },
    },
  })

  -- Restart the LSP server for Pyright to apply the new settings
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == "pyright" then
      client.stop()
      vim.cmd("LspStart pyright")
      break
    end
  end

  vim.api.nvim_out_write("Pyright virtualenv path set to: " .. path .. "\n")
end

-- Create the :SetVenvPath command
vim.api.nvim_create_user_command("SetVenvPath", function(opts)
  set_venv_path(opts.args)
end, {
  nargs = 1, -- Require exactly one argument (the Python path)
  complete = "file", -- Use file completion for the argument
})

-- set line numbers
vim.wo.number = true

require("format").setup({})

-- Set formatter commands
function format_cmd()
	local mode = vim.fn.mode()
	if mode == "v" then
		require("format").format_selection()
	else
		require("format").format()
	end
end

function black_format_cmd()
	local filename = vim.fn.expand("%:p")
	if not string.match(filename, "%.py$") then
		vim.api.nvim_err_writeln("Not a Python file: " .. filename)
		return
	end
	vim.fn.system("python3 -m black " .. filename)
end

vim.api.nvim_create_user_command("Format", format_cmd, { nargs = 0 })
vim.api.nvim_create_user_command("BlackFormat", black_format_cmd, { nargs = 0 })

vim.cmd([[colorscheme tokyonight-storm]])

-- Set nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 30,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
	git = {
		ignore = false,
	},
})

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

-- Copilot
require("CopilotChat").setup({ debug = true })

-- Goto Definition / Type Definition
local function jump_to_location(result, method)
  if not result or vim.tbl_isempty(result) then
    print('No ' .. method .. ' found')
    return
  end

  local location = result[1]
  local uri = location.uri or location.targetUri
  local bufnr = vim.uri_to_bufnr(uri)
  local current_bufnr = vim.api.nvim_get_current_buf()

  -- If the definition or type definition is in another file, open it in a new tab
  if bufnr ~= current_bufnr then
    vim.cmd('tabnew')
    vim.lsp.util.jump_to_location(result[1])
  else
    -- Otherwise, just jump to the location in the same file
    vim.lsp.util.jump_to_location(result[1])
  end
end

-- Jump to definition, opening a new tab if needed
function go_to_definition()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, result, _, _)
    jump_to_location(result, "definition")
  end)
end

-- Jump to type definition, opening a new tab if needed
function go_to_type_definition()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, function(_, result, _, _)
    jump_to_location(result, "type definition")
  end)
end

vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua go_to_definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gdd', '<cmd>lua go_to_type_definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', { noremap = true, silent = true })
