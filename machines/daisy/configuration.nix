{ config, pkgs, ... }: {

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  mayniklas = {
    gnome.enable = true;
    desktop = {
      enable = true;
      home-manager = true;
    };
  };

  networking = {
    hostName = "daisy";
    networkmanager.enable = true;
  };

  system.stateVersion = "23.05";

}
