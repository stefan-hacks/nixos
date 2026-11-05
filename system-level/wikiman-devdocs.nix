{
  pkgs,
  lib,
  ...
}: let
  devdocsData = pkgs.fetchurl {
    url = "https://github.com/filiparag/wikiman/releases/download/2.14.1/devdocs_20261010.source.tar.xz";
    hash = "sha256-iVMeYk4ewn4NPh+grrzUuhMbDKA8NlgegH7YOTuohII=";
  };
in
  pkgs.stdenvNoCC.mkDerivation {
    pname = "wikiman-with-devdocs";
    version = pkgs.wikiman.version;

    src = pkgs.wikiman;

    dontUnpack = true;

    nativeBuildInputs = [pkgs.makeWrapper];

    buildPhase = ''
      mkdir -p $out

      # Copy wikiman files (NOT symlink — wikiman uses `find -type f`)
      cp -rL $src/* $out/
      chmod -R u+w $out

      # Remove symlinks and copy real files for sources
      rm -rf $out/share/wikiman/sources
      mkdir -p $out/share/wikiman/sources
      cp -L $src/share/wikiman/sources/* $out/share/wikiman/sources/

      # Same for widgets
      rm -rf $out/share/wikiman/widgets
      mkdir -p $out/share/wikiman/widgets
      cp -rL $src/share/wikiman/widgets/* $out/share/wikiman/widgets/ 2>/dev/null || true

      # Extract devdocs data
      mkdir -p $out/share/doc
      tar xf ${devdocsData} -C $out/share/doc --strip-components=3
    '';

    dontFixup = false;

    postFixup = ''
      # Re-wrap the wikiman binary
      rm -f $out/bin/wikiman
      makeWrapper ${pkgs.wikiman}/bin/.wikiman-wrapped $out/bin/wikiman \
        --prefix PATH : "${lib.makeBinPath (with pkgs; [fzf ripgrep gawk w3m coreutils parallel])}":$out/bin \
        --set "conf_sys_usr" "$out"
    '';

    meta = pkgs.wikiman.meta;
  }
