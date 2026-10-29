# System-wide packages installed in the system profile.
# To find more packages and options: https://search.nixos.org/
{
  pkgs,
  inputs,
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
    vim
    evil-helix
    hw-probe
    less
    lynis

    ###########################################################################
    # Shell Utilities
    ###########################################################################
    carapace
    atuin
    zoxide
    fzf
    termscp
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
    toolong

    ###########################################################################
    # Build tools
    ###########################################################################
    gcc
    gnumake
    python3

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
    ansible
    ansible-language-server

    ###########################################################################
    # Formatters
    ###########################################################################
    rustfmt
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
    mullvad
    mullvad-vpn

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
    inputs.nix-graph.packages.${pkgs.stdenv.hostPlatform.system}.default
    nix-index
    nix-tree
    nix-du
    nix-diff
    nix-init
    nixpkgs-fmt
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
    # NOTE: Most GUI apps moved to flatpaks (system-level/flatpak.nix).
    # Kept: stirling-pdf-desktop (not on Flathub)
    ###########################################################################
    gnome-tweaks
    stirling-pdf-desktop

    ###########################################################################
    # Media
    # NOTE: Most GUI media apps moved to flatpaks (system-level/flatpak.nix).
    # Kept: kew (TUI, not on Flathub), ffmpeg/cava/chafa/yt-dlp (CLI tools)
    ###########################################################################
    ffmpeg
    jellyfin-tui
    kew
    yt-dlp
    mpv
    cava
    chafa
    pomodoro

    ###########################################################################
    # Communication
    # NOTE: All GUI communication apps moved to flatpaks (system-level/flatpak.nix).
    ###########################################################################
    # (empty — hermes-desktop is managed separately if installed)

    ###########################################################################
    # System Tools / Misc
    ###########################################################################
    lazydocker
    terraform
    opentofu
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
    llama-cpp
    # impression  → moved to flatpak (io.gitlab.adhami3310.Impression)
    # qbittorrent → moved to flatpak (org.qbittorrent.qBittorrent)

    ###########################################################################
    # Virtualization
    ###########################################################################
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
