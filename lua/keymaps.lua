-- define common options
local opts = {
    noremap = true,
    silent = true,
}

local map = vim.keymap.set

---------------
-- All modes --
---------------

-- easy commands
map({'n', 'v', 's', 'o'}, ';', ':', opts)


-----------------
-- Normal mode --
-----------------

-- Better window navigation
map('n', '<C-j>', '<C-w>h', opts)
map('n', '<C-k>', '<C-w>j', opts)
map('n', '<C-i>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
-- delta: 2 lines
map('n', '<C-Up>', ':resize -2<CR>', opts)
map('n', '<C-Down>', ':resize +2<CR>', opts)
map('n', '<C-Left>', ':vertical resize -2<CR>', opts)
map('n', '<C-Right>', ':vertical resize +2<CR>', opts)

map('n', 'h', 'i', opts)
-- arrow like hjkl
map("n", "i", "k", opts) -- up
map("n", "j", "h", opts) -- left
map("n", "k", "j", opts) -- down

-----------------
-- Visual mode --
-----------------

map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

map("v", "i", "k", opts)
map("v", "j", "h", opts)
map("v", "k", "j", opts)
map("v", "l", "l", opts)

---------------------------
-- Operator pending mode --
---------------------------

map("o", "i", "k", opts)
map("o", "j", "h", opts)
map("o", "k", "j", opts)
map("o", "l", "l", opts)


-------------------
-- Terminal mode --
-------------------

map("t", "<Esc>", [[<C-\><C-n>]])
