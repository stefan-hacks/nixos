# bash.nix — Home Manager bash + ble.sh + aliases
{ config, lib, pkgs, ... }:

{
  programs.bash = {
    enable = true;
  };
}
