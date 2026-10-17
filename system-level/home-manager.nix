{ inputs, hostName, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";

    extraSpecialArgs = {
      inherit inputs hostName;
    };

    users.stefan-hacks = {
      imports = [
        ../user-level/home-manager/stefan-hacks
      ];
    };
  };
}
