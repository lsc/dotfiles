local status_ok, bqf = pcall(require, "bqf")

if not status_ok then
  vim.notify("Unable to load bqf")
  return
end

bqf.setup()
