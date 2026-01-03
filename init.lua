-- nvim config by yours truly
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require('options')
require('keymaps')
require('plugins')
require('theme')
require("ibl").setup()

vim.cmd [[
  " Link bufferline highlight groups to normal theme groups
  hi! link BufferLineFill Normal
  hi! link BufferLineBackground Normal
  hi! link BufferLineBufferVisible Normal
  hi! link BufferLineBufferSelected Normal
  hi! link BufferLineSeparator Normal
  hi! link BufferLineSeparatorSelected Normal
  hi! link BufferLineSeparatorVisible Normal
  hi! link BufferLineCloseButton Normal
  hi! link BufferLineCloseButtonVisible Normal
  hi! link BufferLineCloseButtonSelected Normal
  hi! link BufferLineModified Normal
]]
