# Home Manager entry point for stefan-hacks
{config, ...}: {
  imports = [
    ./programs/aliases.nix
    ./programs/bash.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/atuin.nix
    ./programs/carapace.nix
    ./programs/starship.nix
    ./programs/helix.nix
    ./programs/zellij.nix
    ./programs/fastfetch.nix
    ./programs/bat.nix
    ./programs/btop.nix
    ./programs/nixdatifier.nix
    ./programs/color-profiles.nix
    ./programs/tailspin.nix
    ./gnome
  ];

  # User environment
  home = {
    username = "stefan-hacks";
    homeDirectory = "/home/stefan-hacks";
    stateVersion = "26.05";

    # Ensure ~/.local/bin is on PATH.
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
    sessionVariables = {
      NH_FLAKE = "/home/stefan-hacks/.config/nixos";
    };
  };

  programs = {
    pure-vim.enable = true;
    por-cli.enable = true;
    home-manager.enable = true;
    gnome-island.enable = true;
  };
}
