{
  inputs,
  ...
}: {
  # 1. Pull the official Home Manager module directly out of the Flake input
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  # 2. Deploy the desktop binary launcher entries
  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;
  };

  # 3. Spin up the background plumbing without imposing strict configuration locks
  services.hermes-agent = {
    enable = true;
    gateway.enable = true; # Runs the messaging gateway loops (Discord)
    backend.mode = "dashboard"; # Exposes standard UI hooks for Hermes Desktop

    # Seals runtime Discord/Slack/Telegram environments into the Nix package build
    # to guarantee that adapters can open cleanly when configured in the app UI
    extraDependencyGroups = ["messaging"];

    /*
    DO NOT DEFINE `settings` OR `configFile` HERE.
    Leaving these blank keeps Nix from marking your directory as `.managed`.
    This leaves `~/.hermes/config.yaml` completely writable by the Desktop UI.
    */
  };
}
