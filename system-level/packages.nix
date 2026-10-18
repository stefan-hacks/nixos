# System-wide packages installed in the system profile.
# To find more packages and options: https://search.nixos.org/
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Editors
    vim # Do not forget to add an editor to edit configuration.nix!

    # Core utilities
    wget
    git
    curl
    tree
    ripgrep
    eza
    btop
    fd
    jq
    yq-go
    fzf
    bat
    bat-extras.core
    tealdeer
    file
    parted
    nvme-cli

    # Shell enhancements
    blesh
    lolcat
    grc
    starship
    zoxide
    carapace
    atuin
    gh

    # Terminal multiplexers and tools
    zellij
    yazi
    lazygit
    kitty
    glow
    gum

    # Nix ecosystem tools (non-flake workflow support)
    nh                          # nix-helper: cleaner rebuilds, intelligent GC
    nix-output-monitor          # nom: live TUI for nix builds
    nix-index                   # nix-locate: "which package provides /bin/xyz?"
    nix-tree                    # interactive dependency DAG browser
    nix-du                      # accurate store disk usage (handles shared refs)
    nix-diff                    # structural derivation diff without building
    nix-init                    # generate nix exprs from language lockfiles
    nixpkgs-fmt                 # opinionated nix formatter
    alejandra                   # fast Rust nix formatter
    deadnix                     # dead-code finder for .nix files
    statix                      # nix linter (with --fix)
    nixos-generators            # build ISOs, SD images, containers from config
    nix-top                     # live view of running nix builds
    cached-nix-shell            # instant re-entry for nix-shell
    comma                       # run packages without installing: `, cowsay hi`

    # Development
    nixd
    shellcheck
    tokei
    onefetch

    # Networking tools
    inetutils
    dnsutils
    traceroute
    mtr
    tcpdump
    ethtool
    nmap
    iperf3
    lazyssh

    # System info
    fastfetch
    cpufetch
    pciutils
    usbutils
    lshw
    dmidecode
    smartmontools
    lm_sensors

    # Monitoring / Debugging
    htop
    iotop
    iftop
    strace
    lsof

    # Media
    ffmpeg
    mpv
    vlc
    chafa
    yt-dlp
    parabolic
    shortwave

    # Desktop / GUI
    onlyoffice-desktopeditors
    discord
    whatsie
    _1password-gui
    gnome-tweaks
    guvcview
    impression

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.symbols-only

    # Keyboard
    kanata

    # Clipboard
    wl-clipboard

    # Uncomment below to enable virtualization tools.
    # virt-manager
    # qemu
    # qemu_kvm
    # spice-gtk
    # spice
    # spice-vdagent
    # dnsmasq
    # bridge-utils
  ];
}
