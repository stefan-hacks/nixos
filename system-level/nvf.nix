# nvf — Modular Neovim configuration framework for NixOS.
# Installed without flakes via builtins.fetchTarball + flake-compat.
# Docs: https://nvf.notashelf.dev/
{ config, lib, pkgs, ... }:

let
  nvf = import (builtins.fetchTarball {
    url = "https://github.com/notashelf/nvf/archive/main.tar.gz";
  });
in
{
  imports = [
    nvf.nixosModules.nvf
  ];

  programs.nvf = {
    enable = true;
    defaultEditor = true;

    settings.vim = {
      # ── Aliases ──
      viAlias = true;
      vimAlias = true;

      # ── Theme ──
      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
        transparent = false;
      };

      # ── Status line ──
      statusline.lualine = {
        enable = true;
        theme = "catppuccin";
      };

      # ── Autocompletion ──
      autocomplete.nvim-cmp.enable = true;
      snippets.luasnip.enable = true;

      # ── Fuzzy finder ──
      telescope.enable = true;

      # ── File tree ──
      filetree.neo-tree.enable = true;

      # ── Tabline ──
      tabline.nvimBufferline.enable = true;

      # ── Git ──
      git = {
        enable = true;
        gitsigns.enable = true;
      };

      # ── Treesitter (enabled via languages) ──
      treesitter.context.enable = true;

      # ── Keybind helpers ──
      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      # ── LSP ──
      lsp = {
        enable = true;
        formatOnSave = true;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = true;
      };

      # ── Languages ──
      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        markdown.enable = true;
        bash.enable = true;
        clang.enable = true;
        css.enable = true;
        html.enable = true;
        json.enable = true;
        go.enable = true;
        lua.enable = true;
        python.enable = true;
        rust.enable = true;
        toml.enable = true;
        yaml.enable = true;
      };

      # ── UI enhancements ──
      ui = {
        borders.enable = true;
        noice.enable = true;
        colorizer.enable = true;
        illuminate.enable = true;
        fastaction.enable = true;
      };
    };
  };
}
