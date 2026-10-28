# Home Manager module: Bash for infrastructure / sysadmin / Nix work
#
#   - ble.sh line editor (config inlined below, no ./blerc)
#   - grc colouring via `colourify`, eza for ls, starship + zoxide + atuin + fzf
#   - Nix, systemd, git and container aliases; helper functions at the bottom
#
# Aliases live in their own ~/.bash_aliases (generated below, grouped by topic);
# ~/.bashrc only sources it.
# ~/.bashrc order: bashrcExtra (ble.sh) -> initExtra (aliases file, env,
# functions, atuin, zoxide) -> ble-attach last.
{
  lib,
  pkgs,
  ...
}: let
  # `colourify <cmd>` runs a command through grc. Aliases that need quoting
  # tricks or logic are functions further down instead.
  colourised =
    lib.genAttrs [
      "blkid"
      "dig"
      "fdisk"
      "findmnt"
      "ifconfig"
      "lsof"
      "mount"
      "mtr"
      "netstat"
      "ping"
      "ss"
      "traceroute"
      "whois"
    ] (cmd: "colourify ${cmd}")
    // {
      colourify = "grc -es --colour=auto";
      df = "colourify df -hT --exclude-type=tmpfs --exclude-type=devtmpfs";
      free = "colourify free -h";
      lsblk = "colourify lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,UUID";
      lspci = "colourify lspci -v";
    };

  shell = {
    sudo = "sudo "; # trailing space: aliases (colourify, ...) expand after sudo
    watch = "watch ";
    c = "clear";
    e = "exit";
    v = "vim";
    nv = "nvim";
    src = "source ~/.bashrc";
    lg = "lazygit";
    b = "btop";
    h = "history";
    j = "jobs -l";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    cdc = "cd ~/.config";
    grep = "grep --color=auto";
    diff = "diff --color=auto";
    rgi = "rg -i";
    sv = "sudoedit";
    showpath = "echo \"$PATH\" | tr : '\\n' | nl";
    biggest = "du -ah . | sort -rh | head -20";
    cheat = "tldr";
  };

  # eza replaces ls
  eza = let
    base = "eza --icons=auto --git --group-directories-first";
  in {
    ls = base;
    ll = "${base} -l --header";
    la = "${base} -a";
    lla = "${base} -la --header";
    lt = "${base} --tree --level=2";
    lta = "${base} -a --tree --level=2";
    lgi = "${base} --tree --git-ignore"; # tree, respecting .gitignore
    lS = "${base} -la --header --sort=size --reverse"; # biggest first
    lm = "${base} -la --header --sort=modified --reverse"; # newest first
  };

  system = {
    cpuinfo = "lscpu";
    temp = "sensors";
    topcpu = "ps -eo pid,user,%cpu,%mem,etime,comm --sort=-%cpu | head -15";
    topmem = "ps -eo pid,user,%mem,rss,etime,comm --sort=-%mem | head -15";
    grps = "groups | xargs -n1 | sort";
    lstl = "last -n 20";
    flog = "sudo lastb -n 20";
    sysg = "sysctl -a 2>/dev/null | grep -i --";
    genpass = "openssl rand -base64 32";
    genhex = "openssl rand -hex 32";
    isodate = "date -u +%Y-%m-%dT%H:%M:%SZ";
    stamp = "date +%Y%m%dT%H%M%S";
  };

  systemd = {
    fail = "systemctl --failed";
    timers = "systemctl list-timers";
    scrit = "systemd-analyze critical-chain";
    sblame = "systemd-analyze blame | head -20";
    sctl = "sudo systemctl";
    sctu = "systemctl --user";
    scts = "sudo systemctl status";
    sctt = "sudo systemctl start";
    sctsp = "sudo systemctl stop";
    sctr = "sudo systemctl restart";
    scte = "sudo systemctl enable";
    sctsd = "sudo systemctl disable";
    sctlr = "sudo systemctl daemon-reload";
    sctls = "systemctl list-units --type=service --state=running";
    jrn = "sudo journalctl -xe";
    jrnb = "sudo journalctl -b";
    jrnu = "journalctl --user";
    jrnp = "sudo journalctl -b -p err";
  };

  network = {
    ports = "sudo ss -tulpn";
    lsock = "sudo lsof -i -P -n";
    ipr = "ip route show";
    ip6 = "ip -6 -c a";
    iptl = "sudo iptables -L -n -v --line-numbers";
    nftl = "sudo nft list ruleset";
    pingg = "ping -c5";
    rdns = "dig +short -x";
    flushDNS = "sudo resolvectl flush-caches";
    showDNS = "resolvectl status";
    myip = "curl -s ifconfig.me";
    curl-headers = "curl -sI";
    curl-time = "curl -s -o /dev/null -w 'dns %{time_namelookup}s  connect %{time_connect}s  tls %{time_appconnect}s  total %{time_total}s\\n'";
    sslc = "openssl x509 -text -noout -in";
    sslr = "openssl s_client -connect";
    kgen = "ssh-keygen -t ed25519 -C \"$USER@$HOSTNAME\"";
    kscp = "ssh-copy-id";
    sadd = "ssh-add";
    sl = "ssh-add -l";
  };

  nix = {
    ncd = "cd \"$NIXCFG\"";
    nb = "nix build";
    nbp = "nix build --no-link --print-out-paths";
    ndv = "nix develop";
    nrepl = "nix repl";
    nrepl-pkgs = "nix repl nixpkgs";
    nsr = "nix search nixpkgs";
    nlog = "nix log";
    nwhy = "nix why-depends";
    ntree = "nix-tree";
    nconf = "nix show-config";
    nver = "nixos-version";
    ncur = "readlink -f /run/current-system";
    nrepair = "sudo nix-store --verify --check-contents --repair";
    nfc = "nix flake check";
    nfl = "nix flake lock";
    nfm = "nix flake metadata";
    nfs = "nix flake show";
    nfu = "nix flake update";
    nfmt = "nix fmt";
    nlint = "statix check";
    nfix = "statix fix";
    ndead = "deadnix";
    nls = "nix profile list";
    nreg = "nix registry list";
    update = "nupgrade";
    hmg = "home-manager generations";

    # per-host rebuilds, full commands ($NIXCFG = flake dir, so they work anywhere)
    nrb = "sudo nixos-rebuild switch --rollback";
    nrbt = "sudo nixos-rebuild dry-build --flake .#titan";
    nrbm = "sudo nixos-rebuild dry-build --flake .#minimal";
    nrbs = "sudo nixos-rebuild dry-build --flake .#server";
    nrbg = "sudo nixos-rebuild dry-build --flake .#ghost";
    nrst = "sudo nixos-rebuild switch --flake .#titan";
    nrsm = "sudo nixos-rebuild switch --flake .#minimal";
    nrss = "sudo nixos-rebuild switch --flake .#server";
    nrsg = "sudo nixos-rebuild switch --flake .#ghost";

    # generations and garbage collection
    ngs = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    clng = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system";
    ngc7 = "sudo nix-collect-garbage --delete-older-than 7d";
    cln30 = "sudo nix-collect-garbage --delete-older-than 30d";
  };

  infra = {
    # docker / podman
    dc = "docker compose";
    dcu = "docker compose up -d";
    dcd = "docker compose down";
    dcr = "docker compose restart";
    dcl = "docker compose logs -f";
    dcps = "docker compose ps";
    dcpull = "docker compose pull";
    dps = "docker ps -a";
    di = "docker images";
    dlogs = "docker logs -f";
    dstats = "docker stats --no-stream";
    lzd = "lazydocker";
    pps = "podman ps -a";
    pi = "podman images";
    plogs = "podman logs -f";
    pex = "podman exec -it";

    # kubernetes
    k = "kubectl";
    kg = "kubectl get";
    kgp = "kubectl get pods -o wide";
    kgn = "kubectl get nodes -o wide";
    kd = "kubectl describe";
    kaf = "kubectl apply -f";
    kdf = "kubectl delete -f";
    kl = "kubectl logs -f";
    kx = "kubectl exec -it";
    kctx = "kubectl config use-context";

    # k8s extras
    ks = "k9s";
    hl = "helm";
    hli = "helm install";
    hlun = "helm uninstall";
    hlst = "helm status";
    kns = "kubens";
    kctxn = "kubectx";

    # terraform / ansible / direnv
    tf = "terraform";
    tfi = "terraform init";
    tfp = "terraform plan";
    tfa = "terraform apply";
    tfd = "terraform destroy";
    tfv = "terraform validate";
    tff = "terraform fmt -recursive";
    ap = "ansible-playbook";
    apc = "ansible-playbook --check --diff";
    ai = "ansible-inventory --graph";
    alint = "ansible-lint";
    dra = "direnv allow";
    drr = "direnv reload";
  };
  # ~/.bash_aliases: one commented section per group
  aliasGroups = {
    "shell" = shell;
    "eza (ls)" = eza;
    "grc colour" = colourised;
    "system" = system;
    "systemd" = systemd;
    "network & ssh" = network;
    "nix" = nix;
    "containers, kubernetes, terraform, ansible" = infra;
  };

  aliasLines = set:
    lib.concatStringsSep "\n" (lib.mapAttrsToList
      (name: value: "alias -- ${name}=${lib.escapeShellArg value}")
      set);

  bashAliases = lib.concatStringsSep "\n\n" (lib.mapAttrsToList
    (title: set: "# ----- ${title} -----\n${aliasLines set}")
    aliasGroups);
