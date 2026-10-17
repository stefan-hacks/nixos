{ pkgs, ... }:

{
  home.packages = with pkgs; [
    atuin
    blesh
    bat
    bat-extras.core
    carapace
    fzf
    gh
    lazygit
    starship
    tealdeer
    yazi
    zellij
    zoxide
  ];
}

