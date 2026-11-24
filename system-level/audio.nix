# Audio configuration
_: {
  services.pipewire = {
    enable = true;
    pulse.enable = true;

    # Disable the x11-bell module — causes pipewire to segfault when the
    # GDM X11 display closes during the transition to the Wayland session.
    # We run pure Wayland; X11 bell is irrelevant here.
    extraConfig.pipewire."10-disable-x11-bell" = {
      "context.modules" = [
        {
          name = "libpipewire-module-x11-bell";
          flags = ["disabled"];
        }
      ];
    };
  };
}
