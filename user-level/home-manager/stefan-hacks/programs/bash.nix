# bash.nix — Bash shell mechanics (ble.sh, history, init order, functions).
# Aliases live in aliases.nix so this module stays focused on shell behaviour.
{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    blesh
    grc
    nvd
    nix-output-monitor
  ];

  home.file.".blerc".text = ''
    bleopt history_share=1
    bleopt prompt_ps1_final='\[$(tput setaf 6)\]\w \[$(tput sgr0)\]\$ '
    bleopt complete_auto_complete=1
    bleopt complete_menu_complete=1
    bleopt complete_ambiguous=1
  '';

  # ---------------------------------------------------------------------------
  # Prompt, navigation, ls
  # ---------------------------------------------------------------------------
  programs.fzf.enable = true;

  # Zoxide's Bash hook is initialized explicitly in initExtra below.
  programs.eza = {
    enable = true;
    enableBashIntegration = lib.mkForce false;
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = lib.mkForce false;
  };

  # ---------------------------------------------------------------------------
  # Bash
  # ---------------------------------------------------------------------------
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
    historySize = 100000;
    historyFileSize = 200000;

    bashrcExtra = ''
      # ble.sh must be sourced first (interactive shells only); it attaches at the very end
      if [[ $- == *i* ]] && command -v blesh-share >/dev/null 2>&1; then
        source -- "$(blesh-share)"/ble.sh --attach=none

        # Remove ble.sh's read wrapper to prevent "not a valid identifier" errors
        # when carapace/fzf call `read` in completion contexts. ble.sh's read wrapper
        # intercepts all read calls and enters a special interactive mode that breaks
        # non-interactive reads (e.g., here-strings used by carapace completion).
        unset -f read
      fi
    '';

    initExtra = lib.mkMerge [
      ''
        export NIXCFG="''${NIXCFG:-$HOME/.config/nixos}"
        export EDITOR=vim
        export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

        # Catppuccin-Mocha colors for fzf
        export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=fg:#CDD6F4,bg:#1E1E2E,hl:#89B4FA,fg+:#CDD6F4,bg+:#313244,hl+:#B4BEFE,info:#A6E3A1,prompt:#89B4FA,pointer:#F38BA8,marker:#A6E3A1,spinner:#CBA6F7,header:#6C7086"

        set -o vi

        _have() { command -v "$1" >/dev/null 2>&1; }

        _nrebuild() {
          local action=$1 host=$HOSTNAME
          shift
          if [[ -n ''${1:-} && $1 != -* ]]; then host=$1; shift; fi
          case $action in
            build | dry-build | build-vm) nixos-rebuild "$action" --flake "$NIXCFG#$host" "$@" ;;
            *) sudo nixos-rebuild "$action" --flake "$NIXCFG#$host" "$@" ;;
          esac
        }

        nsw() { _nrebuild switch "$@"; }
        nbd() { _nrebuild build "$@"; }
        nts() { _nrebuild test "$@"; }
        ndr() { _nrebuild dry-build "$@"; }
        nbt() { _nrebuild boot "$@"; }

        nswn() {
          sudo nixos-rebuild switch --flake "$NIXCFG#''${1:-$HOSTNAME}" --log-format internal-json -v |& nom --json
        }

        ndeploy() {
          [[ $# -ge 2 ]] || { echo "usage: ndeploy <flake-host> <user@address> [switch|boot|test]" >&2; return 1; }
          nixos-rebuild "''${3:-switch}" --flake "$NIXCFG#$1" --target-host "$2" --sudo
        }

        nupgrade() {
          ( cd "$NIXCFG" && nix flake update ) || return
          nsw "$@" || return
          ndiff
          sudo nix-collect-garbage --delete-older-than 7d && nix-store --optimise
        }

        ndiff() {
          local a=''${1:-/run/booted-system} b=''${2:-/run/current-system}
          if _have nvd; then nvd diff "$a" "$b"; else nix store diff-closures "$a" "$b"; fi
        }

        ns() {
          local args=() p
          for p in "$@"; do
            case $p in
              -* | *#* | */*) args+=("$p") ;;
              *) args+=("nixpkgs#$p") ;;
            esac
          done
          nix shell "''${args[@]}"
        }

        nopt()       { nix eval "$NIXCFG#nixosConfigurations.''${2:-$HOSTNAME}.config.$1"; }
        nrepl-host() { nix repl "$NIXCFG#nixosConfigurations.''${1:-$HOSTNAME}"; }
        hms()        { home-manager switch --flake "$NIXCFG#''${1:-$USER}"; }

        jfu()       { sudo journalctl -fu "''${1:?usage: jfu <unit>}"; }
        portcheck() { nc -zv "''${1:?usage: portcheck <host> <port>}" "''${2:?}"; }

        fkill() {
          local pids
          pids=$(ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | sed 1d | fzf -m --reverse | awk '{print $1}')
          [[ -n $pids ]] && kill -"''${1:-15}" $pids
        }

        extract() {
          local f
          for f in "$@"; do
            [[ -f $f ]] || { echo "extract: '$f' is not a file" >&2; continue; }
            case $f in
              *.tar.gz | *.tgz)   tar -xzvf "$f" ;;
              *.tar.bz2 | *.tbz2) tar -xjvf "$f" ;;
              *.tar.xz | *.txz)   tar -xJvf "$f" ;;
              *.tar.zst)          tar --zstd -xvf "$f" ;;
              *.tar)              tar -xvf "$f" ;;
              *.zip)              unzip "$f" ;;
              *.gz)               gunzip "$f" ;;
              *.bz2)              bunzip2 "$f" ;;
              *.xz)               unxz "$f" ;;
              *.zst)              unzstd "$f" ;;
              *.7z)               7z x "$f" ;;
              *)                  echo "extract: unknown format '$f'" >&2 ;;
            esac
          done
        }

        gitup() { git add -A && git commit -m "''${*:-update}" && git push; }

        gprune() {
          git fetch --prune &&
            git branch --merged | grep -Ev '^\*|^\s*(main|master|develop)$' | xargs -r git branch -d
        }

        dsh() { docker exec -it "''${1:?usage: dsh <container> [shell]}" "''${2:-sh}"; }
        kns() { kubectl config set-context --current --namespace="''${1:?usage: kns <namespace>}"; }

        # 'help' is a bash builtin — use 'g' instead
        g() { "$@" --help 2>&1 | bathelp; }

        # batpipe: make `less` automatically use bat for syntax-highlighted previews
        export LESSOPEN="|batpipe %s"

        # batwatch: watch files for changes and re-print with bat
        bw() {
          [[ $# -ge 1 ]] || { echo "usage: bw <file>..." >&2; return 1; }
          batwatch "$@"
        }

        # prettybat: pretty-print source code and highlight with bat
        pb() {
          [[ $# -ge 1 ]] || { echo "usage: pb <file>..." >&2; return 1; }
          prettybat "$@"
        }
      ''
      (lib.mkOrder 1950 ''
        eval "$(${pkgs.zoxide}/bin/zoxide init bash)"
      '')
      (lib.mkOrder 2000 ''
        # ble.sh attaches here.
        [[ ! ''${BLE_VERSION-} ]] || ble-attach
      '')
      (lib.mkOrder 2100 ''
        # atuin initialises AFTER ble-attach.  It detects BLE_ATTACHED and
        # registers ble.sh-compatible widgets for up-arrow history search.
        # NOTE: atuin needs ATUIN_CONFIG_DIR set in non-login shells (kitty)
        # because HM session variables haven't been sourced yet.
        export ATUIN_CONFIG_DIR="''${HOME}/.config/atuin"
        if command -v atuin >/dev/null 2>&1; then eval "$(atuin init bash)"; fi
      '')
    ];
  };
}
