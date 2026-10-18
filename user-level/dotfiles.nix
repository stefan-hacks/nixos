# Dotfiles — personal configuration managed via symlinks.
# No home-manager; a systemd user service creates symlinks on login.
# The source of truth is user-level/dotfiles/ in the repo.
{ config, lib, pkgs, ... }:

let
  # Base path to the dotfiles in the repo.
  # In a flake this would be ${./dotfiles}; in non-flake we use
  # toString so the evaluator sees it as a path (copied to store).
  dotfiles = ./dotfiles;

  # Each entry maps a repo path under user-level/dotfiles/ to a $HOME path.
  # Directories are symlinked as a whole; individual files are symlinked directly.
  # Paths are relative to dotfiles/.
  linkMap = {
    # Shell
    "bash/.bashrc"            = ".bashrc";
    "bash/.bash_aliases"      = ".bash_aliases";
    "blesh/.blerc"            = ".blerc";

    # Editors
    "nvim"                    = ".config/nvim";
    "vim/.vimrc"              = ".vimrc";

    # Terminal
    "kitty"                   = ".config/kitty";
    "zellij/config.kdl"       = ".config/zellij/config.kdl";
    "starship/starship.toml"  = ".config/starship.toml";

    # Git
    "gitconfig/.gitconfig"    = ".gitconfig";

    # SSH
    ".ssh/config"             = ".ssh/config";

    # System info
    "fastfetch/config.jsonc"  = ".config/fastfetch/config.jsonc";

    # Atuin (optional — comment out if you prefer system-managed /etc/atuin)
    # "atuin/config.toml"       = ".config/atuin/config.toml";

    # Foot terminal
    "foot/foot.ini"           = ".config/foot/foot.ini";
  };

  # Build a derivation that holds the dotfiles in the store.
  # The activation script below symlinks from $HOME into this store path.
  dotfilesDrv = pkgs.runCommand "dotfiles" {} ''
    mkdir -p $out
    cp -r ${dotfiles}/* $out/
  '';

  # Script that creates (or updates) symlinks and backs up collisions.
  # Runs once per user login via systemd user service.
  dotfilesScript = pkgs.writeShellScript "dotfiles-sync" ''
    set -euo pipefail

    # Only apply to user "stefan-hacks". Other users get a no-op.
    if [ "$(whoami)" != "stefan-hacks" ]; then
      exit 0
    fi

    DOTFILES="${dotfilesDrv}"
    BACKUP_SUFFIX=".bak.$(date +%Y%m%d%H%M%S)"

    # Ensure parent directories exist and create symlinks.
    link_file() {
      local src="$1"
      local dst="$2"
      local dst_dir
      dst_dir="$(dirname "$dst")"

      if [ ! -d "$dst_dir" ]; then
        mkdir -p "$dst_dir"
      fi

      # If destination exists and is NOT already a symlink to the right place,
      # back it up before replacing.
      if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ -L "$dst" ]; then
          local current
          current="$(readlink "$dst" 2>/dev/null || true)"
          if [ "$current" = "$src" ]; then
            echo "  OK: $dst"
            return 0
          fi
        fi
        # Remove any existing .bak.* files for this destination before creating new backup.
        for old_bak in "$parent_dir"/"$base_name".bak.*; do
          [ -e "$old_bak" ] || continue
          echo "  CLEAN: removing old $old_bak"
          rm -rf "$old_bak"
        done
        echo "  BACKUP: $dst → ''${dst}$BACKUP_SUFFIX"
        mv "$dst" "''${dst}$BACKUP_SUFFIX"
      fi

      ln -s "$src" "$dst"
      echo "  LINK: $dst → $src"
    }

    echo "[dotfiles] Syncing dotfiles for $(whoami)..."

    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (from: to: ''
      link_file "$DOTFILES/${from}" "$HOME/${to}"
    '') linkMap)}

    echo "[dotfiles] Done."
  '';
in
{
  # Run the sync script as a one-shot systemd user service on login.
  systemd.user.services.dotfiles = {
    description = "Sync personal dotfiles";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = dotfilesScript;
    };
  };
}
