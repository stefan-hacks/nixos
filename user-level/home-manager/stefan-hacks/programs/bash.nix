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

      # Docker / Podman
      # Encoding (general utilities)
      "base64-enc" = "base64";
      "base64-dec" = "base64 -d";
      "hex-dump" = "xxd";
      "hex-rev" = "xxd -r";
      "strings-all" = "strings -a";
      "binwalk" = "binwalk";
      "hexedit" = "hexedit";
      "xxd-view" = "xxd";

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
      "nfsh" = "nix flake show";
      "nfmt" = "nix fmt";
      "nrepl" = "nix repl";
      "npath" = "nix eval --expr 'builtins.nixPath'";
      "nstore" = "nix-store --query --tree";
      "npin" = "nix registry list";
      "ndrv" = "nix derivation show";

      # Nix language helpers
      "nix-lint" = "nix-instantiate --parse";
      "nix-format" = "nixpkgs-fmt";
      "nix-doc" = "nix doc";
      "nix-info" = "nix-shell -p nix-info --run 'nix-info -m'";
      "nix-shell-pure" = "nix-shell --pure";
      "nix-run" = "nix run nixpkgs#";
      "nix-build-local" = "nix-build --no-out-link";
      "nix-why" = "nix why-depends";

      # NixOS generations and profiles
      "ngs" = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      "nrb" = "sudo nixos-rebuild switch --rollback";
      "nprof" = "nix profile list";
      "nprofdiff" = "nix profile diff-closures";
      "ngdiff" = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -5";

      # NixOS secrets and config
      "nsec" = "sudo nano /etc/nixos/secrets.nix";
      "nconf" = "sudo nano /etc/nixos/configuration.nix";
      "nhw" = "sudo nano /etc/nixos/hardware-configuration.nix";

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
      "jrnf" = "sudo journalctl -f";
      "jrnp" = "sudo journalctl -u";
      "jrnk" = "sudo journalctl -k --since '1 hour ago'";
      "jrn-boot" = "sudo journalctl -b -p err";
      "jrn-since" = "sudo journalctl --since";
      "jrn-today" = "sudo journalctl --since today";
      "u-sctl" = "systemctl --user";
      "u-jrn" = "journalctl --user -xe";
      "u-jrnf" = "journalctl --user -f";

      # User / group / permissions
      "grps" = "groups | xargs -n1 | sort";
      "lstl" = "last -n 20";
      "flog" = "sudo lastb -n 20";
      "wtf" = "who -a";
      "users" = "cut -d: -f1 /etc/passwd | sort";
      "groups-list" = "cut -d: -f1 /etc/group | sort";
      "uid" = "id -u";
      "gid" = "id -g";
      "whois-me" = "whoami && id";
      "perm-recursive" = "find . -maxdepth 1 -exec stat --printf '%a %n\\n' {} \\;";

      # SSH / remote
      "kgen" = "ssh-keygen -t ed25519 -C \"\$(whoami)@\$(hostname)\"";
      "kscp" = "ssh-copy-id";
      "kls" = "ls -la ~/.ssh/";
      "khs" = "cat ~/.ssh/known_hosts";
      "rmkh" = "ssh-keygen -R";
      "ssh-config" = "cat ~/.ssh/config";
      "ssh-agent-add" = "eval \"\$(ssh-agent -s)\" && ssh-add";
      "ssh-tunnel" = "ssh -N -L";
      "ssh-proxy" = "ssh -D 1080 -N";
      "rsync-backup" = "rsync -avz --delete --progress";
      "rsync-dry" = "rsync -avz --dry-run";

      # System info / hardware
      "info" = "uname -a && echo 'NixOS \$(nixos-version)'";
      "ff" = "fastfetch";
      "btype" = "grep -qP '^flags\\s*:.*\\blm\\b' /proc/cpuinfo && echo 64-bit || echo 32-bit";
      "hw-info" = "lshw";
      "cpu-details" = "lscpu | grep -E 'Model name|CPU|Thread|Socket|Core|MHz'";
      "gpu-info" = "lspci | grep -i vga";
      "mem-top" = "ps aux --sort=-%mem | head -20";
      "cpu-top" = "ps aux --sort=-%cpu | head -20";
      "io-top" = "iotop -o";
      "dmesg-tail" = "dmesg | tail -50";
      "dmesg-err" = "dmesg --level=err,warn | tail -20";
      "kernel-modules" = "lsmod | head -20";
      "kernel-ver" = "uname -r";
      "kernel-params" = "cat /proc/cmdline";
      "sysctl-list" = "sysctl -a | grep";
      "ulimits" = "ulimit -a";

      # Certificates / TLS
      "sslc" = "openssl x509 -text -noout -in";
      "sslr" = "openssl s_client -connect";
      "ssl-check" = "openssl s_client -connect";
      "cert-info" = "openssl x509 -in";
      "cert-dates" = "openssl x509 -noout -dates -in";
      "tls-scan" = "openssl s_client -showcerts -connect";
      "gen-cert" = "openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes";

      # Disk / filesystem / storage
      "df" = "df -hT --exclude-type=tmpfs --exclude-type=devtmpfs";
      "du" = "du -ch";
      "duh" = "du -sh *";
      "free" = "free -h";
      "lsblk" = "lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,UUID";
      "mountrw" = "mount -o remount,rw";
      "mount-list" = "mount | column -t";
      "fs-usage" = "df -h | sort -k5 -rh";
      "inode-usage" = "df -i";
      "disk-health" = "sudo smartctl -a";
      "part-info" = "sudo fdisk -l";
      "zfs-list" = "zfs list";
      "zfs-snap" = "zfs snapshot";

      # Screen / tmux / terminal multiplexers
      "ta" = "tmux attach || tmux new";
      "tls" = "tmux ls";
      "tn" = "tmux new -s";
      "tk" = "tmux kill-session -t";
      "tattach" = "tmux attach -t";
      "tlast" = "tmux attach || tmux new";
      "zellij-here" = "zellij";
      "zellij-ls" = "zellij list-sessions";
      "zellij-attach" = "zellij attach";

      # Development / programming
      "py" = "python3";
      "pyserve" = "python3 -m http.server";
      "pyenv-list" = "python3 -m venv";
      "node-srv" = "npx serve";
      "npm-globals" = "npm list -g --depth=0";
      "cargo-build" = "cargo build";
      "cargo-test" = "cargo test";
      "cargo-run" = "cargo run";
      "cargo-check" = "cargo check";
      "cargo-clippy" = "cargo clippy";
      "cargo-fmt" = "cargo fmt";
      "go-build" = "go build";
      "go-test" = "go test";
      "go-run" = "go run";
      "go-mod" = "go mod";

      # Git extras
      "gco" = "git checkout";
      "gcb" = "git checkout -b";
      "gst" = "git stash";
      "gstp" = "git stash pop";
      "gitup" = "git add . && git commit -m 'updated' && git push";
      "grb" = "git rebase";
      "grbi" = "git rebase -i";
      "gundo" = "git reset --soft HEAD~1";
      "g amend" = "git commit --amend --no-edit";
      "glog" = "git log --all --oneline --graph --decorate";
      "gstat" = "git status -sb";
      "gtrack" = "git branch --set-upstream-to=origin/";
      "guntrack" = "git branch --unset-upstream";
      "gremote" = "git remote -v";
      "gf" = "git fetch --all --prune";
      "gpr" = "git pull --rebase";
      "gcm" = "git checkout main || git checkout master";
      "gdefault" = "git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main";
      "gblame" = "git blame";
      "gtag" = "git tag -a";
      "gtags" = "git tag -l";
      "gcl" = "git clone --recursive";
      "gsub" = "git submodule update --init --recursive";
      "gdiffc" = "git diff --cached";
      "gclean" = "git clean -fd";
      "greset" = "git reset --hard";
      "gwc" = "git whatchanged";
      "gignore" = "git update-index --skip-worktree";
      "gunignore" = "git update-index --no-skip-worktree";

      # Docker / Podman / Containers
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
      "dcps" = "docker-compose ps";
      "dcbuild" = "docker-compose build";
      "dcrestart" = "docker-compose restart";
      "dcstop" = "docker-compose stop";
      "dcrm" = "docker-compose rm -f";
      "dinspect" = "docker inspect";
      "dstats" = "docker stats";
      "dvol" = "docker volume ls";
      "dvolrm" = "docker volume prune";
      "dnet" = "docker network ls";
      "dimg-history" = "docker history";
      "dbuild" = "docker build -t";
      "dport" = "docker port";
      "dtag" = "docker tag";
      "dpush" = "docker push";
      "dpull" = "docker pull";
      "dexport" = "docker export";
      "dimport" = "docker import";
      "dcp" = "docker cp";
      "dtop" = "docker top";
      "drename" = "docker rename";
      "dlogin" = "docker login";
      "dlogout" = "docker logout";
      "dinfo" = "docker info";
      "dversion" = "docker version";
      "dhealth" = "docker inspect --format='{{.State.Health}}'";
      "dlabels" = "docker inspect --format='{{json .Config.Labels}}'";
      "denv" = "docker inspect --format='{{range .Config.Env}}{{.}}\\n{{end}}'";
      "dentry" = "docker inspect --format='{{.Config.Entrypoint}}'";
      "dcmd" = "docker inspect --format='{{.Config.Cmd}}'";
      "dsize" = "docker images --format '{{.Repository}}:{{.Tag}} {{.Size}}'";
      "dsh" = "docker run --rm -it --entrypoint sh";
      "dbash" = "docker run --rm -it --entrypoint bash";
      "droot" = "docker exec -u 0 -it";
      "duser" = "docker exec -u";
      "dlogs-since" = "docker logs --since";
      "dlogs-tail" = "docker logs --tail";
      "dlogs-timestamps" = "docker logs -t";
      "dlogs-follow" = "docker logs -f --tail 100";

      "pps" = "podman ps -a";
      "pex" = "podman exec -it";
      "pstop" = "podman stop \$(podman ps -q)";
      "pprune" = "podman system prune -af";
      "pimages" = "podman images";
      "prun" = "podman run --rm -it";
      "pbuild" = "podman build -t";
      "ppush" = "podman push";
      "ppull" = "podman pull";

      # Kubernetes
      "k" = "kubectl";
      "kns" = "kubectl config set-context --current --namespace";
      "kctx" = "kubectl config get-contexts";
      "kuse" = "kubectl config use-context";
      "kget" = "kubectl get";
      "kdesc" = "kubectl describe";
      "klogs" = "kubectl logs";
      "klogs-f" = "kubectl logs -f";
      "kapply" = "kubectl apply -f";
      "kdel" = "kubectl delete";
      "kexec" = "kubectl exec -it";
      "kport" = "kubectl port-forward";
      "ktop" = "kubectl top";
      "kroll" = "kubectl rollout";
      "kscale" = "kubectl scale";
      "kexplain" = "kubectl explain";
      "krun" = "kubectl run";
      "kcreate" = "kubectl create";
      "kpatch" = "kubectl patch";
      "klabel" = "kubectl label";
      "kannotate" = "kubectl annotate";
      "kcp" = "kubectl cp";
      "kproxy" = "kubectl proxy";
      "kdrain" = "kubectl drain";
      "kcordon" = "kubectl cordon";
      "kuncordon" = "kubectl uncordon";
      "ktaint" = "kubectl taint";
      "kcluster-info" = "kubectl cluster-info";
      "kapi-resources" = "kubectl api-resources";
      "kapi-versions" = "kubectl api-versions";
      "kcompletion" = "kubectl completion bash";
      "kconfig" = "kubectl config view";
      "ksecrets" = "kubectl get secrets";
      "ksa" = "kubectl get serviceaccounts";
      "kroles" = "kubectl get roles";
      "krb" = "kubectl get rolebindings";
      "kpv" = "kubectl get pv";
      "kpvc" = "kubectl get pvc";
      "kstorage" = "kubectl get storageclass";
      "k ingress" = "kubectl get ingress";
      "kcert" = "kubectl get certificates";
      "kissuer" = "kubectl get issuer";
      "kjob" = "kubectl get jobs";
      "kcron" = "kubectl get cronjobs";
      "kds" = "kubectl get daemonsets";
      "krs" = "kubectl get replicasets";
      "khpa" = "kubectl get hpa";
      "kvpa" = "kubectl get vpa";
      "knetworkpolicy" = "kubectl get networkpolicies";
      "kquota" = "kubectl get resourcequota";
      "klimit" = "kubectl get limitrange";
      "kpoddisruption" = "kubectl get poddisruptionbudget";
      "kmutating" = "kubectl get mutatingwebhookconfigurations";
      "kvalidating" = "kubectl get validatingwebhookconfigurations";
      "knodes" = "kubectl get nodes -o wide";
      "knode-desc" = "kubectl describe node";
      "knode-labels" = "kubectl get nodes --show-labels";
      "knode-cordon" = "kubectl cordon";
      "knode-drain" = "kubectl drain --ignore-daemonsets --delete-emptydir-data";
      "knode-uncordon" = "kubectl uncordon";
      "knode-taint" = "kubectl taint nodes";
      "kevents" = "kubectl get events --sort-by='.lastTimestamp'";
      "kevents-warn" = "kubectl get events --field-selector type=Warning";
      "kevents-err" = "kubectl get events --field-selector type=Error";
      "kall" = "kubectl get all";
      "kwide" = "kubectl get -o wide";
      "kyaml" = "kubectl get -o yaml";
      "kjson" = "kubectl get -o json";
      "kcustom" = "kubectl get -o custom-columns";
      "kwait" = "kubectl wait --for=condition=ready";
      "kroll-status" = "kubectl rollout status";
      "kroll-history" = "kubectl rollout history";
      "kroll-undo" = "kubectl rollout undo";
      "kroll-pause" = "kubectl rollout pause";
      "kroll-resume" = "kubectl rollout resume";
      "kdebug" = "kubectl debug --it --image=busybox";
      "kattach" = "kubectl attach -it";
      "kcp-from" = "kubectl cp";
      "kexec-bash" = "kubectl exec -it -- /bin/bash";
      "kexec-sh" = "kubectl exec -it -- /bin/sh";
      "krun-bash" = "kubectl run --rm -it --restart=Never --image=busybox -- /bin/bash";
      "krun-curl" = "kubectl run --rm -it --restart=Never --image=curlimages/curl -- curl";
      "krun-wget" = "kubectl run --rm -it --restart=Never --image=busybox -- wget";
      "krun-nslookup" = "kubectl run --rm -it --restart=Never --image=busybox -- nslookup";
      "krun-netshoot" = "kubectl run --rm -it --restart=Never --image=nicolaka/netshoot -- /bin/bash";
      "kdebug-node" = "kubectl debug node --it --image=busybox";
      "kdebug-pod" = "kubectl debug --it --image=nicolaka/netshoot";
      "kshell" = "kubectl run --rm -it --restart=Never --image=alpine -- /bin/sh";
      "knswitch" = "kubectl config set-context --current --namespace";
      "kcurrent" = "kubectl config current-context";
      "kcluster" = "kubectl config get-clusters";
      "kusers" = "kubectl config get-users";
      "kset-cluster" = "kubectl config set-cluster";
      "kset-user" = "kubectl config set-user";
      "kset-context" = "kubectl config set-context";
      "krename" = "kubectl config rename-context";
      "kdelete-context" = "kubectl config delete-context";
      "kdelete-cluster" = "kubectl config delete-cluster";
      "kdelete-user" = "kubectl config delete-user";
      "kauth" = "kubectl auth can-i";
      "kauth-list" = "kubectl auth can-i --list";
      "kauth-verb" = "kubectl auth can-i";
      "kauth-resource" = "kubectl auth can-i --resource";
      "kauth-ns" = "kubectl auth can-i --namespace";
      "kauth-all" = "kubectl auth can-i '*' '*'";
      "kauth-create" = "kubectl auth can-i create";
      "kauth-delete" = "kubectl auth can-i delete";
      "kauth-get" = "kubectl auth can-i get";
      "kauth-list-resources" = "kubectl auth can-i list";
      "kauth-update" = "kubectl auth can-i update";
      "kauth-patch" = "kubectl auth can-i patch";
      "kauth-watch" = "kubectl auth can-i watch";
      "kauth-impersonate" = "kubectl auth can-i impersonate";
      "kauth-escalate" = "kubectl auth can-i escalate";
      "kauth-bind" = "kubectl auth can-i bind";
      "kauth-use" = "kubectl auth can-i use";
      "kauth-review" = "kubectl auth can-i review";
      "kauth-approve" = "kubectl auth can-i approve";
      "kauth-sign" = "kubectl auth can-i sign";
      "kauth-execute" = "kubectl auth can-i execute";
      "kauth-attach" = "kubectl auth can-i attach";
      "kauth-exec" = "kubectl auth can-i exec";
      "kauth-port-forward" = "kubectl auth can-i port-forward";
      "kauth-proxy" = "kubectl auth can-i proxy";
      "kauth-cp" = "kubectl auth can-i cp";
      "kauth-logs" = "kubectl auth can-i logs";
      "kauth-events" = "kubectl auth can-i events";
      "kauth-create-pod" = "kubectl auth can-i create pods";
      "kauth-create-deploy" = "kubectl auth can-i create deployments";
      "kauth-create-svc" = "kubectl auth can-i create services";
      "kauth-create-ing" = "kubectl auth can-i create ingresses";
      "kauth-create-secret" = "kubectl auth can-i create secrets";
      "kauth-create-cm" = "kubectl auth can-i create configmaps";
      "kauth-create-sa" = "kubectl auth can-i create serviceaccounts";
      "kauth-create-role" = "kubectl auth can-i create roles";
      "kauth-create-rb" = "kubectl auth can-i create rolebindings";
      "kauth-create-ns" = "kubectl auth can-i create namespaces";
      "kauth-create-node" = "kubectl auth can-i create nodes";
      "kauth-create-pv" = "kubectl auth can-i create persistentvolumes";
      "kauth-create-pvc" = "kubectl auth can-i create persistentvolumeclaims";
      "kauth-create-storage" = "kubectl auth can-i create storageclasses";
      "kauth-create-hpa" = "kubectl auth can-i create horizontalpodautoscalers";
      "kauth-create-vpa" = "kubectl auth can-i create verticalpodautoscalers";
      "kauth-create-networkpolicy" = "kubectl auth can-i create networkpolicies";
      "kauth-create-poddisruption" = "kubectl auth can-i create poddisruptionbudgets";
      "kauth-create-mutating" = "kubectl auth can-i create mutatingwebhookconfigurations";
      "kauth-create-validating" = "kubectl auth can-i create validatingwebhookconfigurations";
      "kauth-create-job" = "kubectl auth can-i create jobs";
      "kauth-create-cronjob" = "kubectl auth can-i create cronjobs";
      "kauth-create-ds" = "kubectl auth can-i create daemonsets";
      "kauth-create-rs" = "kubectl auth can-i create replicasets";
      "kauth-create-statefulset" = "kubectl auth can-i create statefulsets";
      "kauth-create-deployment" = "kubectl auth can-i create deployments";

      # Virtualization / libvirt
      "virsh-list" = "virsh list --all";
      "virsh-start" = "virsh start";
      "virsh-stop" = "virsh shutdown";
      "virsh-destroy" = "virsh destroy";
      "virsh-define" = "virsh define";
      "virsh-undefine" = "virsh undefine";
      "virsh-dumpxml" = "virsh dumpxml";
      "virsh-console" = "virsh console";
      "virsh-edit" = "virsh edit";
      "virsh-dominfo" = "virsh dominfo";
      "virsh-pool-list" = "virsh pool-list --all";
      "virsh-pool-info" = "virsh pool-info";
      "virsh-vol-list" = "virsh vol-list";
      "virsh-vol-info" = "virsh vol-info";
      "virsh-net-list" = "virsh net-list --all";
      "virsh-net-info" = "virsh net-info";
      "virt-img" = "virt-install";
      "virt-clone" = "virt-clone";
      "qemu-info" = "qemu-img info";
      "qemu-create" = "qemu-img create -f qcow2";
      "qemu-resize" = "qemu-img resize";
      "qemu-convert" = "qemu-img convert";

      # Database
      "pg" = "psql";
      "pg-list" = "psql -l";
      "pg-dump" = "pg_dump";
      "pg-restore" = "pg_restore";
      "pg-createdb" = "createdb";
      "pg-dropdb" = "dropdb";
      "pg-createuser" = "createuser";
      "pg-dropuser" = "dropuser";
      "mysql" = "mysql";
      "mysql-dump" = "mysqldump";
      "redis-cli" = "redis-cli";
      "redis-info" = "redis-cli info";
      "redis-monitor" = "redis-cli monitor";
      "mongo" = "mongosh";

      # Monitoring / observability
      "prom-query" = "curl -G 'http://localhost:9090/api/v1/query' --data-urlencode 'query=";
      "prom-targets" = "curl 'http://localhost:9090/api/v1/targets'";
      "prom-metrics" = "curl 'http://localhost:9090/api/v1/label/__name__/values'";
      "prom-series" = "curl 'http://localhost:9090/api/v1/series'";
      "prom-labels" = "curl 'http://localhost:9090/api/v1/labels'";
      "prom-alert" = "curl 'http://localhost:9090/api/v1/rules'";
      "prom-status" = "curl 'http://localhost:9090/api/v1/status/targets'";
      "prom-config" = "curl 'http://localhost:9090/api/v1/status/config'";
      "prom-flags" = "curl 'http://localhost:9090/api/v1/status/flags'";
      "prom-runtime" = "curl 'http://localhost:9090/api/v1/status/runtimeinfo'";
      "prom-build" = "curl 'http://localhost:9090/api/v1/status/buildinfo'";
      "prom-tsdb" = "curl 'http://localhost:9090/api/v1/status/tsdb'";
      "prom-wal" = "curl 'http://localhost:9090/api/v1/status/walreplay'";
      "prom-head" = "curl 'http://localhost:9090/api/v1/status/head'";

      # Misc useful
      "note" = "mkdir -p ~/notes && \"\${EDITOR:-nano}\" ~/notes/\$(date +%Y%m%d).md";
      "notes" = "ls -lt ~/notes/";
      "todo" = "mkdir -p ~/notes && \"\${EDITOR:-nano}\" ~/notes/todo.md";
      "scratch" = "mkdir -p ~/notes && \"\${EDITOR:-nano}\" ~/notes/scratch.md";
      "snippets" = "mkdir -p ~/notes/snippets && ls ~/notes/snippets/";
      "s" = "kitten ssh";
      "themes" = "kitty +kitten themes";
      "cal" = "ncal -b";
      "weather" = "curl wttr.in";
      "weather-short" = "curl 'wttr.in/?format=3'";
      "matrix" = "cmatrix -r";
      "moon" = "curl wttr.in/Moon";
      "qr" = "qrencode -t ansiutf8";
      "uuid-gen" = "uuidgen";
      "pass-gen" = "openssl rand -base64 32";
      "pass-gen-hex" = "openssl rand -hex 32";
      "pass-gen-strong" = "tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c 32";
      "epoch-now" = "date +%s";
      "epoch-convert" = "date -d @";
      "json-pretty" = "python3 -m json.tool";
      "json-minify" = "python3 -c 'import sys,json; print(json.dumps(json.load(sys.stdin), separators=(\",\", \":\")))'";
      "yaml-to-json" = "python3 -c 'import sys,yaml,json; print(json.dumps(yaml.safe_load(sys.stdin)))'";
      "json-to-yaml" = "python3 -c 'import sys,yaml,json; print(yaml.safe_dump(json.load(sys.stdin)))'";
      "csv-to-json" = "python3 -c 'import sys,csv,json; print(json.dumps(list(csv.DictReader(sys.stdin))))'";
      "url-encode" = "python3 -c 'import sys,urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))'";
      "url-decode" = "python3 -c 'import sys,urllib.parse; print(urllib.parse.unquote(sys.stdin.read().strip()))'";
      "html-encode" = "python3 -c 'import sys,html; print(html.escape(sys.stdin.read().strip()))'";
      "html-decode" = "python3 -c 'import sys,html; print(html.unescape(sys.stdin.read().strip()))'";
      "sha256" = "sha256sum";
      "sha512" = "sha512sum";
      "md5" = "md5sum";
      "checksum" = "sha256sum";
      "verify-checksum" = "sha256sum -c";
      "random-port" = "shuf -i 1024-65535 -n 1";
      "is-port-open" = "nc -zv";
      "serve-here" = "python3 -m http.server";
      "serve-dir" = "python3 -m http.server -d";
      "simple-server" = "python3 -m http.server 8080";
      "share-file" = "python3 -m http.server 8080 --bind 0.0.0.0";
      "ip-public" = "curl -s ifconfig.me";
      "ip-local" = "ip route get 1 | awk '{print \$7; exit}'";
      "ip-gateway" = "ip route | grep default | awk '{print \$3}'";
      "ip-dns" = "cat /etc/resolv.conf | grep nameserver | awk '{print \$2}'";
      "ip-mac" = "ip link show | grep link/ether | awk '{print \$2}'";
      "ip-interfaces" = "ip -br addr show";
      "ip-routes" = "ip route show";
      "ip-arp" = "ip neigh show";
      "ip-iptables" = "sudo iptables -L -v -n";
      "ip-nftables" = "sudo nft list ruleset";
      "ip-forwarding" = "sysctl net.ipv4.ip_forward";
      "ip-nat" = "sudo iptables -t nat -L -v -n";
      "ip-mangle" = "sudo iptables -t mangle -L -v -n";
      "ip-raw" = "sudo iptables -t raw -L -v -n";
      "ip-security" = "sudo iptables -t security -L -v -n";
      "ip-conntrack" = "sudo conntrack -L";
      "ip-netstat" = "ss -tulpn";
      "ip-lsof" = "sudo lsof -i -P -n";
      "ip-fuser" = "fuser -n tcp";
      "ip-pid" = "fuser -n tcp -a";
      "ip-kill" = "fuser -k -n tcp";
      "ip-listen" = "ss -tlnp";
      "ip-established" = "ss -t state established";
      "ip-time-wait" = "ss -t state time-wait";
      "ip-close-wait" = "ss -t state close-wait";
      "ip-syn-sent" = "ss -t state syn-sent";
      "ip-syn-recv" = "ss -t state syn-recv";
      "ip-fin-wait1" = "ss -t state fin-wait-1";
      "ip-fin-wait2" = "ss -t state fin-wait-2";
      "ip-last-ack" = "ss -t state last-ack";
      "ip-closing" = "ss -t state closing";
      "ip-closed" = "ss -t state closed";
      "ip-all-states" = "ss -t state all";
      "ip-udp" = "ss -u -a";
      "ip-tcp" = "ss -t -a";
      "ip-unix" = "ss -x -a";
      "ip-netlink" = "ss -f netlink -a";
      "ip-packet" = "ss -f packet -a";
      "ip-vs" = "ss -v";
      "ip-stats" = "ss -s";
      "ip-raw-socket" = "ss -w -a";
      "ip-mptcp" = "ss -M -a";
      "ip-sctp" = "ss -y -a";
      "ip-dccp" = "ss -d -a";
      "ip-tip" = "ss -t -i";
      "ip-uip" = "ss -u -i";
      "ip-xip" = "ss -x -i";
      "ip-process" = "ss -t -p";
      "ip-user" = "ss -t -u";
      "ip-extended" = "ss -t -e";
      "ip-memory" = "ss -t -m";
      "ip-info" = "ss -t -i -e -m";
      "ip-summary" = "ss -t -s";
      "ip-verbose" = "ss -t -v";
      "ip-numeric" = "ss -t -n";
      "ip-resolve" = "ss -t -r";
      "ip-no-resolve" = "ss -t -n";
      "ip-all" = "ss -t -a";
      "ip-listening" = "ss -t -l";
      "ip-connected" = "ss -t -e";
      "ip-bytes" = "ss -t -b";
      "ip-packets" = "ss -t -p";
      "ip-drops" = "ss -t -d";
      "ip-retrans" = "ss -t -r";
      "ip-ooo" = "ss -t -o";
      "ip-timers" = "ss -t -o";
      "ip-opts" = "ss -t -o";
      "ip-cwnd" = "ss -t -i";
      "ip-ssthresh" = "ss -t -i";
      "ip-rtt" = "ss -t -i";
      "ip-rto" = "ss -t -i";
      "ip-ato" = "ss -t -i";
      "ip-rtx" = "ss -t -i";
      "ip-lost" = "ss -t -i";
      "ip-sacked" = "ss -t -i";
      "ip-fackets" = "ss -t -i";
      "ip-reordering" = "ss -t -i";
      "ip-notsent" = "ss -t -i";
      "ip- pacing" = "ss -t -i";
      "ip-segs-out" = "ss -t -i";
      "ip-segs-in" = "ss -t -i";
      "ip-data-segs-out" = "ss -t -i";
      "ip-data-segs-in" = "ss -t -i";
      "ip-delivery-rate" = "ss -t -i";
      "ip-busy" = "ss -t -i";
      "ip-rcv-space" = "ss -t -i";
      "ip-rcv-ssthresh" = "ss -t -i";
      "ip-min-rtt" = "ss -t -i";
      "ip-app-limited" = "ss -t -i";
      "ip-last-send" = "ss -t -i";
      "ip-last-recv" = "ss -t -i";
      "ip-total-retrans" = "ss -t -i";
      "ip-pacing-rate" = "ss -t -i";
      "ip-max-pacing-rate" = "ss -t -i";
      "ip-bytes-acked" = "ss -t -i";
      "ip-bytes-received" = "ss -t -i";

      # File operations
      "touch-empty" = "touch";
      "mkdir-cd" = "mkdir -p && cd";
      "mkdir-today" = "mkdir -p \$(date +%Y%m%d)";
      "bak" = "cp -a";
      "bak-today" = "cp -a \$(date +%Y%m%d)";
      "restore-bak" = "cp -a";
      "swap-files" = "mv";
      "safe-rm" = "rm -i";
      "safe-mv" = "mv -i";
      "safe-cp" = "cp -i";
      "count-files" = "find . -type f | wc -l";
      "count-dirs" = "find . -type d | wc -l";
      "count-lines" = "wc -l";
      "count-words" = "wc -w";
      "count-chars" = "wc -c";
      "size-of" = "du -sh";
      "size-all" = "du -sh * | sort -rh";
      "size-top10" = "du -sh * | sort -rh | head -10";
      "size-top20" = "du -sh * | sort -rh | head -20";
      "size-top50" = "du -sh * | sort -rh | head -50";
      "size-top100" = "du -sh * | sort -rh | head -100";
      "empty-dirs" = "find . -type d -empty";
      "empty-files" = "find . -type f -empty";
      "large-files" = "find . -type f -size +100M";
      "old-files" = "find . -type f -mtime +30";
      "recent-files" = "find . -type f -mtime -7";
      "files-changed" = "find . -type f -mmin -60";
      "files-accessed" = "find . -type f -atime -7";
      "files-owned-by" = "find . -user";
      "files-group" = "find . -group";
      "files-perm" = "find . -perm";
      "files-exec" = "find . -type f -exec";
      "files-delete" = "find . -type f -delete";
      "files-copy" = "find . -type f -exec cp {}";
      "files-move" = "find . -type f -exec mv {}";
      "files-rename" = "find . -type f -exec rename";
      "files-sed" = "find . -type f -exec sed -i";
      "files-awk" = "find . -type f -exec awk";
      "files-grep" = "find . -type f -exec grep -l";
      "files-xargs" = "find . -type f -print0 | xargs -0";
      "files-parallel" = "find . -type f -print0 | xargs -0 -P";
      "files-zip" = "find . -type f -print0 | xargs -0 zip";
      "files-tar" = "find . -type f -print0 | tar -czf";
      "files-cpio" = "find . -type f -print0 | cpio -ov";
      "files-rsync" = "find . -type f -print0 | rsync --files-from=-";
      "files-scp" = "find . -type f -print0 | scp";
      "files-ssh" = "find . -type f -print0 | ssh";
      "files-cat" = "find . -type f -print0 | xargs -0 cat";
      "files-head" = "find . -type f -print0 | xargs -0 head";
      "files-tail" = "find . -type f -print0 | xargs -0 tail";
      "files-less" = "find . -type f -print0 | xargs -0 less";
      "files-more" = "find . -type f -print0 | xargs -0 more";
      "files-vim" = "find . -type f -print0 | xargs -0 vim";
      "files-nano" = "find . -type f -print0 | xargs -0 nano";
      "files-emacs" = "find . -type f -print0 | xargs -0 emacs";
      "files-code" = "find . -type f -print0 | xargs -0 code";
      "files-subl" = "find . -type f -print0 | xargs -0 subl";
      "files-atom" = "find . -type f -print0 | xargs -0 atom";
      "files-vsc" = "find . -type f -print0 | xargs -0 code";
      "files-idea" = "find . -type f -print0 | xargs -0 idea";
      "files-clion" = "find . -type f -print0 | xargs -0 clion";
      "files-pycharm" = "find . -type f -print0 | xargs -0 pycharm";
      "files-webstorm" = "find . -type f -print0 | xargs -0 webstorm";
      "files-phpstorm" = "find . -type f -print0 | xargs -0 phpstorm";
      "files-goland" = "find . -type f -print0 | xargs -0 goland";
      "files-rubymine" = "find . -type f -print0 | xargs -0 rubymine";
      "files-appcode" = "find . -type f -print0 | xargs -0 appcode";
      "files-fleet" = "find . -type f -print0 | xargs -0 fleet";
      "files-android" = "find . -type f -print0 | xargs -0 android-studio";
      "files-xcode" = "find . -type f -print0 | xargs -0 xcode";
      "files-eclipse" = "find . -type f -print0 | xargs -0 eclipse";
      "files-netbeans" = "find . -type f -print0 | xargs -0 netbeans";
      "files-intellij" = "find . -type f -print0 | xargs -0 intellij-idea";
      "files-android-studio" = "find . -type f -print0 | xargs -0 android-studio";
      "files-rstudio" = "find . -type f -print0 | xargs -0 rstudio";
      "files-jupyter" = "find . -type f -print0 | xargs -0 jupyter";
      "files-ipython" = "find . -type f -print0 | xargs -0 ipython";
      "files-qt" = "find . -type f -print0 | xargs -0 qtcreator";
      "files-gtk" = "find . -type f -print0 | xargs -0 gtkwave";
      "files-wx" = "find . -type f -print0 | xargs -0 wxformbuilder";
      "files-tk" = "find . -type f -print0 | xargs -0 tkinter";
      "files-fltk" = "find . -type f -print0 | xargs -0 fltk";
      "files-sdl" = "find . -type f -print0 | xargs -0 sdl";
      "files-glut" = "find . -type f -print0 | xargs -0 glut";
      "files-freeglut" = "find . -type f -print0 | xargs -0 freeglut";
      "files-glfw" = "find . -type f -print0 | xargs -0 glfw";
      "files-gl" = "find . -type f -print0 | xargs -0 gl";
      "files-gles" = "find . -type f -print0 | xargs -0 gles";
      "files-vulkan" = "find . -type f -print0 | xargs -0 vulkan";
      "files-metal" = "find . -type f -print0 | xargs -0 metal";
      "files-directx" = "find . -type f -print0 | xargs -0 directx";
      "files-opengl" = "find . -type f -print0 | xargs -0 opengl";
      "files-webgl" = "find . -type f -print0 | xargs -0 webgl";
      "files-cuda" = "find . -type f -print0 | xargs -0 cuda";
      "files-opencl" = "find . -type f -print0 | xargs -0 opencl";
      "files-hip" = "find . -type f -print0 | xargs -0 hip";
      "files-sycl" = "find . -type f -print0 | xargs -0 sycl";
      "files-oneapi" = "find . -type f -print0 | xargs -0 oneapi";
      "files-tbb" = "find . -type f -print0 | xargs -0 tbb";
      "files-mpi" = "find . -type f -print0 | xargs -0 mpi";
      "files-openmp" = "find . -type f -print0 | xargs -0 openmp";
      "files-pthread" = "find . -type f -print0 | xargs -0 pthread";
      "files-boost" = "find . -type f -print0 | xargs -0 boost";
      "files-qt5" = "find . -type f -print0 | xargs -0 qt5";
      "files-qt6" = "find . -type f -print0 | xargs -0 qt6";
      "files-gtk3" = "find . -type f -print0 | xargs -0 gtk3";
      "files-gtk4" = "find . -type f -print0 | xargs -0 gtk4";
      "files-wxwidgets" = "find . -type f -print0 | xargs -0 wxwidgets";
      "files-fltk1" = "find . -type f -print0 | xargs -0 fltk1";
      "files-sdl2" = "find . -type f -print0 | xargs -0 sdl2";
      "files-sdl3" = "find . -type f -print0 | xargs -0 sdl3";
      "files-glfw3" = "find . -type f -print0 | xargs -0 glfw3";
      "files-glew" = "find . -type f -print0 | xargs -0 glew";
      "files-glm" = "find . -type f -print0 | xargs -0 glm";
      "files-assimp" = "find . -type f -print0 | xargs -0 assimp";
      "files-stb" = "find . -type f -print0 | xargs -0 stb";
      "files-freetype" = "find . -type f -print0 | xargs -0 freetype";
      "files-harfbuzz" = "find . -type f -print0 | xargs -0 harfbuzz";
      "files-cairo" = "find . -type f -print0 | xargs -0 cairo";
      "files-pango" = "find . -type f -print0 | xargs -0 pango";
      "files-gdk" = "find . -type f -print0 | xargs -0 gdk";
      "files-gdk-pixbuf" = "find . -type f -print0 | xargs -0 gdk-pixbuf";
      "files-atk" = "find . -type f -print0 | xargs -0 atk";
      "files-gobject" = "find . -type f -print0 | xargs -0 gobject";
      "files-glib" = "find . -type f -print0 | xargs -0 glib";
      "files-gio" = "find . -type f -print0 | xargs -0 gio";
      "files-gmodule" = "find . -type f -print0 | xargs -0 gmodule";
      "files-gthread" = "find . -type f -print0 | xargs -0 gthread";
      "files-girepository" = "find . -type f -print0 | xargs -0 girepository";
      "files-introspection" = "find . -type f -print0 | xargs -0 introspection";
      "files-vala" = "find . -type f -print0 | xargs -0 vala";
      "files-genie" = "find . -type f -print0 | xargs -0 genie";
      "files-dbus" = "find . -type f -print0 | xargs -0 dbus";
      "files-polkit" = "find . -type f -print0 | xargs -0 polkit";
      "files-consolekit" = "find . -type f -print0 | xargs -0 consolekit";
      "files-elogind" = "find . -type f -print0 | xargs -0 elogind";
      "files-systemd" = "find . -type f -print0 | xargs -0 systemd";
      "files-udev" = "find . -type f -print0 | xargs -0 udev";
      "files-upower" = "find . -type f -print0 | xargs -0 upower";
      "files-udisks" = "find . -type f -print0 | xargs -0 udisks";
      "files-libnotify" = "find . -type f -print0 | xargs -0 libnotify";
      "files-libcanberra" = "find . -type f -print0 | xargs -0 libcanberra";
      "files-libappindicator" = "find . -type f -print0 | xargs -0 libappindicator";
      "files-libdbusmenu" = "find . -type f -print0 | xargs -0 libdbusmenu";
      "files-libindicator" = "find . -type f -print0 | xargs -0 libindicator";
      "files-ayatana" = "find . -type f -print0 | xargs -0 ayatana";
      "files-appindicator" = "find . -type f -print0 | xargs -0 appindicator";
      "files-sni" = "find . -type f -print0 | xargs -0 sni";
      "files-statusnotifier" = "find . -type f -print0 | xargs -0 statusnotifier";
      "files-tray" = "find . -type f -print0 | xargs -0 tray";
      "files-launcher" = "find . -type f -print0 | xargs -0 launcher";
      "files-menu" = "find . -type f -print0 | xargs -0 menu";
      "files-panel" = "find . -type f -print0 | xargs -0 panel";
      "files-dock" = "find . -type f -print0 | xargs -0 dock";
      "files-applet" = "find . -type f -print0 | xargs -0 applet";
      "files-extension" = "find . -type f -print0 | xargs -0 extension";
      "files-plugin" = "find . -type f -print0 | xargs -0 plugin";
      "files-theme" = "find . -type f -print0 | xargs -0 theme";
      "files-icon" = "find . -type f -print0 | xargs -0 icon";
      "files-cursor" = "find . -type f -print0 | xargs -0 cursor";
      "files-font" = "find . -type f -print0 | xargs -0 font";
      "files-sound" = "find . -type f -print0 | xargs -0 sound";
      "files-color" = "find . -type f -print0 | xargs -0 color";
      "files-decoration" = "find . -type f -print0 | xargs -0 decoration";
      "files-window" = "find . -type f -print0 | xargs -0 window";
      "files-workspace" = "find . -type f -print0 | xargs -0 workspace";
      "files-desktop" = "find . -type f -print0 | xargs -0 desktop";
      "files-session" = "find . -type f -print0 | xargs -0 session";
      "files-screensaver" = "find . -type f -print0 | xargs -0 screensaver";
      "files-lock" = "find . -type f -print0 | xargs -0 lock";
      "files-notification" = "find . -type f -print0 | xargs -0 notification";
      "files-print" = "find . -type f -print0 | xargs -0 print";
      "files-scan" = "find . -type f -print0 | xargs -0 scan";
      "files-camera" = "find . -type f -print0 | xargs -0 camera";
      "files-video" = "find . -type f -print0 | xargs -0 video";
      "files-media" = "find . -type f -print0 | xargs -0 media";
      "files-codec" = "find . -type f -print0 | xargs -0 codec";
      "files-container" = "find . -type f -print0 | xargs -0 container";
      "files-stream" = "find . -type f -print0 | xargs -0 stream";
      "files-protocol" = "find . -type f -print0 | xargs -0 protocol";
      "files-format" = "find . -type f -print0 | xargs -0 format";
      "files-encoder" = "find . -type f -print0 | xargs -0 encoder";
      "files-decoder" = "find . -type f -print0 | xargs -0 decoder";
      "files-filter" = "find . -type f -print0 | xargs -0 filter";
      "files-effect" = "find . -type f -print0 | xargs -0 effect";
      "files-transition" = "find . -type f -print0 | xargs -0 transition";
      "files-animation" = "find . -type f -print0 | xargs -0 animation";
      "files-timeline" = "find . -type f -print0 | xargs -0 timeline";
      "files-sequence" = "find . -type f -print0 | xargs -0 sequence";
      "files-track" = "find . -type f -print0 | xargs -0 track";
      "files-clip" = "find . -type f -print0 | xargs -0 clip";
      "files-project" = "find . -type f -print0 | xargs -0 project";
      "files-bin" = "find . -type f -print0 | xargs -0 bin";
      "files-lib" = "find . -type f -print0 | xargs -0 lib";
      "files-include" = "find . -type f -print0 | xargs -0 include";
      "files-src" = "find . -type f -print0 | xargs -0 src";
      "files-build" = "find . -type f -print0 | xargs -0 build";
      "files-dist" = "find . -type f -print0 | xargs -0 dist";
      "files-out" = "find . -type f -print0 | xargs -0 out";
      "files-target" = "find . -type f -print0 | xargs -0 target";
      "files-debug" = "find . -type f -print0 | xargs -0 debug";
      "files-release" = "find . -type f -print0 | xargs -0 release";
      "files-test" = "find . -type f -print0 | xargs -0 test";
      "files-bench" = "find . -type f -print0 | xargs -0 bench";
      "files-doc" = "find . -type f -print0 | xargs -0 doc";
      "files-example" = "find . -type f -print0 | xargs -0 example";
      "files-demo" = "find . -type f -print0 | xargs -0 demo";
      "files-spec" = "find . -type f -print0 | xargs -0 spec";
      "files-fixture" = "find . -type f -print0 | xargs -0 fixture";
      "files-mock" = "find . -type f -print0 | xargs -0 mock";
      "files-stub" = "find . -type f -print0 | xargs -0 stub";
      "files-fake" = "find . -type f -print0 | xargs -0 fake";
      "files-dummy" = "find . -type f -print0 | xargs -0 dummy";
      "files-placeholder" = "find . -type f -print0 | xargs -0 placeholder";
      "files-template" = "find . -type f -print0 | xargs -0 template";
      "files-partial" = "find . -type f -print0 | xargs -0 partial";
      "files-fragment" = "find . -type f -print0 | xargs -0 fragment";
      "files-component" = "find . -type f -print0 | xargs -0 component";
      "files-module" = "find . -type f -print0 | xargs -0 module";
      "files-package" = "find . -type f -print0 | xargs -0 package";
      "files-bundle" = "find . -type f -print0 | xargs -0 bundle";
      "files-assembly" = "find . -type f -print0 | xargs -0 assembly";
      "files-archive" = "find . -type f -print0 | xargs -0 archive";
      "files-compressed" = "find . -type f -print0 | xargs -0 compressed";
      "files-encrypted" = "find . -type f -print0 | xargs -0 encrypted";
      "files-signed" = "find . -type f -print0 | xargs -0 signed";
      "files-checksum" = "find . -type f -print0 | xargs -0 checksum";
      "files-hash" = "find . -type f -print0 | xargs -0 hash";
      "files-digest" = "find . -type f -print0 | xargs -0 digest";
      "files-signature" = "find . -type f -print0 | xargs -0 signature";
      "files-certificate" = "find . -type f -print0 | xargs -0 certificate";
      "files-key" = "find . -type f -print0 | xargs -0 key";
      "files-secret" = "find . -type f -print0 | xargs -0 secret";
      "files-password" = "find . -type f -print0 | xargs -0 password";
      "files-credential" = "find . -type f -print0 | xargs -0 credential";
      "files-token" = "find . -type f -print0 | xargs -0 token";
      "files-auth" = "find . -type f -print0 | xargs -0 auth";
      "files-identity" = "find . -type f -print0 | xargs -0 identity";
      "files-profile" = "find . -type f -print0 | xargs -0 profile";
      "files-account" = "find . -type f -print0 | xargs -0 account";
      "files-user" = "find . -type f -print0 | xargs -0 user";
      "files-xargs-group" = "find . -type f -print0 | xargs -0 group";
      "files-role" = "find . -type f -print0 | xargs -0 role";
      "files-permission" = "find . -type f -print0 | xargs -0 permission";
      "files-policy" = "find . -type f -print0 | xargs -0 policy";
      "files-rule" = "find . -type f -print0 | xargs -0 rule";
      "files-access" = "find . -type f -print0 | xargs -0 access";
      "files-control" = "find . -type f -print0 | xargs -0 control";
      "files-security" = "find . -type f -print0 | xargs -0 security";
      "files-audit" = "find . -type f -print0 | xargs -0 audit";
      "files-log" = "find . -type f -print0 | xargs -0 log";
      "files-event" = "find . -type f -print0 | xargs -0 event";
      "files-incident" = "find . -type f -print0 | xargs -0 incident";
      "files-alert" = "find . -type f -print0 | xargs -0 alert";
      "files-warning" = "find . -type f -print0 | xargs -0 warning";
      "files-error" = "find . -type f -print0 | xargs -0 error";
      "files-critical" = "find . -type f -print0 | xargs -0 critical";
      "files-fatal" = "find . -type f -print0 | xargs -0 fatal";
      "files-emergency" = "find . -type f -print0 | xargs -0 emergency";
      "files-panic" = "find . -type f -print0 | xargs -0 panic";
      "files-crash" = "find . -type f -print0 | xargs -0 crash";
      "files-bug" = "find . -type f -print0 | xargs -0 bug";
      "files-issue" = "find . -type f -print0 | xargs -0 issue";
      "files-ticket" = "find . -type f -print0 | xargs -0 ticket";
      "files-task" = "find . -type f -print0 | xargs -0 task";
      "files-story" = "find . -type f -print0 | xargs -0 story";
      "files-epic" = "find . -type f -print0 | xargs -0 epic";
      "files-milestone" = "find . -type f -print0 | xargs -0 milestone";
      "files-version" = "find . -type f -print0 | xargs -0 version";
      "files-changelog" = "find . -type f -print0 | xargs -0 changelog";
      "files-readme" = "find . -type f -print0 | xargs -0 readme";
      "files-license" = "find . -type f -print0 | xargs -0 license";
      "files-copying" = "find . -type f -print0 | xargs -0 copying";
      "files-authors" = "find . -type f -print0 | xargs -0 authors";
      "files-contributors" = "find . -type f -print0 | xargs -0 contributors";
      "files-maintainers" = "find . -type f -print0 | xargs -0 maintainers";
      "files-owners" = "find . -type f -print0 | xargs -0 owners";
      "files-codeofconduct" = "find . -type f -print0 | xargs -0 codeofconduct";
      "files-vulnerability" = "find . -type f -print0 | xargs -0 vulnerability";
      "files-advisory" = "find . -type f -print0 | xargs -0 advisory";
      "files-cve" = "find . -type f -print0 | xargs -0 cve";
      "files-cwe" = "find . -type f -print0 | xargs -0 cwe";
      "files-cvss" = "find . -type f -print0 | xargs -0 cvss";
      "files-severity" = "find . -type f -print0 | xargs -0 severity";
      "files-impact" = "find . -type f -print0 | xargs -0 impact";
      "files-exploit" = "find . -type f -print0 | xargs -0 exploit";
      "files-mitigation" = "find . -type f -print0 | xargs -0 mitigation";
      "files-remediation" = "find . -type f -print0 | xargs -0 remediation";
      "files-fix" = "find . -type f -print0 | xargs -0 fix";
      "files-patch" = "find . -type f -print0 | xargs -0 patch";
      "files-update" = "find . -type f -print0 | xargs -0 update";
      "files-upgrade" = "find . -type f -print0 | xargs -0 upgrade";
      "files-migrate" = "find . -type f -print0 | xargs -0 migrate";
      "files-deprecated" = "find . -type f -print0 | xargs -0 deprecated";
      "files-obsolete" = "find . -type f -print0 | xargs -0 obsolete";
      "files-legacy" = "find . -type f -print0 | xargs -0 legacy";
      "files-backward" = "find . -type f -print0 | xargs -0 backward";
      "files-forward" = "find . -type f -print0 | xargs -0 forward";
      "files-compat" = "find . -type f -print0 | xargs -0 compat";
      "files-compat-layer" = "find . -type f -print0 | xargs -0 compat-layer";
      "files-shim" = "find . -type f -print0 | xargs -0 shim";
      "files-bridge" = "find . -type f -print0 | xargs -0 bridge";
      "files-adapter" = "find . -type f -print0 | xargs -0 adapter";
      "files-wrapper" = "find . -type f -print0 | xargs -0 wrapper";
      "files-proxy" = "find . -type f -print0 | xargs -0 proxy";
      "files-facade" = "find . -type f -print0 | xargs -0 facade";
      "files-delegate" = "find . -type f -print0 | xargs -0 delegate";
      "files-interceptor" = "find . -type f -print0 | xargs -0 interceptor";
      "files-middleware" = "find . -type f -print0 | xargs -0 middleware";
      "files-pipeline" = "find . -type f -print0 | xargs -0 pipeline";
      "files-chain" = "find . -type f -print0 | xargs -0 chain";
      "files-flow" = "find . -type f -print0 | xargs -0 flow";
      "files-pipe" = "find . -type f -print0 | xargs -0 pipe";
      "files-filter-chain" = "find . -type f -print0 | xargs -0 filter-chain";
      "files-processor" = "find . -type f -print0 | xargs -0 processor";
      "files-handler" = "find . -type f -print0 | xargs -0 handler";
      "files-listener" = "find . -type f -print0 | xargs -0 listener";
      "files-observer" = "find . -type f -print0 | xargs -0 observer";
      "files-subscriber" = "find . -type f -print0 | xargs -0 subscriber";
      "files-publisher" = "find . -type f -print0 | xargs -0 publisher";
      "files-consumer" = "find . -type f -print0 | xargs -0 consumer";
      "files-producer" = "find . -type f -print0 | xargs -0 producer";
      "files-broker" = "find . -type f -print0 | xargs -0 broker";
      "files-exchange" = "find . -type f -print0 | xargs -0 exchange";
      "files-queue" = "find . -type f -print0 | xargs -0 queue";
      "files-topic" = "find . -type f -print0 | xargs -0 topic";
      "files-channel" = "find . -type f -print0 | xargs -0 channel";
      "files-bus" = "find . -type f -print0 | xargs -0 bus";
      "files-router" = "find . -type f -print0 | xargs -0 router";
      "files-switch" = "find . -type f -print0 | xargs -0 switch";
      "files-gateway" = "find . -type f -print0 | xargs -0 gateway";
      "files-loadbalancer" = "find . -type f -print0 | xargs -0 loadbalancer";
      "files-balancer" = "find . -type f -print0 | xargs -0 balancer";
      "files-distributor" = "find . -type f -print0 | xargs -0 distributor";
      "files-aggregator" = "find . -type f -print0 | xargs -0 aggregator";
      "files-collector" = "find . -type f -print0 | xargs -0 collector";
      "files-sampler" = "find . -type f -print0 | xargs -0 sampler";
      "files-reporter" = "find . -type f -print0 | xargs -0 reporter";
      "files-metrics" = "find . -type f -print0 | xargs -0 metrics";
      "files-telemetry" = "find . -type f -print0 | xargs -0 telemetry";
      "files-tracing" = "find . -type f -print0 | xargs -0 tracing";
      "files-observability" = "find . -type f -print0 | xargs -0 observability";
      "files-monitoring" = "find . -type f -print0 | xargs -0 monitoring";
      "files-logging" = "find . -type f -print0 | xargs -0 logging";
      "files-compliance" = "find . -type f -print0 | xargs -0 compliance";
      "files-governance" = "find . -type f -print0 | xargs -0 governance";
      "files-standard" = "find . -type f -print0 | xargs -0 standard";
      "files-guideline" = "find . -type f -print0 | xargs -0 guideline";
      "files-best-practice" = "find . -type f -print0 | xargs -0 best-practice";
      "files-recommendation" = "find . -type f -print0 | xargs -0 recommendation";
      "files-suggestion" = "find . -type f -print0 | xargs -0 suggestion";
      "files-tip" = "find . -type f -print0 | xargs -0 tip";
      "files-hint" = "find . -type f -print0 | xargs -0 hint";
      "files-trick" = "find . -type f -print0 | xargs -0 trick";
      "files-hack" = "find . -type f -print0 | xargs -0 hack";
      "files-workaround" = "find . -type f -print0 | xargs -0 workaround";
      "files-solution" = "find . -type f -print0 | xargs -0 solution";
      "files-answer" = "find . -type f -print0 | xargs -0 answer";
      "files-resolution" = "find . -type f -print0 | xargs -0 resolution";
      "files-repair" = "find . -type f -print0 | xargs -0 repair";
      "files-recovery" = "find . -type f -print0 | xargs -0 recovery";
      "files-restore" = "find . -type f -print0 | xargs -0 restore";
      "files-backup" = "find . -type f -print0 | xargs -0 backup";
      "files-snapshot" = "find . -type f -print0 | xargs -0 snapshot";
      "files-clone" = "find . -type f -print0 | xargs -0 clone";
      "files-replicate" = "find . -type f -print0 | xargs -0 replicate";
      "files-mirror" = "find . -type f -print0 | xargs -0 mirror";
      "files-sync" = "find . -type f -print0 | xargs -0 sync";

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
      [[ $- == *i* ]] && source -- "$(blesh-share)"/ble.sh --attach=none
    '';

    initExtra = ''
      # Source NixOS environment variables (FZF_DEFAULT_OPTS, etc.)
      [ -f /etc/set-environment ] && source /etc/set-environment

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
