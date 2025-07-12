local lspconfig = require("lspconfig")
local caps = require("cmp_nvim_lsp").default_capabilities()
lspconfig.pyright.setup({ capabilities = caps })

local function set_python_path(path)
   -- Ensure the path is valid
   if vim.fn.filereadable(path) == 0 and vim.fn.isdirectory(path) == 0 then
      vim.api.nvim_err_writeln("Invalid Python path: " .. path)
      return
   end

   -- Reload the pyright server with the new Python interpreter path
   require("lspconfig").pyright.setup({
      settings = {
         python = {
            pythonPath = path,
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
   require("lspconfig").pyright.setup({
      settings = {
         python = {
            venvPath = path,
            pythonPath = python_interpreter,
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
