# Neovim via nixvim (home-manager module; flake input pinned to nixos-26.05).
# Replaces the legacy file's unpinned builtins.fetchGit + NixOS nixvim module.
# gcc/gnumake (needed for nvim-treesitter parser compilation) are provided by
# user-level/profiles/dev-base.nix; LSP servers & formatters likewise.
{ ... }:

{
  programs.nixvim = {
    enable = true;
    # Reuse HM's useGlobalPkgs nixpkgs instance — no second pkgs eval, and
    # suppresses the nixpkgs.source divergence warning.
    nixpkgs.useGlobalPackages = true;
    defaultEditor = true; # EDITOR/VISUAL=nvim (matches system-level/environment.nix)
    viAlias = true;
    vimAlias = true;

    # Start filling in your setup here, e.g.:
    # colorschemes.catppuccin.enable = true;
    # plugins.treesitter.enable = true;
    # plugins.lualine.enable = true;
  };
}
