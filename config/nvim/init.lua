-- ~/.config/nvim/init.lua
-- LazyVim Starter Configuration

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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- LazyVim base
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },

		-- Import extras
		-- Choose ONE: either copilot OR codeium, not both
		-- { import = "lazyvim.plugins.extras.coding.copilot" },
		-- { import = "lazyvim.plugins.extras.coding.codeium" }, -- Alternative to copilot

		{ import = "lazyvim.plugins.extras.coding.yanky" },
		{ import = "lazyvim.plugins.extras.editor.leap" },
		{ import = "lazyvim.plugins.extras.editor.mini-files" },
		{ import = "lazyvim.plugins.extras.formatting.prettier" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.lang.rust" },
		{ import = "lazyvim.plugins.extras.lang.go" },
		{ import = "lazyvim.plugins.extras.lang.docker" },
		{ import = "lazyvim.plugins.extras.lang.yaml" },
		{ import = "lazyvim.plugins.extras.lang.markdown" },
		{ import = "lazyvim.plugins.extras.util.dot" },

		-- Custom plugins
		{
			-- Better terminal integration
			"akinsho/toggleterm.nvim",
			version = "*",
			config = function()
				require("toggleterm").setup({
					size = 20,
					open_mapping = [[<c-\>]],
					hide_numbers = true,
					shade_terminals = true,
					start_in_insert = true,
					insert_mappings = true,
					persist_size = true,
					direction = "horizontal",
					close_on_exit = true,
					shell = vim.o.shell,
					float_opts = {
						border = "curved",
						winblend = 0,
						highlights = {
							border = "Normal",
							background = "Normal",
						},
					},
				})
			end,
		},

		{
			-- Beautiful themes
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
			config = function()
				require("catppuccin").setup({
					flavour = "mocha", -- latte, frappe, macchiato, mocha
					background = {
						light = "latte",
						dark = "mocha",
					},
					transparent_background = false,
					show_end_of_buffer = false,
					term_colors = false,
					dim_inactive = {
						enabled = false,
						shade = "dark",
						percentage = 0.15,
					},
					integrations = {
						cmp = true,
						gitsigns = true,
						nvimtree = true,
						telescope = true,
						notify = false,
						mini = true,
					},
				})
				-- Set colorscheme after setup
				vim.cmd.colorscheme("catppuccin")
			end,
		},

		-- REMOVED: Codeium plugin since we're using Copilot from LazyVim extras
		-- If you prefer Codeium over Copilot, remove the copilot import above and uncomment this:
		--[[
    {
      "Exafunction/codeium.vim",
      event = "BufEnter",
      config = function()
        vim.keymap.set("i", "<C-g>", function()
          return vim.fn["codeium#Accept"]()
        end, { expr = true })
        vim.keymap.set("i", "<C-;>", function()
          return vim.fn["codeium#CycleCompletions"](1)
        end, { expr = true })
        vim.keymap.set("i", "<C-,>", function()
          return vim.fn["codeium#CycleCompletions"](-1)
        end, { expr = true })
        vim.keymap.set("i", "<C-x>", function()
          return vim.fn["codeium#Clear"]()
        end, { expr = true })
      end,
    },
    --]]

		{
			-- Better quickfix window
			"kevinhwang91/nvim-bqf",
			ft = "qf",
			config = function()
				require("bqf").setup({
					auto_enable = true,
					preview = {
						win_height = 12,
						win_vheight = 12,
						delay_syntax = 80,
						-- Fixed: 8 border characters instead of 9
						border_chars = { "┃", "━", "┏", "┓", "┗", "┛", "┣", "┫" },
					},
				})
			end,
		},

		{
			-- Smooth scrolling
			"karb94/neoscroll.nvim",
			config = function()
				require("neoscroll").setup({
					mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
					hide_cursor = true,
					stop_eof = true,
					respect_scrolloff = false,
					cursor_scrolls_alone = true,
					easing_function = nil,
					pre_hook = nil,
					post_hook = nil,
				})
			end,
		},

		{
			-- Better commenting
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup({
					padding = true,
					sticky = true,
					ignore = nil,
					toggler = {
						line = "gcc",
						block = "gbc",
					},
					opleader = {
						line = "gc",
						block = "gb",
					},
					extra = {
						above = "gcO",
						below = "gco",
						eol = "gcA",
					},
					mappings = {
						basic = true,
						extra = true,
					},
				})
			end,
		},

		{
			-- Rainbow brackets
			"HiPhish/rainbow-delimiters.nvim",
			config = function()
				require("rainbow-delimiters.setup").setup({
					strategy = {
						[""] = require("rainbow-delimiters").strategy.global,
					},
					query = {
						[""] = "rainbow-delimiters",
						lua = "rainbow-blocks",
					},
					highlight = {
						"RainbowDelimiterRed",
						"RainbowDelimiterYellow",
						"RainbowDelimiterBlue",
						"RainbowDelimiterOrange",
						"RainbowDelimiterGreen",
						"RainbowDelimiterViolet",
						"RainbowDelimiterCyan",
					},
				})
			end,
		},

		{
			-- Better indentation guides
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			config = function()
				require("ibl").setup({
					indent = {
						char = "│",
						tab_char = "│",
					},
					scope = { enabled = false },
					exclude = {
						filetypes = {
							"help",
							"alpha",
							"dashboard",
							"neo-tree",
							"Trouble",
							"lazy",
							"mason",
							"notify",
							"toggleterm",
							"lazyterm",
						},
					},
				})
			end,
		},

		{
			-- File explorer
			"nvim-neo-tree/neo-tree.nvim",
			opts = {
				filesystem = {
					bind_to_cwd = false,
					follow_current_file = { enabled = true },
					use_libuv_file_watcher = true,
					filtered_items = {
						visible = false,
						hide_dotfiles = false,
						hide_gitignored = true,
						hide_hidden = true,
						hide_by_name = {
							"node_modules",
							"__pycache__",
							".git",
							".DS_Store",
						},
					},
				},
				window = {
					mappings = {
						["<space>"] = "none",
						["H"] = "toggle_hidden",
					},
					width = 30,
				},
				default_component_configs = {
					indent = {
						with_expanders = true,
						expander_collapsed = "",
						expander_expanded = "",
						expander_highlight = "NeoTreeExpander",
					},
					git_status = {
						symbols = {
							added = "✚",
							modified = "",
							deleted = "✖",
							renamed = "󰁕",
							untracked = "",
							ignored = "",
							unstaged = "󰄱",
							staged = "",
							conflict = "",
						},
					},
				},
			},
		},

		{
			-- Git integration
			"lewis6991/gitsigns.nvim",
			opts = {
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
					untracked = { text = "▎" },
				},
				current_line_blame = true,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol",
					delay = 1000,
					ignore_whitespace = false,
				},
				preview_config = {
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			},
		},

		{
			-- Fuzzy finder
			"nvim-telescope/telescope.nvim",
			opts = function()
				local actions = require("telescope.actions")
				return {
					defaults = {
						prompt_prefix = " ",
						selection_caret = " ",
						path_display = { "truncate" },
						sorting_strategy = "ascending",
						layout_config = {
							horizontal = {
								prompt_position = "top",
								preview_width = 0.55,
								results_width = 0.8,
							},
							vertical = {
								mirror = false,
							},
							width = 0.87,
							height = 0.80,
							preview_cutoff = 120,
						},
						mappings = {
							i = {
								["<C-n>"] = actions.cycle_history_next,
								["<C-p>"] = actions.cycle_history_prev,
								["<C-j>"] = actions.move_selection_next,
								["<C-k>"] = actions.move_selection_previous,
							},
						},
					},
				}
			end,
		},

		{
			-- Status line
			"nvim-lualine/lualine.nvim",
			opts = function()
				return {
					options = {
						theme = "catppuccin",
						globalstatus = true,
						disabled_filetypes = { statusline = { "dashboard", "alpha" } },
						component_separators = { left = "", right = "" },
						section_separators = { left = "", right = "" },
					},
					sections = {
						lualine_a = { "mode" },
						lualine_b = { "branch" },
						lualine_c = {
							{
								"diagnostics",
								symbols = {
									error = " ",
									warn = " ",
									info = " ",
									hint = " ",
								},
							},
							{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
							{ "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
						},
						lualine_x = {
							-- Fixed: Added safety checks for noice
							{
								function()
									if package.loaded["noice"] then
										return require("noice").api.status.command.get()
									end
									return ""
								end,
								cond = function()
									return package.loaded["noice"] and require("noice").api.status.command.has()
								end,
								color = { fg = "#ff9e64" },
							},
							{
								function()
									if package.loaded["noice"] then
										return require("noice").api.status.mode.get()
									end
									return ""
								end,
								cond = function()
									return package.loaded["noice"] and require("noice").api.status.mode.has()
								end,
								color = { fg = "#ff9e64" },
							},
							{ "encoding" },
							{ "fileformat" },
						},
						lualine_y = { "progress" },
						lualine_z = { "location" },
					},
				}
			end,
		},

		-- Useful additional plugins
		{
			-- Highlight TODO, FIXME, etc. in comments
			"folke/todo-comments.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				require("todo-comments").setup({
					signs = true,
					sign_priority = 8,
					keywords = {
						FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
						TODO = { icon = " ", color = "info" },
						HACK = { icon = " ", color = "warning" },
						WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
						PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
						NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
						TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
					},
					highlight = {
						multiline = true,
						multiline_pattern = "^.",
						multiline_context = 10,
						before = "",
						keyword = "wide",
						after = "fg",
						pattern = [[.*<(KEYWORDS)\s*:]],
						comments_only = true,
						max_line_len = 400,
						exclude = {},
					},
				})
			end,
		},

		{
			-- Autopairs
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = function()
				require("nvim-autopairs").setup({
					check_ts = true,
					ts_config = {
						lua = { "string", "source" },
						javascript = { "string", "template_string" },
						java = false,
					},
					disable_filetype = { "TelescopePrompt", "spectre_panel" },
				})
			end,
		},

		{
			-- Surround text objects
			"kylechui/nvim-surround",
			version = "*",
			event = "VeryLazy",
			config = function()
				require("nvim-surround").setup({})
			end,
		},

		{
			-- Show current code context
			"nvim-treesitter/nvim-treesitter-context",
			config = function()
				require("treesitter-context").setup({
					enable = true,
					max_lines = 0,
					min_window_height = 0,
					line_numbers = true,
					multiline_threshold = 20,
					trim_scope = "outer",
					mode = "cursor",
					separator = nil,
				})
			end,
		},

		{
			-- Better folding
			"kevinhwang91/nvim-ufo",
			dependencies = { "kevinhwang91/promise-async" },
			config = function()
				vim.o.foldcolumn = "1"
				vim.o.foldlevel = 99
				vim.o.foldlevelstart = 99
				vim.o.foldenable = true

				require("ufo").setup({
					provider_selector = function(bufnr, filetype, buftype)
						return { "treesitter", "indent" }
					end,
				})

				-- Set up keymaps after ufo is loaded
				vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
				vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
			end,
		},

		{
			-- Which-key - shows keybindings
			"folke/which-key.nvim",
			event = "VeryLazy",
			init = function()
				vim.o.timeout = true
				vim.o.timeoutlen = 300
			end,
			config = function()
				require("which-key").setup({
					plugins = {
						marks = true,
						registers = true,
						spelling = {
							enabled = true,
							suggestions = 20,
						},
					},
					-- FIXED: Changed 'window' to 'win'
					win = {
						border = "rounded",
						position = "bottom",
						margin = { 1, 0, 1, 0 },
						padding = { 2, 2, 2, 2 },
						winblend = 0,
					},
					layout = {
						height = { min = 4, max = 25 },
						width = { min = 20, max = 50 },
						spacing = 3,
						align = "left",
					},
				})
			end,
		},
	},

	defaults = {
		lazy = false,
		version = false,
	},

	install = { colorscheme = { "catppuccin" } },
	checker = { enabled = true },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- Custom key mappings
