-- show line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- highlite current line
vim.opt.cursorline = true

-- Enable mouse support in all modes
vim.opt.mouse = "a"

-- syntax highlight + colors
vim.cmd("syntax enable")
vim.opt.termguicolors = true

-- indentations
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

-- use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Search settings
vim.opt.ignorecase = true      -- ignore case when searching
vim.opt.smartcase = true       -- but respect case if uppercase letters used
vim.opt.hlsearch = true        -- highlight search matches
vim.opt.incsearch = true       -- show search as you type

-- Split windows behavior
vim.opt.splitbelow = true      -- open horizontal splits below
vim.opt.splitright = true      -- open vertical splits right

-- Better command line completion
vim.opt.wildmenu = true

-- Show matching brackets
vim.opt.showmatch = true

-- hide modes
vim.o.showmode = false
