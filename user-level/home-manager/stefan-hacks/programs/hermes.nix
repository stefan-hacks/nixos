# Move this configuration block into your user-level Home Manager setup
{...}: {
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  programs.hermes-agent = {
    enable = true;
    desktop.enable = true; # Creates the desktop launcher menu entries
  };

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    backend.mode = "dashboard";
    extraDependencyGroups = ["messaging"];
    # Keep settings blank to ensure the UI can save configuration changes natively
  };
}
