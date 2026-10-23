# Hermes Agent — desktop AI assistant
# Now imported as a flake input (github:NousResearch/hermes-agent)
{ config, lib, pkgs, inputs, ... }:

{
  environment.systemPackages = [
    inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.desktop
  ];
}
