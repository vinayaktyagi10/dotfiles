vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- FORCE GOOD HABITS: Disable arrow keys
vim.keymap.set({"n", "v", "i"}, "<Up>", "<Nop>")
vim.keymap.set({"n", "v", "i"}, "<Down>", "<Nop>")
vim.keymap.set({"n", "v", "i"}, "<Left>", "<Nop>")
vim.keymap.set({"n", "v", "i"}, "<Right>", "<Nop>")

-- Also disable mouse (optional but recommended)
vim.opt.mouse = ""

-- Move lines in visual mode (UNCOMMENT WHEN READY)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

-- Good habits: Keep cursor centered
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")

-- Clipboard operations
vim.keymap.set("x", "<leader>p", [["_dP]])  -- Paste without yanking
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])  -- Yank to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")  -- Delete without yanking

-- IMPORTANT: Remap Ctrl-C to Esc (fixes many issues)
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable Q (you'll accidentally hit it)
vim.keymap.set("n", "Q", "<nop>")

-- Quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Find and replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Go error handling
vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

-- Restart LSP (useful when things break)
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- Toggle AI completion (Supermaven)
vim.keymap.set("n", "<leader>ai", "<cmd>SupermavenToggle<cr>")

-- Source current file (reload config) - only for Lua/Vim files
vim.keymap.set("n", "<leader><leader>", function()
    local ft = vim.bo.filetype
    if ft == "lua" or ft == "vim" then
        vim.cmd("so")
        print("Config reloaded!")
    else
        print("Can only source Lua/Vim files. Current file: " .. ft)
    end
end)

-- ============================================================================
-- WINDOW MANAGEMENT
-- ============================================================================

-- Split windows
vim.keymap.set("n", "<leader>sv", "<C-w>v")     -- Split vertical
vim.keymap.set("n", "<leader>sh", "<C-w>s")     -- Split horizontal
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>") -- Close current split

-- Navigate between splits
vim.keymap.set("n", "<leader>wh", "<C-w>h")  -- Left
vim.keymap.set("n", "<leader>wl", "<C-w>l")  -- Right
vim.keymap.set("n", "<leader>wj", "<C-w>j")  -- Down
vim.keymap.set("n", "<leader>wk", "<C-w>k")  -- Up

-- Resize splits
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>")
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>")
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- Make splits equal size
vim.keymap.set("n", "<leader>se", "<C-w>=")

-- ============================================================================
-- BUFFER MANAGEMENT
-- ============================================================================

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>")      -- Shift+L next buffer
vim.keymap.set("n", "<S-h>", ":bprevious<CR>")  -- Shift+H previous buffer

-- Close buffer without closing window
vim.keymap.set("n", "<leader>bd", ":bd<CR>")

-- Close all buffers except current
vim.keymap.set("n", "<leader>bo", ":%bd|e#|bd#<CR>")

-- ============================================================================
-- LANGUAGE-SPECIFIC RUN COMMANDS
-- ============================================================================

-- Smart run: compiles/runs based on filetype
vim.keymap.set("n", "<leader>r", function()
    vim.cmd("w")  -- Save first
    local ft = vim.bo.filetype
    local filename = vim.fn.expand("%:t:r")
    local filepath = vim.fn.expand("%:p")
    local filedir = vim.fn.expand("%:p:h")

    if ft == "java" then
        vim.cmd("!" .. "cd " .. filedir .. " && javac " .. filename .. ".java && java " .. filename)
    elseif ft == "c" then
        vim.cmd("!" .. "cd " .. filedir .. " && gcc " .. filename .. ".c -o " .. filename .. " && ./" .. filename)
    elseif ft == "cpp" then
        vim.cmd("!" .. "cd " .. filedir .. " && g++ " .. filename .. ".cpp -o " .. filename .. " && ./" .. filename)
    elseif ft == "python" then
        vim.cmd("!" .. "python " .. filepath)
    elseif ft == "javascript" then
        vim.cmd("!" .. "node " .. filepath)
    elseif ft == "go" then
        vim.cmd("!" .. "go run " .. filepath)
    elseif ft == "rust" then
        vim.cmd("!" .. "cargo run")
    elseif ft == "lua" or ft == "vim" then
        vim.cmd("so")
        print("Config reloaded!")
    else
        print("No run command for filetype: " .. ft)
    end
end)

-- Java: Compile and run current file
vim.keymap.set("n", "<leader>jr", function()
    vim.cmd("w")
    local filename = vim.fn.expand("%:t:r")
    local filedir = vim.fn.expand("%:p:h")
    vim.cmd("!" .. "cd " .. filedir .. " && javac " .. filename .. ".java && java " .. filename)
end)

-- Java: Just compile (no run)
vim.keymap.set("n", "<leader>jc", function()
    vim.cmd("w")
    local filename = vim.fn.expand("%:t:r")
    local filedir = vim.fn.expand("%:p:h")
    vim.cmd("!" .. "cd " .. filedir .. " && javac " .. filename .. ".java")
end)

-- C: Compile and run
vim.keymap.set("n", "<leader>cr", function()
    vim.cmd("w")
    local filename = vim.fn.expand("%:t:r")
    local filedir = vim.fn.expand("%:p:h")
    vim.cmd("!" .. "cd " .. filedir .. " && gcc " .. filename .. ".c -o " .. filename .. " && ./" .. filename)
end)

-- Open terminal in split below
vim.keymap.set("n", "<leader>tt", function()
    vim.cmd("split")
    vim.cmd("terminal")
    vim.cmd("resize 15")
end)

-- ============================================================================
-- HELPFUL REMINDERS
-- ============================================================================

vim.keymap.set("n", "<leader>?", function()
    print("=== ESSENTIAL COMMANDS ===")
    print("NAVIGATION: gd (definition) | K (hover) | <C-o> (back) | <C-i> (forward)")
    print("FILES: <leader>pf (find) | <leader>pr (recent) | <leader>ps (grep)")
    print("BUFFERS: <S-h>/<S-l> (prev/next) | <leader>bb (list) | <leader>bd (close)")
    print("WINDOWS: <leader>sv/sh (split) | <leader>wh/j/k/l (navigate)")
    print("CLIPBOARD: <leader>y (copy) | <leader>p (paste no yank) | <leader>d (delete no yank)")
    print("RUN CODE: <leader>r (smart run) | <leader>jr (java) | <leader>cr (c)")
    print("TEXT OBJECTS: ciw ci\" ci{ di( dap yip")
    print("VISUAL: V (line) | v (char) | <C-v> (block)")
    print("MACROS: qa (record) | q (stop) | @a (replay)")
    print("MARKS: ma (set) | 'a (jump)")
    print("AI: <leader>ai (toggle)")
end)

-- Quick reference for text objects
vim.keymap.set("n", "<leader>?t", function()
    print("=== TEXT OBJECTS ===")
    print("ciw = change inside word")
    print("ci\" = change inside quotes")
    print("ci{ = change inside braces")
    print("di( = delete inside parens")
    print("dap = delete around paragraph")
    print("yip = yank inside paragraph")
    print("vit = visual inside tag (HTML)")
    print("Replace 'c' with: d (delete), y (yank), v (visual)")
end)
