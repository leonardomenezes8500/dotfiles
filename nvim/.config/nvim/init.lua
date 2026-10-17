
vim.g.mapleader = ' '

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

require('mini.align').setup()
require('mini.comment').setup()
require('mini.completion').setup()
require('mini.keymap').setup()
require('mini.move').setup()
require('mini.pairs').setup()
require('mini.splitjoin').setup()
require('mini.surround').setup()

require('mini.basics').setup({
	options      = { extra_ui              = true},
	autocommands = { relnum_in_visual_mode = true },
})
require('mini.cmdline').setup()
require('mini.files').setup()
require('mini.pick').setup()
require('mini.sessions').setup({ autoread = true })

require('mini.animate').setup()
vim.o.background = 'light'
vim.cmd('colorscheme minicyan')
require('mini.cursorword').setup()
local hipatterns = require('mini.hipatterns')
hipatterns.setup({
	highlighters = {
		fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
		hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
		todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
		note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})
require('mini.indentscope').setup()
require('mini.map').setup()
require('mini.notify').setup()
vim.notify = MiniNotify.make_notify()
require('mini.starter').setup()
require('mini.statuscolumn').setup()
require('mini.statusline').setup({ use_icons = false })
require('mini.tabline').setup({ use_icons = false })
require('mini.trailspace').setup()

vim.keymap.set('n', '<Leader>ff', '<Cmd>lua MiniFiles.open()<CR>')
vim.keymap.set('n', '<Leader>pp', "<Cmd>lua MiniPick.start({ source = { items = vim.fn.readdir('.') } })<CR>")
vim.keymap.set('n', '<Leader>pf', "<Cmd>lua MiniPick.builtin.files()<CR>")
vim.keymap.set('n', '<Leader>pg', "<Cmd>lua MiniPick.builtin.grep_live()<CR>")
vim.keymap.set('n', '<Leader>p?', "<Cmd>lua MiniPick.builtin.help()<CR>")
vim.keymap.set('n', '<Leader>pb', "<Cmd>lua MiniPick.builtin.buffers()<CR>")
vim.keymap.set('n', '<Leader>oj', "<Cmd>lua MiniSplitjoin.toggle()<CR>")
vim.keymap.set('n', '<Leader>om', "<Cmd>lua MiniMap.toggle()<CR>")
vim.keymap.set('n', '<Leader>ot', "<Cmd>lua MiniTrailspace.trim()<CR>")

