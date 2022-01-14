local status_ok, neogit = pcall(require, "neogit")

if not status_ok then
  vim.notify("Unable to load neogit")
  return
end

neogit.setup {}
