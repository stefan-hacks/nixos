# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/8a350d7a-ce96-4ba6-938c-61b2739239f6";
  };

  # Ensure graphics drivers are properly mapped
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd # OpenCL support for AMD
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };



  # Nixos - Maintenance
  nix = {
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      trusted-users = [
        "root"
        "@wheel"
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };


  networking.hostName = "nixos"; # Define your hostname.


  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # GNOME Desktop
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # virtualisation
  # virtualisation = {
  #   docker.enable = false;
  #   podman.enable = false;
  #
  #   libvirtd = {
  #     enable = true;
  #     qemu = {
  #       package = pkgs.qemu_kvm;
  #       swtpm.enable = true;
  #     };
  #   };
  #   spiceUSBRedirection.enable = true;
  # };


  # Avahi - network printing & file sharing, local discovery, local hostname resolution
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Automatically installs and configures nss-mdns for IPv4
    # nssmdns6 = true; # Uncomment if you explicitly need IPv6 local resolution

    # Open necessary firewall ports for mDNS discovery
    openFirewall = true;
  };

  # Fix the "Invalid group-name group='netdev'" D-Bus warning
  # This declaratively creates the netdev group that Avahi's D-Bus config expects
  users.groups.netdev = {};


  # Define a user account. Don't forget to set a password with ‘passwd’.
  # When to use mutable: Temporary testing, transitioning from another distro. When to use immutable: Production, reproducibility, version control.
  # users.mutableUsers = false;

  users.users."stefan-hacks" = {
    isNormalUser = true;
     # hashedPassword removed for security — set via sops-nix or interactive passwd
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "kvm"
      "input"
      "uinput"
   #   "dialout"
   #   "libvirtd"
    ];
    packages = with pkgs; [
    #  tree
    ];
  };

  # Programs
  programs.firefox.enable = true;
  programs.gpaste.enable = true;
  programs.starship.enable = true;

  # Configure the Atuin Shell Client System-Wide
  programs.atuin = {
    enable = true;

    # Declarative client parameters written automatically to /etc/atuin/config.toml
    settings = {
      auto_sync = true;
      sync_address = "https://atuin.sh"; # Change to https://api.atuin.sh if using the default public sync server
      update_check = false;
    };
  };

  # Zoxide
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };



  # Allow Unfree
  nixpkgs.config.allowUnfree = true;

  # Allow experimental features and flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    curl
    nh
    gh
    onlyoffice-desktopeditors
    discord
    whatsie
    carapace
    blesh
    lolcat
    tealdeer
    tree
    ripgrep
    eza
    btop
    ffmpeg
    mpv
    vlc
    _1password-gui
    glow
    gum
    grc
    nixd
    guvcview
    zellij
    # virt-manager
    # qemu
    # qemu_kvm
    # spice-gtk
    # spice
    # spice-vdagent
    # dnsmasq
    # bridge-utils
    impression
    bat
    bat-extras.core
    fd
    jq
    yq-go
    shellcheck
    yazi
    lazygit
    inetutils
    dnsutils
    traceroute
    lazyssh
    tcpdump
    mtr
    fzf
    fastfetch
    cpufetch
    onefetch
    tokei
    wl-clipboard
    kitty
    kanata
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.symbols-only
    gnome-tweaks
    chafa
    yt-dlp
    parabolic
    shortwave

    # Hardware
    pciutils
    usbutils
    lshw
    dmidecode
    smartmontools
    lm_sensors

    # Network
    ethtool
    tcpdump
    traceroute
    nmap
    iperf3
    dnsutils

    # Monitoring / Debugging
    htop
    iotop
    iftop
    strace
    lsof

    # Utilities
    file
    tree
    parted
    nvme-cli

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Kanata Keyboard
  services.kanata = {
    enable = true;
    keyboards = {
      kanata = {
        config = ''
         ;; Variables
         (defvar
          tap-time 200
          hold-time 200
         )

         ;; Defsrc contains the original unmapped keyboard layout. Often this is qwerty.
         (defsrc
           esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
           grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
           tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
           caps a    s    d    f    g    h    j    k    l    ;    '    ret
           lsft z    x    c    v    b    n    m    ,    .    /    rsft
           lctl lmet lalt           spc            ralt rmet rctl
         )

         ;; Aliases
         ;; Layer toggles — accessed by holding modifier keys
         (defalias
           ;; Spacebar → Layer 2: Symbols / programming characters
           l2 (tap-hold $tap-time $hold-time spc (layer-toggle two))

           ;; Left Meta (S key) → Layer 3: Window/Workspace management
           l3 (tap-hold $tap-time $hold-time lmet (layer-toggle three))

           ;; Left Ctrl → Layer 4: Text editing / mouse wheel emulation
           l4 (tap-hold $tap-time $hold-time lctl (layer-toggle four))


           ;; Home row tap-hold modifiers
           ;; S key: tap=s, hold=Left Meta (Super/Windows key)
           ss (tap-hold $tap-time $hold-time s lmet)
           ;; D key: tap=d, hold=Left Alt
           dd (tap-hold $tap-time $hold-time d lalt)
           ;; F key: tap=f, hold=Left Ctrl
           ff (tap-hold $tap-time $hold-time f lctl)
           ;; H key: tap=h, hold=Shift+` (GNOME Activities overview shortcut)
           hh (tap-hold $tap-time $hold-time h S-grv)
           ;; J key: tap=j, hold=Right Ctrl
           jj (tap-hold $tap-time $hold-time j rctl)
           ;; K key: tap=k, hold=Right Alt
           kk (tap-hold $tap-time $hold-time k ralt)
           ;; L key: tap=l, hold=Right Meta
           ll (tap-hold $tap-time $hold-time l rmet)

           ;; Thumb cluster tap-hold modifiers
           ;; Backspace: tap=backspace, hold=delete
           la (tap-hold $tap-time $hold-time bspc del)
           ;; Enter: tap=enter, hold=Right Alt
           ra (tap-hold $tap-time $hold-time ret ralt)

           ;; F-row system controls (hold activates media/window actions)
           ;; F1: tap=F1, hold=quake terminal dropdown
           qtd (tap-hold $tap-time $hold-time f1 C-A-q)
           ;; F2: tap=F2, hold=run command
           pum (tap-hold $tap-time $hold-time f2 A-f2)
           ;; F3: tap=F3, hold=decrease display brightness
           dsb (tap-hold $tap-time $hold-time f3 C-M-down)
           ;; F4: tap=F4, hold=increase display brightness
           isb (tap-hold $tap-time $hold-time f4 C-M-up)
           ;; F5: tap=F5, hold=toggle mute speakers/audio output
           mut (tap-hold $tap-time $hold-time f5 A-f5)
           ;; F6: tap=F6, hold=volume down
           vdn (tap-hold $tap-time $hold-time f6 A-f6)
           ;; F7: tap=F7, hold=volume up
           vup (tap-hold $tap-time $hold-time f7 A-f7)
           ;; F8: tap=F8, hold=toggle microphone
           mic (tap-hold $tap-time $hold-time f8 A-f8)
           ;; F9: tap=F9, hold=take screenshot
           psc (tap-hold $tap-time $hold-time f9 C-S-A-r)
           ;; F10: tap=F10, hold=lock screen
           lts (tap-hold $tap-time $hold-time f10 M-l)

           ;; Number row tap-hold: tap=digit, hold=shifted symbol
           ;; ` key: tap=`, hold=~
           gm (tap-hold $tap-time $hold-time grv S-grv)
           ;; 1 key: tap=1, hold=!
           1m (tap-hold $tap-time $hold-time 1 S-1)
           ;; 2 key: tap=2, hold=@
           2m (tap-hold $tap-time $hold-time 2 S-2)
           ;; 3 key: tap=3, hold=#
           3m (tap-hold $tap-time $hold-time 3 S-3)
           ;; 4 key: tap=4, hold=$
           4m (tap-hold $tap-time $hold-time 4 S-4)
           ;; 5 key: tap=5, hold=%
           5m (tap-hold $tap-time $hold-time 5 S-5)
           ;; 6 key: tap=6, hold=^
           6m (tap-hold $tap-time $hold-time 6 S-6)
           ;; 7 key: tap=7, hold=&
           7m (tap-hold $tap-time $hold-time 7 S-7)
           ;; 8 key: tap=8, hold=*
           8m (tap-hold $tap-time $hold-time 8 S-8)
           ;; 9 key: tap=9, hold=(
           9m (tap-hold $tap-time $hold-time 9 S-9)
           ;; 0 key: tap=0, hold=)
           0m (tap-hold $tap-time $hold-time 0 S-0)
           ;; - key: tap=-, hold=_
           mi (tap-hold $tap-time $hold-time - S--)
           ;; = key: tap==, hold=+
           pl (tap-hold $tap-time $hold-time = S-=)

           ;; Top row tap-hold: tap=letter, hold=Ctrl+letter (common shortcuts)
           ;; Q key: tap=q, hold=Ctrl+Q (quit application)
           qq (tap-hold $tap-time $hold-time q C-q)
           ;; W key: tap=w, hold=Ctrl+W (close tab/window)
           ww (tap-hold $tap-time $hold-time w C-w)
           ;; E key: tap=e, hold=Ctrl+E (no specific binding, reserved)
           ee (tap-hold $tap-time $hold-time e C-e)
           ;; R key: tap=r, hold=Ctrl+R (reload)
           rr (tap-hold $tap-time $hold-time r C-r)
           ;; T key: tap=t, hold=Ctrl+T (new tab)
           tt (tap-hold $tap-time $hold-time t C-t)

           ;; Navigation tap-hold on home row right side
           ;; Y key: tap=y, hold=Home (beginning of line)
           yy (tap-hold $tap-time $hold-time y home)
           ;; U key: tap=u, hold=Page Down
           uu (tap-hold $tap-time $hold-time u pgdn)
           ;; I key: tap=i, hold=Page Up
           ii (tap-hold $tap-time $hold-time i pgup)
           ;; O key: tap=o, hold=End (end of line)
           oo (tap-hold $tap-time $hold-time o end)

           ;; Media controls (tap and hold both trigger same action)
           ;; P key: tap/hold=play/pause media
           pp (tap-hold $tap-time $hold-time C-M-/ C-M-/)
           ;; [ key: tap/hold=previous track
           pt (tap-hold $tap-time $hold-time C-M-, C-M-,)
           ;; ] key: tap/hold=next track
           nt (tap-hold $tap-time $hold-time C-M-. C-M-.)
           ;; ; key: tap/hold=scroll left (Shift+Meta+H)
           mls (tap-hold $tap-time $hold-time S-M-h S-M-h)
           ;; ' key: tap/hold=scroll right (Shift+Meta+L)
           mrs (tap-hold $tap-time $hold-time S-M-l S-M-l)


           ;; Bracket and punctuation tap-hold: tap=unshifted, hold=shifted
           ;; [ key: tap=[, hold={
           so (tap-hold $tap-time $hold-time [ S-[)
           ;; ] key: tap=], hold=}
           sc (tap-hold $tap-time $hold-time ] S-])
           ;; \ key: tap=\, hold=|
           pi (tap-hold $tap-time $hold-time \ S-\)
           ;; A key: tap=a, hold=Ctrl+A (select all)
           aa (tap-hold $tap-time $hold-time a lsft)
           ;; ; key: tap=;, hold=:
           se (tap-hold $tap-time $hold-time ; rsft)
           ;; ' key: tap=', hold="
           ap (tap-hold $tap-time $hold-time ' S-')

           ;; Bottom row tap-hold: tap=letter, hold=Ctrl+letter
           ;; Z key: tap=z, hold=Ctrl+Z (undo)
           zz (tap-hold $tap-time $hold-time z C-z)
           ;; X key: tap=x, hold=Ctrl+X (cut)
           xx (tap-hold $tap-time $hold-time x C-x)
           ;; C key: tap=c, hold=Ctrl+C (copy)
           cc (tap-hold $tap-time $hold-time c C-c)
           ;; V key: tap=v, hold=Ctrl+V (paste)
           vv (tap-hold $tap-time $hold-time v C-v)
           ;; , key: tap=,, hold=<
           co (tap-hold $tap-time $hold-time , S-,)
           ;; . key: tap=., hold=>
           fu (tap-hold $tap-time $hold-time . S-.)
           ;; / key: tap=/, hold=?
           fs (tap-hold $tap-time $hold-time / S-/)

           ;; Text deletion aliases for Layer 4 (Editing)
           ;; , key: tap=C-w (delete word backward, terminal style)
           tbd (tap-hold $tap-time $hold-time , C-w)
           ;; . key: tap=A-d (delete word forward)
           tfd (tap-hold $tap-time $hold-time . A-d)
           ;; [ key: tap=C-u (delete to beginning of line)
           dtb (tap-hold $tap-time $hold-time [ C-u)
           ;; ] key: tap=C-k (delete to end of line)
           dte (tap-hold $tap-time $hold-time ] C-k)
           ;; , key: tap=C-bspc (delete word backward)
           dwb (tap-hold $tap-time $hold-time , C-bspc)
           ;; . key: tap=C-del (delete word forward)
           dwf (tap-hold $tap-time $hold-time . C-del)

           ;; Window snapping (GNOME)

           ;; H key: tap/hold=snap to left (Meta+Left)
           rpl (tap-hold $tap-time $hold-time M-left M-left)
           ;; J key: tap/hold=restore window size (Meta+Down)
           rpd (tap-hold $tap-time $hold-time M-down M-down)
           ;; K key: tap/hold=maximize window (Meta+Up)
           rpu (tap-hold $tap-time $hold-time M-up M-up)
           ;; L key: tap/hold=snap to right (Meta+Right)
           rpr (tap-hold $tap-time $hold-time M-rght M-rght)


           ;; GNOME workspace navigation
           ;; Y key: tap/hold=switch to first workspace (Super+Home)
           wtl (tap-hold $tap-time $hold-time M-home M-home)
           ;; O key: tap/hold=switch to last workspace (Super+End)
           wtr (tap-hold $tap-time $hold-time M-end M-end)
           ;; [ key: tap/hold=switch to workspace on the left (Super+Pgup)
           dsl (tap-hold $tap-time $hold-time M-pgup M-pgup)
           ;; ] key: tap/hold=switch to workspace on the right (Super+Pgdn)
           dsr (tap-hold $tap-time $hold-time M-pgdn M-pgdn)

           ;; Moving windows (GNOME)
           ;; N key: tap/hold=Move window one monitor to the left  (Shift+Super+left)
           w1 (tap-hold $tap-time $hold-time S-M-left S-M-left)
           ;; M key: tap/hold=Move window one workspace to the left (Shift+Super+Pgup)
           w2 (tap-hold $tap-time $hold-time S-M-pgup S-M-pgup)
           ;; , key: tap/hold=Move window one workspace to the right (Shift+Super+Pgdn)
           w3 (tap-hold $tap-time $hold-time S-M-pgdn S-M-pgdn)
           ;; . key: tap/hold=Move window one monitor right (Shift+Super+Right)
           w4 (tap-hold $tap-time $hold-time S-M-rght S-M-rght)


           ;; Mouse wheel emulation (Layer 4 — Editing)
           ;; H key: mouse wheel left
           mwl (mwheel-left 50 120)
           ;; J key: mouse wheel down
           mwd (mwheel-down 50 120)
           ;; K key: mouse wheel up
           mwu (mwheel-up 50 120)
           ;; L key: mouse wheel right
           mwr (mwheel-right 50 120)
         )

         ;; LAYER ONE - main mods - the caps and esc key are swapped for all layers
         (deflayer one
           caps @qtd @pum @dsb @isb @mut @vdn @vup @mic @psc @lts f11  f12
           @gm  @1m  @2m  @3m  @4m  @5m  @6m  @7m  @8m  @9m  @0m  @mi  @pl  bspc
           tab  @qq  @ww  e    @rr  @tt  @yy  @uu  @ii  @oo  p    @so  @sc  @pi
           esc  @aa  @ss  @dd  @ff  g    @hh  @jj  @kk  @ll  @se  @ap  ret
           lsft @zz  @xx  @cc  @vv  b    n    m    @co  @fu  @fs  rsft
           @l4  @l3  @la           @l2             @ra  _    rctl
         )

         ;; LAYER TWO - Symbols - programming layer - spacebar held
         (deflayer two
           caps @qtd @pum @dsb @isb @mut @vdn @vup @mic @psc @lts _    _
           _    _    _    _    _    _    _    _    _    _    _    _    _    bspc
           tab  S-1  S-2  S-3  S-4  S-5  0    S-9  S-0  S-[  S-]  [    ]    _
           esc  S-6  S-7  S-8  /    grv  S-grv S-\ S-;  S-'  _    _    ret
           _    -    S-=  S--  =    \    S-,  S-.  ,    .    S-/  _
           _    _    _           _                 _    _    _
         )
         ;; LAYER THREE - Workspaces, Windows, Panes layer - left hand on left Windows key
         (deflayer three
           caps _    _    _    _    _    _    _    _    _    _    _    lrld
           grv  _    _    _    _    _    _    _    _    _    _    _    _    _
           tab  _    _    _    _    _    @wtl @dsl @dsr @wtr @pp  @pt  @nt  _
           esc  _    _    _    _    _    @rpl @rpd @rpu @rpr @mls @mrs ret
           _    _    _    _    _    _    @w1  @w2  @w3  @w4  _    _
           _    _    _           _                 _    _    _
         )
         ;; LAYER FOUR - Editing - text and terminal editing layer - left ctrl key held
         (deflayer four
           caps @qtd @pum @dsb @isb @mut @vdn @vup @mic @psc @lts _    _
           grv  _    _    _    _    _    _    _    _    _    _    _    _    bspc
           tab  _    _    _    _    _    @mwl @mwd @mwu @mwr _    @dtb @dte _
           esc  _    _    _    _    _    left down up   rght bspc del  ret
           _    _    _    _    _    _    @dwb @dwf @tbd @tfd _    _
           _    _    _           _                 _    _    _
         )

         ;; lrld is a default shortcut to reload the configuration found on layer 3 in place of f12

        '';
      };
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    # Allow TCP ports.
    allowedTCPPorts = [ 22 80 443 ];
    # Allow UDP ports.
    allowedUDPPorts = [ 53 ];
    # Allow a port range.
    allowedTCPPortRanges = [
      { from = 1000; to = 2000; }
    ];
    # Allow traffic on specific interfaces.
    interfaces."wlp3s0".allowedTCPPorts = [ 8080 ];
  };


  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";

    bantime-increment = {
      enable = true;
      maxtime = "7d";
      overalljails = true;
    };

    jails.sshd.settings = {
      enabled = true;
      maxretry = 5;
      findtime = 600;
      bantime = 3600;
    };
  };


  # Logging
  services.logrotate = {
   enable = true;
  # Native NixOS options wrap formatting neatly without defaulting to dry-run states
  };

  security.auditd.enable = true;

  security.audit = {
    # Rules to log.
    rules = [
      # Log all sudo usage.
      "-a always,exit -F arch=b64 -S setuid -S setgid -k privilege-escalation"

      # Log all file deletions in /etc.
      "-w /etc/ -p wa -k etc-modifications"

      # Log SSH key file access.
      "-w /etc/ssh/ -p wa -k ssh-key-access"

      # Log all authentication attempts.
      "-w /var/log/auth.log -p wa -k auth-log-access"
    ];
  };


  # Maintenance
  system.autoUpgrade = {
    enable = true;

    # Run daily at 4:00 AM.
    dates = "04:00";

    # Use the nixos-26.05 stable channel for automatic updates.
    channel = "https://nixos.org/channels/nixos-26.05";

    # Allow reboot if required (for kernel updates).
    allowReboot = false;  # Set to true for automatic reboots.
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
