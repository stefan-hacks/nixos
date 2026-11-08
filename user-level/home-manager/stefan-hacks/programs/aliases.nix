# aliases.nix — Bash shell aliases, organised by category.
# Imported by bash.nix; kept separate so bash.nix stays focused on shell mechanics.
{lib, ...}: let
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
    v = "nvim";
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
    rgi = "rg -i";
    sv = "sudoedit";
    showpath = "echo \"$PATH\" | tr : '\\n' | nl";
    biggest = "du -ah . | sort -rh | head -20";
    ff = "fastfetch";
    cpu = "cpufetch";
    cheat = "tldr";
  };

  # bat extras — all bat-related aliases in one place
  bat = {
    bathelp = "bat -plhelp";
    man = "batman";
    diff = "batdiff";
    grep = "batgrep";
  };

  # Git shell shortcuts — these forward to the git aliases defined in git.nix
  # so you get tab-completion on `git s` and shell shortcuts on `gs`
  gitShell = {
    gs = "git s"; # git status -sb
    ga = "git a"; # git add
    gaa = "git aa"; # git add -A
    gap = "git ap"; # git add -p
    gb = "git br"; # git branch
    gbd = "git brd"; # git branch -d
    gbD = "git brD"; # git branch -D
    gc = "git cm"; # git commit -m
    gca = "git amend"; # git commit --amend
    gcan = "git amendn"; # git commit --amend --no-edit
    gco = "git co"; # git checkout
    gcb = "git cob"; # git checkout -b
    gsw = "git sw"; # git switch
    gswc = "git swc"; # git switch -c
    gcp = "git cp"; # git cherry-pick
    gd = "git d"; # git diff
    gds = "git ds"; # git diff --staged
    gf = "git f"; # git fetch --all --prune
    gl = "git lg"; # git log compact
    gm = "git merge"; # git merge
    gp = "git p"; # git push
    gpl = "git pl"; # git pull
    gr = "git rb"; # git rebase
    gri = "git rbi"; # git rebase -i
    grs = "git unstage"; # git restore --staged
    grss = "git unstage-all"; # git restore --staged :
    gst = "git stash"; # git stash
    gstp = "git stp"; # git stash pop
    gwt = "git worktree"; # git worktree
    gwip = "git wip"; # quick wip commit
    glazy = "git lazy"; # auto-commit summary
    gk = "k9s"; # kubernetes TUI (keep with git group for muscle memory)
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
    lta = "${base} -a --tree --level=3";
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

  allAliases = lib.foldl' (acc: aliases: acc // aliases) {} [
    shell
    bat
    eza
    colourised
    system
    systemd
    network
    nix
    gitShell
    infra
  ];
in {
  programs.bash.shellAliases = allAliases;
}
