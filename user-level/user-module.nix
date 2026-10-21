# user-module.nix — Generic per-user module.
# Called from system.nix with { username = "..."; }.
# Automatically wires user account, dotfiles, and GNOME settings for the
# named user by reading from user-level/<username>/.
{ username }:
{ config, lib, pkgs, ... }:
let
  userDir = ./. + "/${username}";
  userConfigFile = userDir + "/${username}.nix";
  userDotfilesDir = userDir + "/dotfiles";
  userGnomeFile = userDir + "/gnome.nix";
in
{
  # Make the username available to all imported sub-modules (dotfiles, GNOME).
  _module.args.primaryUser = username;

  # ═══════════════════════════════════════════════════════════════════════════
  # User account
  # ═══════════════════════════════════════════════════════════════════════════
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "kvm"
      "input"
      "uinput"
    ];
    packages = with pkgs; [ ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # Dotfiles — convention-based symlinks
  # ═══════════════════════════════════════════════════════════════════════════
  # Only set up if the user has a dotfiles/ directory.
  systemd.user.services."dotfiles-${username}" = lib.mkIf (builtins.pathExists userDotfilesDir) {
    description = "Sync dotfiles for ${username}";
    wantedBy = [ "default.target" ];
    unitConfig.ConditionUser = username;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = let
        dotfilesDrv = pkgs.runCommand "dotfiles-${username}" {} ''
          mkdir -p $out
          cp -rL ${userDotfilesDir}/* $out/ 2>/dev/null || true
          cp -rL ${userDotfilesDir}/.[!.]* $out/ 2>/dev/null || true
        '';
        syncScript = pkgs.writeShellScript "dotfiles-sync-${username}" ''
          set -euo pipefail
          DOTFILES="${dotfilesDrv}"
          [ -d "$DOTFILES" ] || { echo "[dotfiles] No dotfiles to sync."; exit 0; }
          for src in "$DOTFILES"/* "$DOTFILES"/.[!.]* "$DOTFILES"/..?*; do
            [ -e "$src" ] || continue
            name=$(basename "$src")
            [[ "$name" == "." || "$name" == ".." ]] && continue
            if [[ "$name" == .* ]]; then
              dst="$HOME/$name"
            else
              dst="$HOME/.config/$name"
            fi
            dst_dir=$(dirname "$dst")
            [ -d "$dst_dir" ] || mkdir -p "$dst_dir"
            if [ -L "$dst" ]; then
              current=$(readlink "$dst" 2>/dev/null || true)
              [ "$current" = "$src" ] && continue
            fi
            if [ -e "$dst" ] || [ -L "$dst" ]; then
              rm -rf "$dst"
            fi
            ln -s "$src" "$dst"
          done
          echo "[dotfiles] Done for ${username}."
        '';
      in syncScript;
    };
  };

  # Enable dconf if the user has a dconf.ini (required for dconf load to work).
  programs.dconf.enable = lib.mkIf (builtins.pathExists (userDir + "/dconf.ini")) true;

  # ═══════════════════════════════════════════════════════════════════════════
  # Per-user GNOME dconf settings
  # ═══════════════════════════════════════════════════════════════════════════
  # If the user provides a dconf.ini (plain dconf dump), load it on login via
  # a systemd user service. This avoids needing home-manager or manual Nix
  # syntax conversion for complex gvariant types.
  # Generate with:  dconf dump / > dconf.ini
  #
  systemd.user.services."dconf-load-${username}" = lib.mkIf (builtins.pathExists (userDir + "/dconf.ini")) {
    description = "Load GNOME dconf settings for ${username}";
    wantedBy = [ "default.target" ];
    unitConfig.ConditionUser = username;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "dconf-load-${username}" ''
        export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id - u ${username})/bus
        ${pkgs.dconf}/bin/dconf load / < ${userDir + "/dconf.ini"}
      '';
    };
  };
}
