# system-level/theming.nix — Unified system-wide theming.
# GDM login screen wallpaper.
{pkgs, ...}: let
  # ═══════════════════════════════════════════════════════════════════════════
  # Single wallpaper used for the GDM login screen
  # ═══════════════════════════════════════════════════════════════════════════
  # The image is copied to the Nix store so GDM can access it.
  # NOTE: Uses relative path so it works in pure flake evaluation mode.
  wallpaperImage = ../assets/wallpapers/nixos_wallpapers/gdm_blur.png;

  wallpaper = pkgs.runCommand "nixos-wallpaper" {} ''
    mkdir -p $out/share/wallpapers
    cp ${wallpaperImage} $out/share/wallpapers/nixos-bg.png
  '';

  wallpaperPath = "${wallpaper}/share/wallpapers/nixos-bg.png";
in {
  # ═══════════════════════════════════════════════════════════════════════════
  # GDM / GNOME Shell — patched to use the same wallpaper
  # ═══════════════════════════════════════════════════════════════════════════
  # We modify the SCSS source before compilation so the login dialog
  # (#lockDialogGroup) shows our wallpaper. Using substituteInPlace avoids
  # brittle unified-diff patches.
  nixpkgs.overlays = [
    (_self: super: {
      gnome-shell = super.gnome-shell.overrideAttrs (old: {
        postPatch =
          (old.postPatch or "")
          + ''
            # Inject wallpaper background into GDM login dialog SCSS.
            # We prepend our background rule inside the #lockDialogGroup block.
            ${pkgs.perl}/bin/perl -i -pe '
              if (/^#lockDialogGroup \{/) {
                $_ .= "  background: url(\"file://${wallpaperPath}\") no-repeat center center fixed;\n";
                $_ .= "  background-size: cover;\n";
              }
              s/^  background-color: \$_gdm_bg;$//;
            ' data/theme/gnome-shell-sass/widgets/_login-lock.scss
          '';
      });
    })
  ];
}