local map = vim.keymap.set

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Toggle line numbers
map("n", "<leader>tn", "<cmd>set number!<cr>", { desc = "Toggle line numbers" })
map("n", "<leader>tr", "<cmd>set relativenumber!<cr>", { desc = "Toggle relative numbers" })

-- Custom options - Enhanced with better visibility
vim.opt.conceallevel = 0 -- Hide * markup for bold and italic
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.cursorcolumn = false -- Enable highlighting of the current column (can be distracting)
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true -- Ignore case
vim.opt.inccommand = "nosplit" -- preview incremental substitute
vim.opt.laststatus = 3 -- global statusline
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.number = true -- Print line number
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.numberwidth = 4 -- Set number column width to 4 {default 4}
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showmode = false -- Don't show mode since we have a statusline
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.signcolumn = "yes" -- Always show the signcolumn
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.spelllang = { "en" }
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitkeep = "screen"
vim.opt.splitright = true -- Put new windows right of current
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap
vim.opt.linebreak = true -- Companion to wrap, don't split words
vim.opt.breakindent = true -- Enable break indent
vim.opt.showbreak = "↪ " -- String to put at the start of lines that have been wrapped
vim.opt.colorcolumn = "80,120" -- Show column ruler at 80 and 120 characters
vim.opt.list = true -- Show some invisible characters (tabs...)
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- Define which invisible characters to show
-- CORRECTED: Remove the invalid 'foldclose' field
vim.opt.fillchars = {
	foldopen = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Autocommands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
	group = augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 150 })
	end,
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
	group = augroup("resize_splits", { clear = true }),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- go to last loc when opening a buffer
autocmd("BufReadPost", {
	group = augroup("last_loc", { clear = true }),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
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

-- close some filetypes with <q>
autocmd("FileType", {
	group = augroup("close_with_q", { clear = true }),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})
