{ lib, hostName, ... }:

{
  imports = [
    ../../profiles/admin-base.nix
    ../../profiles/dev-base.nix

    ./packages/terminal.nix
    ./gnome.nix
  ]
  ++ lib.optionals
    (builtins.elem hostName [ "ghost" "titan" ])
    [
      ./packages/gui.nix
    ];

  home.username = "stefan-hacks";
  home.homeDirectory = "/home/stefan-hacks";

  # Set this to the Home Manager state version
  # appropriate for your existing installation.
  home.stateVersion = "26.05";
}
