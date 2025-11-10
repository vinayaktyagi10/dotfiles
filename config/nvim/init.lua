-- ~/.config/nvim/init.lua - Simplified DevOps Setup (No Mason)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	spec = {
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },

		-- Language support (minimal)
		{ import = "lazyvim.plugins.extras.lang.docker" },
		{ import = "lazyvim.plugins.extras.lang.yaml" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.lang.markdown" },

		-- Database support
		{
			"tpope/vim-dadbod",
			dependencies = {
				"kristijanhusak/vim-dadbod-ui",
				"kristijanhusak/vim-dadbod-completion",
			},
			config = function()
				-- Auto-completion for SQL
				vim.api.nvim_create_autocmd("FileType", {
					pattern = { "sql", "mysql", "plsql" },
					callback = function()
						require("cmp").setup.buffer({
							sources = {
								{ name = "vim-dadbod-completion" },
								{ name = "buffer" },
							},
						})
					end,
				})

				-- DBUI settings
				vim.g.db_ui_use_nerd_fonts = 1
				vim.g.db_ui_show_database_icon = 1
				vim.g.db_ui_force_echo_notifications = 1
				vim.g.db_ui_win_position = "left"
				vim.g.db_ui_winwidth = 40

				-- Save queries in a specific location
				vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui_queries"

				-- Execute query shortcuts
				vim.g.db_ui_execute_on_save = 0
			end,
			keys = {
				{ "<leader>du", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
				{ "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Find buffer in DBUI" },
				{ "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename DBUI buffer" },
				{ "<leader>dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
			},
		},

		-- Terminal
		{
			"akinsho/toggleterm.nvim",
			version = "*",
			config = function()
				require("toggleterm").setup({
					size = 20,
					open_mapping = [[<c-\>]],
					hide_numbers = true,
					shade_terminals = true,
					start_in_insert = true,
					direction = "horizontal",
					close_on_exit = true,
				})
			end,
		},

		-- Git
		{
			"lewis6991/gitsigns.nvim",
			opts = {
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
				},
				current_line_blame = true,
				current_line_blame_opts = { virt_text_pos = "eol", delay = 1000 },
			},
		},

		-- UI Theme
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
			config = function()
				require("catppuccin").setup({
					flavour = "mocha",
					transparent_background = false,
				})
				vim.cmd.colorscheme("catppuccin")
			end,
		},

		-- Statusline
		{
			"nvim-lualine/lualine.nvim",
			opts = {
				options = {
					theme = "catppuccin",
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {
						{ "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{ "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
					},
					lualine_x = { "encoding", "fileformat" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			},
		},

		-- File Explorer
		{
			"nvim-neo-tree/neo-tree.nvim",
			opts = {
				filesystem = {
					bind_to_cwd = false,
					follow_current_file = { enabled = true },
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = true,
						hide_by_name = { "node_modules", "__pycache__", ".git" },
					},
				},
				window = { width = 30 },
			},
		},

		-- Utilities
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			init = function()
				vim.o.timeout = true
				vim.o.timeoutlen = 300
			end,
			config = function()
				require("which-key").setup({
					win = { border = "rounded" },
				})
			end,
		},

		{
			"folke/todo-comments.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {
				keywords = {
					FIX = { icon = " ", color = "error" },
					TODO = { icon = " ", color = "info" },
					HACK = { icon = " ", color = "warning" },
					WARN = { icon = " ", color = "warning" },
					NOTE = { icon = " ", color = "hint" },
				},
			},
		},

		{
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup()
			end,
		},

		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = function()
				require("nvim-autopairs").setup({ check_ts = true })
			end,
		},

		{
			"kylechui/nvim-surround",
			version = "*",
			event = "VeryLazy",
			config = function()
				require("nvim-surround").setup()
			end,
		},

		{
			"kevinhwang91/nvim-ufo",
			dependencies = { "kevinhwang91/promise-async" },
			config = function()
				vim.o.foldcolumn = "1"
				vim.o.foldlevel = 99
				vim.o.foldenable = true
				require("ufo").setup({
					provider_selector = function()
						return { "treesitter", "indent" }
					end,
				})
				vim.keymap.set("n", "zR", require("ufo").openAllFolds)
				vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
			end,
		},
	},

	defaults = { lazy = false, version = false },
	install = { colorscheme = { "catppuccin" } },
	checker = { enabled = false },
	performance = {
		rtp = {
			disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
		},
	},
})

-- ============================================================================
-- KEYMAPPINGS
-- ============================================================================

local map = vim.keymap.set

-- Navigation
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window resize
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- ============================================================================
-- BUFFER NAVIGATION - EASY TAB ACCESS
-- ============================================================================

-- Cycle through buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Jump to specific buffer (1-9)
for i = 1, 9 do
	map("n", "<leader>" .. i, "<cmd>buffer " .. i .. "<cr>", { desc = "Jump to buffer " .. i })
end

-- Buffer picker
map("n", "<leader>b", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })

-- Close buffer
map("n", "<leader>q", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Other
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear search" })
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })

-- ============================================================================
-- OPTIONS
-- ============================================================================

vim.opt.conceallevel = 0
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.formatoptions = "jcroqlnt"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.laststatus = 3
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.scrolloff = 4
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200
vim.opt.virtualedit = "block"
vim.opt.wildmode = "longest:full,full"
vim.opt.winminwidth = 5
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪ "
vim.opt.colorcolumn = "80,120"
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.fillchars = { foldopen = " ", fold = " ", foldsep = " ", diff = "╱", eob = " " }

vim.g.markdown_recommended_style = 0

-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
	group = augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 150 })
	end,
})

-- Resize splits
autocmd({ "VimResized" }, {
	group = augroup("resize_splits", { clear = true }),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- Last location
autocmd("BufReadPost", {
	group = augroup("last_loc", { clear = true }),
	callback = function(event)
		local buf = event.buf
		if vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Close with q
autocmd("FileType", {
	group = augroup("close_with_q", { clear = true }),
	pattern = { "help", "qf", "notify", "man", "lspinfo", "startuptime" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})
