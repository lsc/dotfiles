local status_ok, aerial = pcall(require, "aerial")

if not status_ok then
  vim.notify("Unable to load aerial")
  return
end

aerial.setup {}

local tele_status_ok, telescope = pcall(require, "telescope")

if not tele_status_ok then
  return
end

telescope.load_extension('aerial')
