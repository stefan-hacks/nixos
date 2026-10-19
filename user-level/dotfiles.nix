# Dotfiles — personal configuration managed via convention-based symlinks.
# No home-manager; a systemd user service creates symlinks on login.
#
# CONVENTION (drop files into user-level/dotfiles/ and they auto-map):
#   • Hidden files/dirs at root   → ~/<name>
#       .bashrc        → ~/.bashrc
#       .ssh/          → ~/.ssh/
#   • Non-hidden dirs at root     → ~/.config/<name>/
#       kitty/         → ~/.config/kitty/
#   • Non-hidden files at root    → ~/.config/<name>
#       starship.toml  → ~/.config/starship.toml
#
# The repo is the single source of truth — existing files are removed, not backed up.
{ config, lib, pkgs, ... }:

let
  dotfiles = ./dotfiles;

  # Copy dotfiles into the Nix store so they persist across GC.
  # -L follows symlinks to ensure the store copy is self-contained.
  dotfilesDrv = pkgs.runCommand "dotfiles" {} ''
    mkdir -p $out
    cp -rL ${dotfiles}/* $out/ 2>/dev/null || true
    cp -rL ${dotfiles}/.[!.]* $out/ 2>/dev/null || true
  '';

  # Script that discovers the store copy and symlinks based on convention.
  dotfilesScript = pkgs.writeShellScript "dotfiles-sync" ''
    set -euo pipefail

    # Only apply to user "stefan-hacks".
    if [ "$(whoami)" != "stefan-hacks" ]; then
      exit 0
    fi

    DOTFILES="${dotfilesDrv}"

    # -----------------------------------------------------------------------
    # Convention-based symlink farm
    # -----------------------------------------------------------------------
    for src in "$DOTFILES"/* "$DOTFILES"/.[!.]* "$DOTFILES"/..?*; do
      [ -e "$src" ] || continue
      name=$(basename "$src")

      # Skip '.' and '..' from glob expansion
      [[ "$name" == "." || "$name" == ".." ]] && continue

      # Determine target based on naming convention
      if [[ "$name" == .* ]]; then
        # Hidden file/dir  → directly in $HOME
        dst="$HOME/$name"
      else
        # Non-hidden       → under ~/.config
        dst="$HOME/.config/$name"
      fi

      # Ensure parent directory exists
      dst_dir=$(dirname "$dst")
      [ -d "$dst_dir" ] || mkdir -p "$dst_dir"

      # Already a correct symlink?  Skip.
      if [ -L "$dst" ]; then
        current=$(readlink "$dst" 2>/dev/null || true)
        if [ "$current" = "$src" ]; then
          echo "  OK: $dst"
          continue
        fi
      fi

      # Remove existing file / dir / broken symlink and replace
      if [ -e "$dst" ] || [ -L "$dst" ]; then
        echo "  REMOVE: $dst"
        rm -rf "$dst"
      fi

      ln -s "$src" "$dst"
      echo "  LINK: $dst → $src"
    done

    echo "[dotfiles] Done."
  '';
in
{
  # Run the sync script as a one-shot systemd user service on login.
  systemd.user.services.dotfiles = {
    description = "Sync personal dotfiles (convention-based)";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = dotfilesScript;
    };
  };
}
