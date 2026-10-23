# Home Manager entry point for stefan-hacks
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./programs/bash.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/starship.nix
    ./programs/atuin.nix
    ./programs/helix.nix
    ./programs/zellij.nix
    ./programs/foot.nix
    ./programs/fastfetch.nix
    ./gnome
  ];

  home.username = "stefan-hacks";
  home.homeDirectory = "/home/stefan-hacks";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Back up existing dotfiles before HM clobbers them (first switch only)
  home.activation.backupOldConfigs = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    backupDir="/home/stefan-hacks/.local/share/hm-backups/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backupDir"
    for f in "/home/stefan-hacks/.bashrc" \
             "/home/stefan-hacks/.blerc" \
             "/home/stefan-hacks/.config/helix/config.toml" \
             "/home/stefan-hacks/.config/kitty/kitty.conf"; do
      if [ -e "$f" ]; then
        dest="$backupDir/$(echo "$f" | tr '/' '_')"
        run cp -aL "$f" "$dest" 2>/dev/null || true
      fi
    done
  '';

  home.stateVersion = "26.05";
}
