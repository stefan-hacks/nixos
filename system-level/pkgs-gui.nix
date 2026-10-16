{ ... }:

{
  environment.systemPackages = with pkgs; [
    ###########################################################################
    # Productivity
    ###########################################################################

    chromium
    joplin-desktop
    evolution

    ###########################################################################
    # Office
    ###########################################################################

    libreoffice
    onlyoffice-desktopeditors
    stirling-pdf-desktop

    ###########################################################################
    # Media
    ###########################################################################

    shortwave
    mpv
    vlc
    ffmpeg
    jellyfin-tui
    jellyfin-desktop
    parabolic
    soundconverter
    blanket
    localsend
    easyeffects

    ###########################################################################
    # Communication
    ###########################################################################

    element-desktop
    discord
    whatsie
    resources

    ###########################################################################
    # Development Tools
    ###########################################################################

    guvcview
    qbittorrent
    impression
    virt-manager
  ];
}
