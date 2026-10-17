# System-wide packages: fleet baseline available to root, pre-login, and on
# every host. User-facing tooling lives at user-level (home-manager) so it
# only exists inside stefan-hacks' session:
#   direnv delta gh lazygit fzf kitty nh home-manager -> HM modules (programs/)
#   gcc gnumake LSPs formatters linters               -> profiles/dev-base.nix
#   nil deadnix alejandra statix                      -> profiles/dev-base.nix
#   netdiscover arp-scan + the CTF set                -> profiles/ctf.nix (ghost/titan)
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    ###########################################################################
    # Core Utilities
    ###########################################################################

    bash
    coreutils
    findutils
    gnugrep
    gnused
    gawk
    util-linux
    man-pages
    man-pages-posix
    file
    which
    wget
    curl
    rsync
    unzip
    zip
    p7zip
    vim
    hw-probe
    less
    tokei
    imagemagick
    exiftool

    ###########################################################################
    # Shell Utilities
    ###########################################################################

    eza
    zathura
    yq-go

    ###########################################################################
    # Git (CLI present for root too; user config in HM programs/git.nix)
    ###########################################################################

    git
    git-lfs

    ###########################################################################
    # Networking
    ###########################################################################

    inetutils
    dnsutils
    nmap
    mtr
    traceroute
    tcpdump
    wireshark
    openssh
    lazyssh

    ###########################################################################
    # Archives
    ###########################################################################

    xz
    gzip
    bzip2
    zstd
    lz4
    unrar
    rar

    ###########################################################################
    # Monitoring & Hardware Info
    ###########################################################################

    btop
    fastfetch
    lsof
    pciutils
    usbutils
    lm_sensors
    smartmontools
    nvme-cli
    libva-utils
    libinput

    ###########################################################################
    # Nix CLI quality-of-life
    ###########################################################################

    nix-tree
    nix-output-monitor
    nix-index
    comma

    ###########################################################################
    # Hardware (CLI for kanata --check etc.; the service is in kanata.nix)
    ###########################################################################

    kanata

    ###########################################################################
    # Sysadmin Tools
    ###########################################################################

    # File Operations & Analysis
    exfatprogs
    ntfs3g
    parted
    gparted
    ddrescue
    binsider
    ghgrab

    # Disk & Storage
    ncdu
    duf
    dust
    dua
    iotop

    # Network Tools
    iperf3
    nethogs
    socat
    netcat
    whois
    bind
    doggo # DNS tool
    dog

    # Process & System Monitoring
    htop
    procps
    sysstat
    strace
    ltrace

    # Security plumbing (agent lives at user-level)
    gnupg
    openssl
    age
    sops

    # Text Processing
    miller
    csvkit
    jid
    fx
    jc
    yj

    # System Info
    onefetch
    cpufetch
    inxi

    # TUI Tools (yazi/zellij/tmux configs are user-level; fzf moved to HM)
    lf
    ranger
    mc
    skim

    ###########################################################################
    # Fun / UX
    ###########################################################################

    asciinema
    cmatrix
    lolcat
    figlet

    ###########################################################################
    # Media
    ###########################################################################

    yt-dlp

    ###########################################################################
    # Shell chrome
    ###########################################################################

    glow
    gum
    grc
    chafa
    cava
    xh
    lazydocker
    fd
    ouch
    hexyl
    hevi
    wtfis

    ###########################################################################
    # NixOS Fleet Tooling (operating this config/repo)
    ###########################################################################

    nix-fast-build
    nix-diff
    nix-init
    nix-update
    deploy-rs
    colmena
    nvd

    ###########################################################################
    # External flake tools
    ###########################################################################

    inputs.nix-graph.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Interactive TUI for Nix dependency graphs (github:AlexAntonik/nix-graph)

    ###########################################################################
    # Development / Virtualization Tools
    ###########################################################################

    amp
    bandwhich
    bacon
    netfetch
    atop
    tailspin
    wiper
    qemu
    qemu_kvm
    spice-gtk
    spice
    spice-vdagent
    dnsmasq
    bridge-utils
  ];
}
