# bash.nix — Home Manager bash + ble.sh + aliases (no CTF)
{ config, lib, pkgs, ... }:

{
  # ── ble.sh (bash line editor) ──────────────────────────────────────────────
  # NOTE: programs.blesh is not yet in home-manager release-26.05.
  # We install the package manually and source it in bashrcExtra.
  home.packages = [ pkgs.blesh ];

  # ── Custom .blerc ──────────────────────────────────────────────────────────
  home.file.".blerc".text = ''
    # ============================================================================
    # BLE.SH CONFIGURATION (.blerc)
    # ============================================================================
    # Docs: https://github.com/akinomyoga/ble.sh/wiki/Manual-%C2%A73-Key-Binding
    # ============================================================================

    # ── Vim-surround integration ────────────────────────────────────────────────
    ble-import vim-surround

    # ── Disable blesh's default C-S-U binding (kitty uses it for URL hints) ────
    ble-bind -m emacs -f 'C-M-u' 'universal-argument'

    # ============================================================================
    # vim:ft=bash
    # ============================================================================
  '';

  # ── Bash settings ────────────────────────────────────────────────────────────
  programs.bash = {
    enable = true;

    historyFileSize = 6000;
    historySize = 3000;
    historyControl = [ "ignoreboth" ];

    shellOptions = [
      "histappend"
      "checkwinsize"
      "globstar"
      "extglob"
      "dotglob"
    ];

    sessionVariables = {
      TERM = "xterm-256color";
      GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
      GRC_ALIASES = "true";
      BAT_THEME = "Coldark-Dark";
    };

    # ── Aliases: sysadmin + nix only (no CTF) ──────────────────────────────────
    shellAliases = {
      # Safety nets
      "cp" = "cp -vi";
      "mv" = "mv -vi";
      "rm" = "rm -Iv --one-file-system";
      "ln" = "ln -i";
      "mkdir" = "mkdir -pv";
      "wget" = "wget -c";
      "less" = "less -FSRXc";
      "path" = "echo \$PATH | tr ':' '\\n'";
      "cpv" = "rsync -avh --info=progress2";

      # Navigation
      "c" = "clear";
      "e" = "exit";
      "src" = "source ~/.bashrc";
      ".." = "cd -1";
      "..." = "cd -2";
      "...." = "cd -3";
      "numFiles" = "echo \$(ls -1 | wc -l)";
      "hfiles" = "ls -A | grep '^\\.'";

      # Permissions
      "perm" = "stat --printf '%a %n\\n'";
      "000" = "chmod 000";
      "640" = "chmod 640";
      "644" = "chmod 644";
      "755" = "chmod 755";
      "775" = "chmod 775";
      "mx" = "chmod a+x";
      "ux" = "chmod u+x";

      # Listing (eza)
      "ls" = "eza --icons --git --group-directories-first";
      "ll" = "eza -l --icons --git --header --group-directories-first";
      "llog" = "eza -l --icons --git --header -og --group-directories-first";
      "lsa" = "eza -a --icons --git --group-directories-first";
      "lla" = "eza -la --icons --git --header --group-directories-first";
      "llaog" = "eza -la --icons --git --header -og --group-directories-first";
      "lt" = "eza --tree --level=2 --icons";
      "lta" = "eza -a --tree --level=2 --icons";
      "lt3" = "eza --tree --level=3 --icons";

      # Search
      "grep" = "grep --color=auto";
      "egrep" = "egrep --color=auto";
      "fgrep" = "fgrep --color=auto";
      "qfind" = "find . -name";
      "bat" = "bat --color=always";
      "biggest" = "du -ah . | sort -rh | head -20";
      "sgrep" = "grep -rni --color=auto";

      # Archives
      "tar-ls" = "tar -tvf";
      "tar-extract" = "tar -xvf";
      "tar-create" = "tar -cvf";
      "tar-gz" = "tar -czvf";
      "tar-bz2" = "tar -cjvf";
      "gz-extract" = "tar -xzvf";
      "bz2-extract" = "tar -xjvf";
      "zip-create" = "zip -r";
      "unzip-all" = "unzip";

      # Process monitoring
      "h" = "history";
      "j" = "jobs -l";
      "ps-all" = "ps auxf";
      "ps-grep" = "ps aux | grep -v grep | grep -i";
      "kill9" = "kill -9";
      "pkill-name" = "pkill -f";
      "topcpu" = "ps wwaxr -o pid,user,%cpu,time,command | head -15";
      "topmem" = "ps wwaxr -o pid,user,%mem,rss,command | head -15";
      "ttop" = "top -b -n1 | head -30";
      "iotop" = "iotop -o";
      "watch-proc" = "watch -n1 'ps auxf'";

      # Disk / memory / hardware
      "df" = "df -hT --exclude-type=tmpfs --exclude-type=devtmpfs";
      "du" = "du -ch";
      "duh" = "du -sh *";
      "free" = "free -h";
      "lsblk" = "lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,UUID";
      "lspci" = "lspci -v";
      "lsusb" = "lsusb -v 2>/dev/null | grep -E '^Bus|iProduct|iManufacturer'";
      "cpuinfo" = "lscpu";
      "meminfo" = "cat /proc/meminfo";
      "bittype" = "grep -qP '^flags\\s*:.*\\blm\\b' /proc/cpuinfo && echo 64-bit || echo 32-bit";
      "mountrw" = "mount -o remount,rw";

      # Date / time
      "da" = "date '+%Y-%m-%d %A    %T %Z'";
      "bdate" = "date '+%a, %b %d %Y %T %Z'";
      "today" = "date +'%A, %B %-d, %Y'";
      "mytime" = "date +%H:%M:%S";
      "stamp" = "date '+%Y%m%d%a%H%M'";
      "timestamp" = "date '+%Y%m%dT%H%M%S'";
      "epochtime" = "date +%s";
      "cal3" = "cal -3";
      "weeknum" = "date +%V";

      # Networking
      "ip" = "ip -c";
      "ipa" = "ip -c a";
      "ipr" = "ip route show";
      "ip6" = "ip -6 -c a";
      "myip" = "curl -s ip-api.com";
      "myip-plain" = "curl -s ifconfig.me";
      "ports" = "ss -tulanp";
      "netCons" = "ss -tp";
      "openPorts" = "ss -tlnp";
      "openPortsUDP" = "ss -ulnp";
      "lsock" = "sudo lsof -i -P -n";
      "lsockT" = "sudo lsof -nP | grep TCP";
      "lsockU" = "sudo lsof -nP | grep UDP";
      "tracert" = "traceroute";
      "pingg" = "ping -c5";
      "flushDNS" = "sudo resolvectl flush-caches";
      "showDNS" = "resolvectl status";
      "pserv" = "python3 -m http.server 8000";
      "showpath" = "echo \"\$PATH\" | tr \":\" \"\\n\" | sort";
      "show_options" = "shopt";

      # Web / servers
      "editHosts" = "sudo nano /etc/hosts";
      "nginx-edit" = "sudo nano /etc/nginx/nginx.conf";
      "nginx-restart" = "sudo systemctl restart nginx";
      "nginx-test" = "sudo nginx -t";
      "nginx-logs" = "sudo journalctl -u nginx -f";
      "ssh-restart" = "sudo systemctl restart sshd";
      "ssh-status" = "sudo systemctl status sshd";
      "tail-auth" = "sudo journalctl -u systemd-logind -f";
      "tail-syslog" = "sudo journalctl -f";
      "tail-kern" = "sudo journalctl -k -f";

      # Git
      "gs" = "git status";
      "ga" = "git add";
      "gaa" = "git add .";
      "gc" = "git commit -m";
      "gp" = "git push";
      "gpl" = "git pull";
      "gl" = "git log --oneline --graph --decorate --all";
      "gd" = "git diff";
      "gds" = "git diff --staged";
      "gb" = "git branch -a";
      "gco" = "git checkout";
      "gcb" = "git checkout -b";
      "gst" = "git stash";
      "gstp" = "git stash pop";
      "gitup" = "git add . && git commit -m 'updated' && git push";

      # Docker / Podman
      "dps" = "docker ps -a";
      "di" = "docker images";
      "dex" = "docker exec -it";
      "dlogs" = "docker logs -f";
      "dstop" = "docker stop \$(docker ps -q)";
      "drm" = "docker rm \$(docker ps -aq)";
      "drmi" = "docker rmi \$(docker images -q)";
      "dprune" = "docker system prune -af --volumes";
      "dc" = "docker-compose";
      "dcu" = "docker-compose up -d";
      "dcd" = "docker-compose down";
      "dcl" = "docker-compose logs -f";
      "pps" = "podman ps -a";
      "pex" = "podman exec -it";
      "pstop" = "podman stop \$(podman ps -q)";
      "pprune" = "podman system prune -af";

      # Crypto / encoding (general utilities)
      "rot13" = "tr 'A-Za-z' 'N-ZA-Mn-za-m'";
      "rot18" = "tr 'A-Za-z0-9' 'N-ZA-Mn-za-m5-90-4'";
      "rot47" = "tr '!-~' 'P-~!-O'";
      "base64-enc" = "base64";
      "base64-dec" = "base64 -d";
      "xxd-view" = "xxd";
      "strings-all" = "strings -a";

      # NixOS — flake-based rebuilds
      "nsw" = "sudo nixos-rebuild switch";
      "nbd" = "sudo nixos-rebuild build";
      "nts" = "sudo nixos-rebuild test";
      "ndr" = "sudo nixos-rebuild dry-build";
      "nbt" = "sudo nixos-rebuild boot";

      "nrst" = "cd ~/.config/nixos && sudo nixos-rebuild switch --flake .#titan";
      "nrsg" = "cd ~/.config/nixos && sudo nixos-rebuild switch --flake .#ghost";
      "nrss" = "cd ~/.config/nixos && sudo nixos-rebuild switch --flake .#server";
      "nrsm" = "cd ~/.config/nixos && sudo nixos-rebuild switch --flake .#minimal";

      "ndrt" = "cd ~/.config/nixos && sudo nixos-rebuild dry-build --flake .#titan";
      "ndrg" = "cd ~/.config/nixos && sudo nixos-rebuild dry-build --flake .#ghost";
      "ndrs" = "cd ~/.config/nixos && sudo nixos-rebuild dry-build --flake .#server";
      "ndrm" = "cd ~/.config/nixos && sudo nixos-rebuild dry-build --flake .#minimal";

      "nag" = "alias | grep -i nix";
      "v" = "vim";
      "nv" = "nvim";

      "nsr" = "nix search nixpkgs";
      "nin" = "nix-env -iA nixpkgs";
      "nrm" = "nix-env -e";
      "nls" = "nix-env -q";
      "nup" = "nix-env -u";
      "ngc" = "nix-collect-garbage";
      "ngo" = "sudo nix-collect-garbage --delete-older-than 30d ; sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch";
      "nso" = "nix-store --optimise";
      "nsh" = "nix-shell --run bash";

      "nfu" = "nix flake update";
      "nfc" = "nix flake check";
      "ndv" = "nix develop";

      # Systemd
      "sctl" = "sudo systemctl";
      "scts" = "sudo systemctl status";
      "sctr" = "sudo systemctl restart";
      "sctt" = "sudo systemctl start";
      "sctsp" = "sudo systemctl stop";
      "scte" = "sudo systemctl enable";
      "sctsd" = "sudo systemctl disable";
      "sctlr" = "sudo systemctl daemon-reload";
      "fail" = "systemctl --failed";
      "jrn" = "sudo journalctl -xe";
      "jrnb" = "sudo journalctl -b";
      "jrnu" = "journalctl --user";

      # User / group
      "grps" = "groups | xargs -n1 | sort";
      "lstl" = "last -n 20";
      "flog" = "sudo lastb -n 20";
      "wtf" = "who -a";

      # SSH
      "kgen" = "ssh-keygen -t ed25519 -C \"\$(whoami)@\$(hostname)\"";
      "kscp" = "ssh-copy-id";
      "kls" = "ls -la ~/.ssh/";
      "khs" = "cat ~/.ssh/known_hosts";
      "rmkh" = "ssh-keygen -R";

      # System info
      "info" = "uname -a && echo 'NixOS \$(nixos-version)'";
      "ff" = "fastfetch";
      "btype" = "grep -qP '^flags\\s*:.*\\blm\\b' /proc/cpuinfo && echo 64-bit || echo 32-bit";

      # Certificates
      "sslc" = "openssl x509 -text -noout -in";
      "sslr" = "openssl s_client -connect";

      # NixOS generations
      "ngs" = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      "nrb" = "sudo nixos-rebuild switch --rollback";

      # Screen / tmux
      "ta" = "tmux attach || tmux new";
      "tls" = "tmux ls";
      "tn" = "tmux new -s";

      # Notes
      "note" = "mkdir -p ~/notes && \"\${EDITOR:-nano}\" ~/notes/\$(date +%Y%m%d).md";
      "notes" = "ls -lt ~/notes/";

      # Kitty
      "s" = "kitten ssh";
      "themes" = "kitty +kitten themes";

      # Calendar
      "cal" = "ncal -b";

      # Weather
      "weather" = "curl wttr.in";
      "weather-short" = "curl 'wttr.in/?format=3'";

      # Fun
      "matrix" = "cmatrix -r";

      # Maintenance
      "clng" = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system";
      "cln30" = "sudo nix-collect-garbage --delete-older-than 30d";
      "clnall" = "sudo nix-collect-garbage -d";
      "clearhistory" = "echo '' > ~/.bash_history && history -c && { command -v atuin > /dev/null && atuin search --delete-it-all; true; }";

      # Flake-based full update
      "update" = "nix flake update && sudo nixos-rebuild switch --flake .#\${HOSTNAME} && nix-collect-garbage --delete-older-than 7d && nix-store --optimise && tldr --update && figlet 'System Optimized!' | lolcat";
    };

    # ── Shell functions and init code ────────────────────────────────────────────
    bashrcExtra = ''
      # Source ble.sh early (before other integrations)
      [[ $- == *i* ]] \u0026\u0026 source -- "$(blesh-share)"/ble.sh --attach=none
    '';

    initExtra = ''
      # Source NixOS environment variables (FZF_DEFAULT_OPTS, etc.)
      [ -f /etc/set-environment ] \u0026\u0026 source /etc/set-environment

      # Enable vi mode for bash
      set -o vi

      # cd with negative numbers: cd -2 goes up 2 directories
      cd() {
        if [[ "$1" =~ ^-[0-9]+$ ]]; then
          local n=''${1#-} path=""
          for ((i = 0; i < n; i++)); do path+="../"; done
          builtin cd "$path" || return
        else
          builtin cd "$@" || return
        fi
      }

      # colorize output via grc
      export GRC_ALIASES=true

      # preferred editor
      export EDITOR="vim"

      # batman integration
      if command -v batman > /dev/null 2>&1; then
        eval "$(batman --export-env)"
      fi

      # carapace
      if command -v carapace > /dev/null 2>&1; then
        export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
        source <(carapace _carapace)
      fi

      # Atuin
      if command -v atuin > /dev/null 2>&1; then
        eval "$(atuin init bash)"
      fi

      # zoxide
      if command -v zoxide > /dev/null 2>&1; then
        eval "$(zoxide init bash)"
      fi

      # starship prompt
      if command -v starship > /dev/null 2>&1; then
        eval "$(starship init bash)"
      fi

      # Welcome message
      if command -v lolcat > /dev/null 2>&1; then
        echo "w3lc0m3 h4ck3r - let the games begin! - m4ast3r y0ur cr4ft" | lolcat
      fi

      # Attach ble.sh if loaded
      if [[ ''${BLE_VERSION-} ]]; then
        ble-attach
      fi
    '';
  };
}
