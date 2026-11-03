{ pkgs, lib, ... }:

let
  devdocsData = pkgs.fetchurl {
    url = "https://github.com/filiparag/wikiman/releases/download/2.14.1/devdocs_20261010.source.tar.xz";
    hash = "sha256-iVMeYk4ewn4NPh+grrzUuhMbDKA8NlgegH7YOTuohII=";
  };
in
pkgs.symlinkJoin {
  name = "wikiman-with-devdocs";
  paths = [ pkgs.wikiman ];

  nativeBuildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    # Extract devdocs data into share/doc/devdocs
    mkdir -p $out/share/doc
    tar xf ${devdocsData} -C $out/share/doc --strip-components=3

    # Re-wrap wikiman so conf_sys_usr points at the joined output
    # (which now contains both the program and the devdocs data)
    rm -f $out/bin/wikiman
    makeWrapper ${pkgs.wikiman}/bin/.wikiman-wrapped $out/bin/wikiman \
      --prefix PATH : "${lib.makeBinPath (with pkgs; [ fzf ripgrep gawk w3m coreutils parallel ])}":$out/bin \
      --set "conf_sys_usr" "$out"
  '';

  meta = pkgs.wikiman.meta;
}
