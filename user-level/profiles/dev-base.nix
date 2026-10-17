{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ###########################################################################
    # Build tools (for nvim-treesitter parser compilation)
    ###########################################################################

    gcc
    gnumake

    ###########################################################################
    # LSP Servers (declarative — Nix-managed, no Mason)
    ###########################################################################

    rust-analyzer
    nixd
    basedpyright
    bash-language-server
    yaml-language-server
    marksman
    taplo
    lua-language-server
    vscode-langservers-extracted

    ###########################################################################
    # Formatters
    ###########################################################################

    rustfmt
    nixfmt
    shfmt
    ruff
    stylua
    black
    isort
    prettier

    ###########################################################################
    # Linters
    ###########################################################################

    cargo
    clippy
    shellcheck
    statix
    yamllint
    markdownlint-cli

    ###########################################################################
    # Nix language tooling (moved from system-level/pkgs-terminal.nix —
    # an LSP/QA tool belongs to the editing session, not the OS profile)
    ###########################################################################

    nil
    deadnix
    alejandra
  ];
}
