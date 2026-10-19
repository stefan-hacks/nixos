-- LazyVim starter bootstrap for NixOS.
-- This init.lua is based on the official LazyVim starter template.
-- All LSP servers, formatters, and tools are provided by NixOS packages.
-- Mason is disabled — see lua/plugins/nixos-compat.lua.

-- ───────────────────────────────────────────────────────────────────────────
-- Bootstrap lazy.nvim
-- ───────────────────────────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "--branch=stable", lazyrepo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ───────────────────────────────────────────────────────────────────────────
-- Setup lazy.nvim with LazyVim
-- ───────────────────────────────────────────────────────────────────────────
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  defaults = {
    -- LazyVim uses lazy=true by default for its own plugins.
    -- Custom plugins can override this.
    lazy = false,
    version = false,
  },
  install = {
    -- Don't try to install missing plugins automatically on NixOS.
    -- Plugins are either in the Nix store or downloaded once by lazy.nvim.
    missing = false,
  },
  checker = {
    -- Disable update checker (Nix manages updates via rebuilds).
    enabled = false,
    notify = false,
  },
  change_detection = {
    -- Disable change detection notifications.
    notify = false,
  },
  performance = {
    rtp = {
      -- Reset runtime path for clean startup.
      reset = true,
    },
  },
})
