-- Basic Neovim options
-- Loaded from init.lua before lazy.nvim setup.

local opt = vim.opt
local g = vim.g

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.laststatus = 3
opt.termguicolors = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Editing
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Performance
opt.lazyredraw = true
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }

-- Disable netrw (optional, keeps things clean)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
