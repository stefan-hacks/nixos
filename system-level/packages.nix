# System-wide packages installed in the system profile.
# To find more packages and options: https://search.nixos.org/
{
  config,
  lib,
  pkgs,
  ...
}: {
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
    tree
    wget
    curl
    rsync
    unzip
    zip
    p7zip
    # vim          # disabled — nixvim vimAlias=true covers this
    evil-helix
    hw-probe
    less
    lynis

    ###########################################################################
    # Shell Utilities
    ###########################################################################
    blesh
    carapace
    atuin
    starship
    zoxide
    fzf
    television
    direnv
    eza
    bat
    bat-extras.core
    ripgrep
    fd
    zathura
    jq
    yq-go
    lolcat
    grc

    ###########################################################################
    # Build tools
    ###########################################################################
    gcc
    gnumake

    ###########################################################################
    # LSP Servers (declarative — Nix-managed, no Mason)
    ###########################################################################
    rust-analyzer
    nixd
    basedpyright
    bash-language-server
    yaml-language-server
    marksman
    taplo
    lua-language-server
    vscode-langservers-extracted
    clang-tools
    gopls
    ansible-language-server

    ###########################################################################
    # Formatters
    ###########################################################################
    rustfmt
    nixfmt
    shfmt
    ruff
    stylua
    black
    isort
    prettier
    gofumpt
    gotools

    ###########################################################################
    # Linters
    ###########################################################################
    cargo
    clippy
    shellcheck
    statix
    yamllint
    markdownlint-cli
    markdownlint-cli2
    ansible-lint

    ###########################################################################
    # Git
    ###########################################################################
    git
    git-lfs
    delta
    gh
    lazygit

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
    socat
    netcat
    whois
    bind
    doggo
    ethtool
    iperf3

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
    ouch

    ###########################################################################
    # Monitoring / System Info
    ###########################################################################
    btop
    htop
    atop
    fastfetch
    cpufetch
    inxi
    onefetch
    lsof
    pciutils
    usbutils
    lm_sensors
    libgtop
    smartmontools
    nvme-cli
    libva-utils
    libinput
    iotop
    iftop
    nethogs
    procps
    sysstat
    strace
    ltrace

    ###########################################################################
    # Nix Ecosystem
    ###########################################################################
    nh
    nix-output-monitor
    nix-index
    nix-tree
    nix-du
    nix-diff
    nix-init
    nixpkgs-fmt
    alejandra
    deadnix
    statix
    nixos-generators
    nix-top
    cached-nix-shell
    comma
    nix-fast-build
    nix-update
    nvd
    nil

    ###########################################################################
    # Hardware / Disk / Filesystem
    ###########################################################################
    kanata
    parted
    gparted
    exfatprogs
    ntfs3g
    ddrescue
    ncdu
    duf
    dust
    dua

    ###########################################################################
    # Security
    ###########################################################################
    gnupg
    openssl
    age
    sops

    ###########################################################################
    # Text Processing / Data
    ###########################################################################
    miller
    csvkit
    jid
    fx
    jc
    yj
    glow
    gum
    hexyl
    hevi

    ###########################################################################
    # TUI / File Managers
    ###########################################################################
    lf
    ranger
    mc
    skim
    yazi
    zellij

    ###########################################################################
    # Terminal Emulators
    ###########################################################################
    kitty
    foot

    ###########################################################################
    # Desktop / Browsers / Productivity
    ###########################################################################
    firefox
    chromium
    joplin-desktop-unstable
    evolution
    gnome-tweaks
    _1password-gui
    libreoffice
    onlyoffice-desktopeditors
    stirling-pdf-desktop
    localsend

    ###########################################################################
    # Media
    ###########################################################################
    shortwave
    mpv
    vlc
    ffmpeg
    jellyfin-tui
    jellyfin-desktop
    kew
    yt-dlp
    parabolic
    soundconverter
    blanket
    easyeffects
    cava
    chafa
    pomodoro

    ###########################################################################
    # Communication
    ###########################################################################
    element-desktop
    discord
    whatsie
    resources

    ###########################################################################
    # System Tools / Misc
    ###########################################################################
    lazydocker
    dog
    xh
    wtfis
    tokei
    asciinema
    cmatrix
    figlet
    imagemagick
    exiftool
    guvcview
    impression
    qbittorrent

    ###########################################################################
    # Virtualization
    ###########################################################################
    qemu
    qemu_kvm
    virt-manager
    spice-gtk
    spice
    spice-vdagent
    dnsmasq
    bridge-utils

    ###########################################################################
    # GNOME / Desktop Integration Dependencies
    ###########################################################################
    # gjs — GNOME JavaScript engine used by some GNOME extensions.
    gjs
    # fontconfig — explicit package provides fc-list, fc-cache.
    fontconfig

    ###########################################################################
    # Fonts
    ###########################################################################
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.symbols-only

    ###########################################################################
    # Clipboard
    ###########################################################################
    wl-clipboard

    ###########################################################################
    # Development / Misc Tools
    ###########################################################################
    amp
    bandwhich
    bacon
    netfetch
    tailspin
    wiper
    tealdeer

    ###########################################################################
    # Security / Network Scanning
    ###########################################################################
    netdiscover
    arp-scan
  ];
}
