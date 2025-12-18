return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({})

        local builtin = require('telescope.builtin')

        -- File finding
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})  -- Git files only (faster)

        -- Grep/Search
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})  -- Live grep as you type

        -- Search word under cursor
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pw', builtin.grep_string, {})  -- Alternative for word search

        -- Recent files (SUPER useful!)
        vim.keymap.set('n', '<leader>pr', builtin.oldfiles, {})

        -- Current buffer fuzzy find
        vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, {})

        -- Help tags (search Vim help)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})

        -- Resume last Telescope search
        vim.keymap.set('n', '<leader>pc', builtin.resume, {})

        -- Git commits
        vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})

        -- Diagnostics (all your LSP errors/warnings)
        vim.keymap.set('n', '<leader>pd', builtin.diagnostics, {})

        -- Buffers
        vim.keymap.set('n', '<leader>bb', builtin.buffers, {})
    end
}
