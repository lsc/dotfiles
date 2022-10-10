local dgo_status_ok, dgo = pcall(require, 'dap-go')

if not dgo_status_ok then return end

local dui_status_ok, dui = pcall(require, 'dapui')

if not dui_status_ok then return end

dgo.setup()
dui.setup()
