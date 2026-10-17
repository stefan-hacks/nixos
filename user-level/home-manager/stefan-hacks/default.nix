# Home-manager entry point for stefan-hacks. Hosts are handled by hostName
# conditionals; profiles are shared fleet-wide, per-user modules live under
# ./programs/ (pure HM modules) and package-only leftovers in ./packages/.
{ lib, hostName, inputs, ... }:

{
  imports = [
    # Editor (nixvim home-manager module; flake input, pinned to nixos-26.05)
    inputs.nixvim.homeModules.nixvim

    # Shared profiles
    ../../profiles/admin-base.nix
    ../../profiles/dev-base.nix

    # Package-only leftovers (tools without HM modules)
    ./packages/terminal.nix

    # Pure home-manager modules
    ./gnome.nix
    ./programs/bash.nix
    ./programs/git.nix
    ./programs/shell-tools.nix
    ./programs/kitty.nix
    ./programs/desktop.nix
    ./programs/security.nix
    ./programs/nixvim.nix
  ]
  ++ lib.optionals
    (builtins.elem hostName [
      "ghost"
      "titan"
    ])
    [
      ./packages/gui.nix
      ../../profiles/ctf.nix
    ];

  home.username = "stefan-hacks";
  home.homeDirectory = "/home/stefan-hacks";

  # Mirrors system-level environment.localBinInPath for the user session.
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;

  # Set this to the Home Manager state version
  # appropriate for your existing installation.
  home.stateVersion = "26.05";
}
