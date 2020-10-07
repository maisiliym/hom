niovi = {}

niovi.fileUrlEdit = function(url)
  local pattern = "^file://(.*)"
  local _, _, filePath = string.find(url, pattern)
  if vim.fn.isdirectory(filePath) then
    niv.tri.lib.change_dir(filePath)
    niv.tri.open()
  else
    command('edit '..filePath)
  end
end

-- vim:sw=2 ts=2 et
