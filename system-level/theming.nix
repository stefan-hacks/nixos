# system-level/theming.nix — Unified system-wide theming.
# Plymouth boot splash and GDM login share the same wallpaper.
{ config, lib, pkgs, ... }:

let
  # ═══════════════════════════════════════════════════════════════════════════
  # Single wallpaper used across boot (Plymouth) → login (GDM) → desktop
  # ═══════════════════════════════════════════════════════════════════════════
  # The image MUST be in the Nix store so Plymouth (initrd) and GDM can
  # access it without relying on /home (which may be encrypted/unavailable
  # during early boot).
  wallpaperImage = /home/stefan-hacks/.config/nixos/assets/wallpapers/nixos_wallpapers/23970564.png;

  wallpaper = pkgs.runCommand "nixos-wallpaper" {} ''
    mkdir -p $out/share/wallpapers
    cp ${wallpaperImage} $out/share/wallpapers/nixos-bg.png
  '';

  wallpaperPath = "${wallpaper}/share/wallpapers/nixos-bg.png";

  # ═══════════════════════════════════════════════════════════════════════════
  # Plymouth custom theme — static background image
  # ═══════════════════════════════════════════════════════════════════════════
  plymouthTheme = pkgs.runCommand "nixos-plymouth-theme" {
    nativeBuildInputs = [ pkgs.glib ];
  } ''
    themeDir="$out/share/plymouth/themes/nixos-wallpaper"
    mkdir -p "$themeDir"

    # Copy the wallpaper into the theme directory
    cp ${wallpaperPath} "$themeDir/nixos-bg.png"

    # Create the theme descriptor
    cat > "$themeDir/nixos-wallpaper.plymouth" <<EOF
    [Plymouth Theme]
    Name=NixOS Wallpaper
    Description=Static background image
    ModuleName=script

    [script]
    ImageDir=$themeDir
    ScriptFile=$themeDir/nixos-wallpaper.script
    EOF

    # Create the script that draws the image fullscreen
    cat > "$themeDir/nixos-wallpaper.script" <<'EOF'
    // Simple Plymouth script: show wallpaper fullscreen (cover)
    var logo = Image("nixos-bg.png");

    fun refresh() {
        var sw = Window.GetWidth();
        var sh = Window.GetHeight();
        var iw = logo.GetWidth();
        var ih = logo.GetHeight();

        // Scale to cover the screen (largest dimension)
        var scale = sw / iw;
        if (sh / ih > scale) scale = sh / ih;

        var nw = iw * scale;
        var nh = ih * scale;
        var x = (sw - nw) / 2;
        var y = (sh - nh) / 2;

        logo.SetPosition(x, y);
        logo.SetSize(nw, nh);
        logo.Draw(sw, sh);
    }

    refresh();
    Window.SetRefreshCallback(refresh);
    EOF
  '';

in
{
  # ═══════════════════════════════════════════════════════════════════════════
  # Plymouth
  # ═══════════════════════════════════════════════════════════════════════════
  boot.plymouth = {
    enable = true;
    theme = "nixos-wallpaper";
    themePackages = [ plymouthTheme ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # GDM / GNOME Shell — patched to use the same wallpaper
  # ═══════════════════════════════════════════════════════════════════════════
  # We modify the SCSS source before compilation so the login dialog
  # (#lockDialogGroup) shows our wallpaper. Using substituteInPlace avoids
  # brittle unified-diff patches.
  nixpkgs.overlays = [
    (self: super: {
      gnome-shell = super.gnome-shell.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
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
