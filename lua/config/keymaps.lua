-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Save with leader W
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true })