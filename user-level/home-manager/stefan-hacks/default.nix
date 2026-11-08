# Home Manager entry point for stefan-hacks
{config, ...}: {
  imports = [
    ./programs/aliases.nix
    ./programs/avatar.nix
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

  programs.home-manager.enable = true;
}
