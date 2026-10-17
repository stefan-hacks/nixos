# Bash shell: history, options, session vars, aliases and helpers.
# Absorbs the old ~/.bashrc and ~/.bash_aliases (681 lines) into pure Nix.
# On first activation Home Manager renames the old files to *.bak.
{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = [ "ignoreboth" ];
    historySize = 3000;
    historyFileSize = 6000;

    shellOptions = [
      "histappend"
      "checkwinsize"
      "globstar" # ** recursion
      "extglob" # extended glob operators
      "dotglob" # include hidden files in globs
    ];

    sessionVariables = {
      TERM = "xterm-256color";
      GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
      GRC_ALIASES = "true";
      BAT_THEME = "Coldark-Dark";
      CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
    };

    shellAliases = {
      # ── 1. Safety nets & core overrides ──────────────────────────────────
      cp = "cp -vi";
      mv = "mv -vi";
      rm = "rm -Iv --one-file-system";
      ln = "ln -i";
      mkdir = "mkdir -pv";
      wget = "wget -c";
      less = "less -FSRXc";
      path = ''echo $PATH | tr ":" "\n"'';
      cpv = "rsync -avh --info=progress2";

      # ── 2. Navigation & file management ──────────────────────────────────
      c = "clear";
      e = "exit";
      src = "source ~/.bashrc";
      ".." = "cd -1";
      "..." = "cd -2";
      "...." = "cd -3";
      lsk = ''gsettings list-recursively | grep -i keybind | cut -d ' ' -f2,3 | grep -Ev '(@as|disabled|false|default)' | sort | nl'';
      lskd = ''gsettings list-recursively | grep -i keybind | cut -d ' ' -f2,3 | grep -Ev '(@as|false|default)' | sort | nl'';
      numFiles = "echo $(ls -1 | wc -l)";
      hfiles = ''ls -A | grep "^\."'';
      hdirs = "ls -ld .*/ */";
      make1mb = "truncate -s 1m ./1MB.dat";
      make5mb = "truncate -s 5m ./5MB.dat";
      make10mb = "truncate -s 10m ./10MB.dat";
      perm = ''stat --printf "%a %n\n"'';
      "000" = "chmod 000";
      "640" = "chmod 640";
      "644" = "chmod 644";
      "755" = "chmod 755";
      "775" = "chmod 775";
      mx = "chmod a+x";
      ux = "chmod u+x";
      rnx = ''for i in *; do mv "$i" "''${i%.*}.txt"; done'';

      # ── 3. Listing (eza) ────────────────────────────────────────────────
      ls = "eza --icons --git --group-directories-first";
      ll = "eza -l --icons --git --header --group-directories-first";
      llog = "eza -l --icons --git --header -og --group-directories-first";
      lsa = "eza -a --icons --git --group-directories-first";
      lla = "eza -la --icons --git --header --group-directories-first";
      llaog = "eza -la --icons --git --header -og --group-directories-first";
      lt = "eza --tree --level=2 --icons";
      lta = "eza -a --tree --level=2 --icons";
      lt3 = "eza --tree --level=3 --icons";

      # ── 4. Searching & filtering ────────────────────────────────────────
      # NOTE: `fzf` alias intentionally absent — programs.fzf.defaultOptions
      # in shell-tools.nix applies the bat preview to every invocation.
      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      qfind = "find . -name";
      bat = "bat --color=always";
      biggest = "du -ah . | sort -rh | head -20";
      sgrep = "grep -rni --color=auto";

      # ── 5. Archiving & compression ──────────────────────────────────────
      tar-ls = "tar -tvf";
      tar-extract = "tar -xvf";
      tar-create = "tar -cvf";
      tar-gz = "tar -czvf";
      tar-bz2 = "tar -cjvf";
      gz-extract = "tar -xzvf";
      bz2-extract = "tar -xjvf";
      zip-create = "zip -r";
      unzip-all = "unzip";
      zcat = "zcat";

      # ── 6. Process & system monitoring ──────────────────────────────────
      h = "history";
      j = "jobs -l";
      ps-all = "ps auxf";
      ps-grep = "ps aux | grep -v grep | grep -i";
      kill9 = "kill -9";
      pkill-name = "pkill -f";
      topcpu = "ps wwaxr -o pid,user,%cpu,time,command | head -15";
      topmem = "ps wwaxr -o pid,user,%mem,rss,command  | head -15";
      ttop = "top -b -n1 | head -30";
      iotop = "iotop -o";
      watch-proc = ''watch -n1 "ps auxf"'';

      # ── 7. Disk, memory & hardware ──────────────────────────────────────
      df = "df -hT --exclude-type=tmpfs --exclude-type=devtmpfs";
      du = "du -ch";
      duh = "du -sh *";
      free = "free -h";
      lsblk = "lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,UUID";
      lspci = "lspci -v";
      lsusb = ''lsusb -v 2>/dev/null | grep -E "^Bus|iProduct|iManufacturer"'';
      cpuinfo = "lscpu";
      meminfo = "cat /proc/meminfo";
      bittype = ''grep -qP '^flags\s*:.*\blm\b' /proc/cpuinfo && echo 64-bit || echo 32-bit'';
      mountrw = "mount -o remount,rw";

      # ── 8. Date & time ──────────────────────────────────────────────────
      da = ''date "+%Y-%m-%d %A    %T %Z"'';
      bdate = "date '+%a, %b %d %Y %T %Z'";
      today = ''date +"%A, %B %-d, %Y"'';
      mytime = "date +%H:%M:%S";
      stamp = ''date "+%Y%m%d%a%H%M"'';
      timestamp = ''date "+%Y%m%dT%H%M%S"'';
      epochtime = "date +%s";
      cal3 = "cal -3";
      weeknum = "date +%V";
      daysleft = ''echo "There are $(($(date +%j -d"Dec 31, $(date +%Y)")-$(date +%j))) days left in $(date +%Y)."'';

      # ── 9. Networking ───────────────────────────────────────────────────
      ip = "ip -c";
      ipa = "ip -c a";
      ipr = "ip route show";
      ip6 = "ip -6 -c a";
      myip = "curl -s ip-api.com";
      myip-plain = "curl -s ifconfig.me";
      ports = "ss -tulanp";
      netCons = "ss -tp";
      openPorts = "ss -tlnp";
      openPortsUDP = "ss -ulnp";
      lsock = "sudo lsof -i -P -n";
      lsockT = "sudo lsof -nP | grep TCP";
      lsockU = "sudo lsof -nP | grep UDP";
      tracert = "traceroute";
      pingg = "ping -c5";
      flushDNS = "sudo resolvectl flush-caches";
      showDNS = "resolvectl status";
      pserv = "python3 -m http.server 8000";
      showpath = ''echo "$PATH" | tr ":" "\n" | sort'';
      show_options = "shopt";

      # ── 10. Web development & servers ───────────────────────────────────
      editHosts = "sudo nano /etc/hosts";
      nginx-edit = "sudo nano /etc/nginx/nginx.conf";
      nginx-restart = "sudo systemctl restart nginx";
      nginx-test = "sudo nginx -t";
      nginx-logs = "sudo journalctl -u nginx -f";
      ssh-restart = "sudo systemctl restart sshd";
      ssh-status = "sudo systemctl status sshd";
      tail-auth = "sudo journalctl -u systemd-logind -f";
      tail-syslog = "sudo journalctl -f";
      tail-kern = "sudo journalctl -k -f";

      # ── 11. Git ─────────────────────────────────────────────────────────
      gs = "git status";
      ga = "git add";
      gaa = "git add .";
      gc = "git commit -m";
      gp = "git push";
      gpl = "git pull";
      gl = "git log --oneline --graph --decorate --all";
      gd = "git diff";
      gds = "git diff --staged";
      gb = "git branch -a";
      gco = "git checkout";
      gcb = "git checkout -b";
      gst = "git stash";
      gstp = "git stash pop";
      gitup = ''git add . && git commit -m "updated" && git push'';

      # ── 12. Docker/Podman ───────────────────────────────────────────────
      dps = "docker ps -a";
      di = "docker images";
      dex = "docker exec -it";
      dlogs = "docker logs -f";
      dstop = "docker stop $(docker ps -q)";
      drm = "docker rm $(docker ps -aq)";
      drmi = "docker rmi $(docker images -q)";
      dprune = "docker system prune -af --volumes";
      dc = "docker-compose";
      dcu = "docker-compose up -d";
      dcd = "docker-compose down";
      dcl = "docker-compose logs -f";
      pps = "podman ps -a";
      pex = "podman exec -it";
      pstop = "podman stop $(podman ps -q)";
      pprune = "podman system prune -af";

      # ── 13. Cryptography & encoding ─────────────────────────────────────
      openssl-enc = "openssl enc -aes-256-ctr -pbkdf2 -e -a -in /dev/stdin -out encrypted_file.txt";
      openssl-dec = "openssl enc -aes-256-ctr -pbkdf2 -d -a -in /dev/stdin -out decrypted_file.txt";
      rot13 = "tr 'A-Za-z' 'N-ZA-Mn-za-m'";
      rot18 = "tr 'A-Za-z0-9' 'N-ZA-Mn-za-m5-90-4'";
      rot47 = "tr '\\!-~' 'P-~\\!-O'";
      base64-enc = "base64";
      base64-dec = "base64 -d";
      xxd-view = "xxd";
      strings-all = "strings -a";

      # ── 14. Colourised commands (grc) ── see initExtra block ─────────────

      # ── 15. NixOS helpers ───────────────────────────────────────────────
      nrs = "sudo nixos-rebuild switch";
      nbd = "sudo nixos-rebuild build";
      nts = "sudo nixos-rebuild test";
      ndr = "sudo nixos-rebuild dry-build";
      nbt = "sudo nixos-rebuild boot";
      nag = "alias | grep -i nix";
      v = "vim";
      nv = "nvim";
      nsr = "nix search nixpkgs";
      nin = "nix-env -iA nixpkgs";
      nrm = "nix-env -e";
      nls = "nix-env -q";
      nup = "nix-env -u";
      ngc = "nix-collect-garbage";
      ngo = "sudo nix-collect-garbage --delete-older-than 30d ; sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch";
      nso = "nix-store --optimise";
      nsh = "nix-shell --run bash";
      nfu = "nix flake update";
      nfc = "nix flake check";
      ndv = "nix develop";
      sctl = "sudo systemctl";
      scts = "sudo systemctl status";
      sctr = "sudo systemctl restart";
      sctt = "sudo systemctl start";
      sctsp = "sudo systemctl stop";
      scte = "sudo systemctl enable";
      sctsd = "sudo systemctl disable";
      sctlr = "sudo systemctl daemon-reload";
      fail = "systemctl --failed";
      jrn = "sudo journalctl -xe";
      jrnb = "sudo journalctl -b";
      jrnu = "journalctl --user";
      grps = "groups | xargs -n1 | sort";
      lstl = "last -n 20";
      flog = "sudo lastb -n 20";
      wtf = "who -a";
      kgen = ''ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)"'';
      kscp = "ssh-copy-id";
      kls = "ls -la ~/.ssh/";
      khs = "cat ~/.ssh/known_hosts";
      rmkh = "ssh-keygen -R";
      info = ''uname -a && echo "NixOS $(nixos-version)"'';
      ff = "fastfetch";
      btype = ''grep -qP '^flags\s*:.*\blm\b' /proc/cpuinfo && echo 64-bit || echo 32-bit'';
      sslc = "openssl x509 -text -noout -in";
      sslr = "openssl s_client -connect";
      ngs = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      nrb = "sudo nixos-rebuild switch --rollback";
      hdtp = "sudo hddtemp /dev/sd?";
      ctmp = ''cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | awk "{print \$1/1000 \"°C\"}"'';
      ta = "tmux attach || tmux new";
      tls = "tmux ls";
      tn = "tmux new -s";
      note = ''mkdir -p ~/notes && "''${EDITOR:-nano}" ~/notes/$(date +%Y%m%d).md'';
      notes = "ls -lt ~/notes/";

      # ── 16–26. Security / CTF ── moved to user-level/profiles/ctf.nix ────

      # ── 27. Maintenance & updates ───────────────────────────────────────
      # NOTE: `nix flake update` runs in the CURRENT directory — run from the repo.
      update = ''
        nix flake update \
            && sudo nixos-rebuild switch --flake .#$HOSTNAME \
            && nix-collect-garbage --delete-older-than 7d \
            && nix-store --optimise \
            && tldr --update \
            && figlet "System Optimized!" | lolcat'';
      clng = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system";
      cln30 = "sudo nix-collect-garbage --delete-older-than 30d";
      clnall = "sudo nix-collect-garbage -d";
      clearhistory = ''
        echo "" > ~/.bash_history && history -c \
            && { command -v atuin &>/dev/null && atuin search --delete-it-all; true; }'';

      # ── 28. Miscellaneous / fun ─────────────────────────────────────────
      matrix = "cmatrix -r";
      starwars = "telnet towel.blinkenlights.nl";
      themes = "kitty +kitten themes";
      cal = "ncal -b";
      weather = "curl wttr.in";
      weather-short = ''curl "wttr.in/?format=3"'';
      cheat-sheet = "curl cheat.sh/";

      # kitty ssh passthrough
      s = "kitten ssh";
    };

    initExtra = ''
      # ble.sh — loaded first, attached at the end of init (no HM module exists).
      if command -v blesh-share &>/dev/null; then
        source -- "$(blesh-share)"/ble.sh --attach=none
      fi

      # vi mode
      set -o vi

      # Colorful manpages via bat-extras batman
      if command -v batman &>/dev/null; then
        eval "$(batman --export-env)"
      fi

      # Greeting
      echo "w3lc0m3 h4ck3r - let the games begin! - m4ast3r y0ur cr4ft" | lolcat

      # ── 14. Colourised commands (grc) ───────────────────────────────────
      GRC="$(command -v grc)"
      if tty -s && [ -n "$TERM" ] && [ "$TERM" != "dumb" ] && [ -n "$GRC" ]; then
        alias colourify="$GRC -es --colour=auto"
        alias blkid='colourify blkid'
        alias configure='colourify ./configure'
        alias diff='colourify diff'
        alias docker='colourify docker'
        alias docker-compose='colourify docker-compose'
        alias df='colourify df -hT --exclude-type=tmpfs --exclude-type=devtmpfs'
        alias du='colourify du -ch'
        alias fdisk='colourify fdisk'
        alias findmnt='colourify findmnt'
        alias free='colourify free -h'
        alias gcc='colourify gcc'
        alias g++='colourify g++'
        alias id='colourify id'
        alias ifconfig='colourify ifconfig'
        alias iptables='colourify iptables'
        alias ip='colourify ip -c'
        alias journalctl='colourify journalctl'
        alias kubectl='colourify kubectl'
        alias lsblk='colourify lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,UUID'
        alias lsof='colourify lsof'
        alias lspci='colourify lspci'
        alias make='colourify make'
        alias mount='colourify mount'
        alias mtr='colourify mtr'
        alias netstat='colourify netstat'
        alias nmap='colourify nmap'
        alias ping='colourify ping'
        alias ps='colourify ps'
        alias ss='colourify ss'
        alias stat='colourify stat'
        alias tail='colourify tail'
        alias traceroute='colourify traceroute'
        alias traceroute6='colourify traceroute6'
        alias w='colourify w'
        alias whois='colourify whois'
        alias who='colourify who'
      fi

      # Jump up N directory levels:  cd -2  →  goes up two levels
      cd() {
        if [[ "$1" =~ ^-[0-9]+$ ]]; then
          local n=''${1#-} path=""
          for ((i = 0; i < n; i++)); do path+="../"; done
          builtin cd "$path" || return
        else
          builtin cd "$@" || return
        fi
      }

      # Caesar brute-force all 25 shifts
      caesar-brute() {
        local msg="''${*:-$(cat)}"
        for i in $(seq 1 25); do
          printf "ROT%02d: %s\n" "$i" "$(echo "$msg" | tr 'A-Za-z' "$(python3 -c "
      import string; n=$i
      u=string.ascii_uppercase; l=string.ascii_lowercase
      print(u[n:]+u[:n]+l[n:]+l[:n])")")"
        done
      }

      # Single-byte XOR decoder
      xor-byte() {
        python3 -c "
      import sys
      data=open(sys.argv[1],'rb').read(); key=int(sys.argv[2],0)
      print(bytes([b^key for b in data]))" "$@"
      }

      # Attach ble.sh last
      if [[ ''${BLE_VERSION-} ]]; then
        ble-attach
      fi
    '';
  };
}