in {
  home.packages = with pkgs; [
    blesh
    grc
    nvd
    nix-output-monitor
  ];

  # ---------------------------------------------------------------------------
  # ble.sh (replaces ./blerc)
  # ---------------------------------------------------------------------------
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
  programs.starship.enable = true;
  programs.fzf.enable = true;

  # eza's ls aliases are in ~/.bash_aliases; zoxide's hook is started by hand
  # (initExtra) so it is initialised last, as zoxide requires
  programs.eza = {
    enable = true;
    enableBashIntegration = lib.mkForce false;
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = lib.mkForce false;
  };

  # atuin itself is enabled in atuin.nix; its bash hook is started by hand below
  # (initExtra) so it loads after ble.sh and does not use bash-preexec
  programs.atuin.enableBashIntegration = lib.mkForce false;

  home.file.".bash_aliases".text = bashAliases + "\n";

  # ---------------------------------------------------------------------------
  # Bash
  # ---------------------------------------------------------------------------
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = ["ignoredups" "ignorespace"];
    historySize = 100000;
    historyFileSize = 200000;

    bashrcExtra = ''
      # ble.sh must be sourced first (interactive shells only); it attaches at the very end
      if [[ $- == *i* ]] && command -v blesh-share >/dev/null 2>&1; then
        source -- "$(blesh-share)"/ble.sh --attach=none
      fi
    '';

    initExtra = lib.mkMerge [
      ''
        # aliases live in ~/.bash_aliases (generated by bash.nix)
        [[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

        export NIXCFG="''${NIXCFG:-$HOME/.config/nixos}"   # flake location, used by the n* helpers
        export EDITOR=vim
        export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
        set -o vi

        _have() { command -v "$1" >/dev/null 2>&1; }

        # ----- NixOS rebuilds: n<action> [host] [extra args]; host defaults to $HOSTNAME -----
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

        # switch with nix-output-monitor
        nswn() {
          sudo nixos-rebuild switch --flake "$NIXCFG#''${1:-$HOSTNAME}" --log-format internal-json -v |& nom --json
        }

        # ndeploy <flake-host> <user@address> [switch|boot|test]
        ndeploy() {
          [[ $# -ge 2 ]] || { echo "usage: ndeploy <flake-host> <user@address> [switch|boot|test]" >&2; return 1; }
          nixos-rebuild "''${3:-switch}" --flake "$NIXCFG#$1" --target-host "$2" --sudo
        }

        # update inputs, switch, show what changed, collect garbage
        nupgrade() {
          ( cd "$NIXCFG" && nix flake update ) || return
          nsw "$@" || return
          ndiff
          sudo nix-collect-garbage --delete-older-than 7d && nix-store --optimise
        }

        # package diff between two system closures (default: booted vs current)
        ndiff() {
          local a=''${1:-/run/booted-system} b=''${2:-/run/current-system}
          if _have nvd; then nvd diff "$a" "$b"; else nix store diff-closures "$a" "$b"; fi
        }

        # ns foo bar  ->  nix shell nixpkgs#foo nixpkgs#bar
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

        nopt()       { nix eval "$NIXCFG#nixosConfigurations.''${2:-$HOSTNAME}.config.$1"; }   # nopt services.openssh.enable [host]
        nrepl-host() { nix repl "$NIXCFG#nixosConfigurations.''${1:-$HOSTNAME}"; }
        hms()        { home-manager switch --flake "$NIXCFG#''${1:-$USER}"; }

        # ----- systemd / system -----
        jfu()       { sudo journalctl -fu "''${1:?usage: jfu <unit>}"; }
        portcheck() { nc -zv "''${1:?usage: portcheck <host> <port>}" "''${2:?}"; }

        fkill() {
          local pids
          pids=$(ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | sed 1d | fzf -m --reverse | awk '{print $1}')
          # shellcheck disable=SC2086
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

        # ----- git / containers -----
        gitup() { git add -A && git commit -m "''${*:-update}" && git push; }

        # delete local branches already merged into main/master/develop
        gprune() {
          git fetch --prune &&
            git branch --merged | grep -Ev '^\*|^\s*(main|master|develop)$' | xargs -r git branch -d
        }

        dsh() { docker exec -it "''${1:?usage: dsh <container> [shell]}" "''${2:-sh}"; }
        kns() { kubectl config set-context --current --namespace="''${1:?usage: kns <namespace>}"; }
      ''
      (lib.mkOrder 1900 ''
        # atuin after ble.sh so it hooks ble's history; after fzf so Ctrl-R is atuin's
        if _have atuin; then eval "$(atuin init bash)"; fi
      '')
      (lib.mkOrder 1950 ''
        # zoxide must initialise last (after starship/atuin). ble.sh runs the prompt
        # hooks itself, so zoxide's PROMPT_COMMAND self-check would false-positive.
        export _ZO_DOCTOR=0
        if _have zoxide; then eval "$(zoxide init bash)"; fi
      '')
      (lib.mkOrder 2000 ''
        # ble.sh attaches LAST, once every other prompt/key hook is registered
        [[ ! ''${BLE_VERSION-} ]] || ble-attach
      '')
    ];
  };
}
