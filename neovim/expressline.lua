local generator = function()
  local builtin = require('el.builtin')
  local extensions = require('el.extensions')
  local sections = require('el.sections')
  local subscribe = require('el.subscribe')
  local helper = require('el.helper')

  local segments = {}

  table.insert(segments,
    subscribe.buf_autocmd("el_file_icon", "BufRead", function(_, buffer)
      return extensions.file_icon(_, buffer)
    end))

  table.insert(segments, builtin.file)

  table.insert(segments, extensions.mode)

  local file_namer = function(_window, buffer) return buffer.name end
  table.insert(segments, file_namer)

  table.insert(segments, extensions.git_changes)

  table.insert(segments, helper.async_buf_setter(win_id, 'el_git_stat',
    extensions.git_changes, 5000))

  return segments
end

require('el').setup { generator = generator }
