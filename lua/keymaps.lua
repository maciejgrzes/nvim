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

-- Terminal
map("n", "<leader>t", ":split | terminal<CR>")
map("n", "<leader>vt", ":vsplit | terminal<CR>")

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

-----------------
-- Visual mode --
-----------------

map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)


-------------------
-- Terminal mode --
-------------------

map("t", "<Esc>", [[<C-\><C-n>]])
