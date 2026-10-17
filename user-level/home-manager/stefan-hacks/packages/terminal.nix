# User packages WITHOUT home-manager modules (or with nothing to configure).
# Everything managed by a programs.* module lives under ../programs/.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    blesh # ble.sh — no HM module exists (verified release-26.05); sourced in programs/bash.nix initExtra
  ];
}
