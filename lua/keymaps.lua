-- define common options
local opts = {
    noremap = true,
    silent = true,
}

local map = vim.keymap.set
local allModes = {'n', 'v', 's', 'o'}

---------------
-- All modes --
---------------

-- easy commands
map(allModes, ';', ':', opts)

-----------------
-- Normal mode --
-----------------

-- Terminal
map("n", "<leader>t", ":split | terminal<CR>")
map("n", "<leader>vt", ":vsplit | terminal<CR>")

-- Better window navigation
map('n', '<C-Left>', '<C-w>h', opts) -- left
map('n', '<C-Down>', '<C-w>j', opts) -- down
map('n', '<C-Up>', '<C-w>k', opts) -- up
map('n', '<C-Right>', '<C-w>l', opts) -- right

-- Resize with arrows
-- delta: 2 lines
map('n', '<C-S-Up>', ':resize -2<CR>', opts)
map('n', '<C-S-Down>', ':resize +2<CR>', opts)
map('n', '<C-S-Left>', ':vertical resize -2<CR>', opts)
map('n', '<C-S-Right>', ':vertical resize +2<CR>', opts)

-----------------
-- Visual mode --
-----------------

map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)


-------------------
-- Terminal mode --
-------------------

map("t", "<Esc>", [[<C-\><C-n>]])
