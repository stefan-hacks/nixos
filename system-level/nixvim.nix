# Nixvim — declarative Neovim configuration via builtins.fetchGit.
# This is the non-flake way to pull in the nixvim module.
# We pin to the nixos-26.05 branch to match our nixpkgs version.
{ config, lib, pkgs, ... }:

let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "nixos-26.05";
  });
in
{
  imports = [
    nixvim.nixosModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # ── Options ──
    opts = {
      number = true;
      relativenumber = true;
      cursorline = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      termguicolors = true;
      clipboard = "unnamedplus";
    };

    # ── Globals ──
    globals.mapleader = " ";

    # ── Colorscheme ──
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    # ── Status line ──
    plugins.lualine = {
      enable = true;
    };

    # ── Syntax highlighting / parsing ──
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };

    # ── Fuzzy finder ──
    plugins.telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = { action = "find_files"; options.desc = "Find files"; };
        "<leader>fg" = { action = "live_grep"; options.desc = "Live grep"; };
        "<leader>fb" = { action = "buffers"; options.desc = "Buffers"; };
        "<leader>fh" = { action = "help_tags"; options.desc = "Help tags"; };
      };
    };

    # Required by telescope (suppresses deprecation warning)
    plugins.web-devicons = {
      enable = true;
    };

    # ── LSP (Language Servers) ──
    plugins.lsp = {
      enable = true;
      servers = {
        # Bash
        bashls.enable = true;
        # Lua
        lua_ls.enable = true;
        # Rust
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        # Nix
        nixd.enable = true;
        # C / C++
        clangd.enable = true;
        # Go
        gopls.enable = true;
        # Web
        html.enable = true;
        cssls.enable = true;
        jsonls.enable = true;
        # Markdown
        marksman.enable = true;
        # TOML
        taplo.enable = true;
        # YAML
        yamlls.enable = true;
        # Python
        pyright.enable = true;
      };
    };

    # ── Completion (nvim-cmp) ──
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })";
        };
      };
    };

    # ── Keymaps ──
    keymaps = [
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>:w<cr>";
        options.desc = "Write file";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>:q<cr>";
        options.desc = "Quit";
      }
      {
        mode = "n";
        key = "<leader>h";
        action = "<cmd>nohlsearch<cr>";
        options.desc = "Clear highlights";
      }
    ];
  };
}
