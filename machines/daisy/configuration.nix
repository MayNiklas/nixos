{ config, pkgs, nixos-hardware, ... }: {

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # https://github.com/NixOS/nixos-hardware/tree/master/lenovo/thinkpad/x390
    nixos-hardware.nixosModules.lenovo-thinkpad-x390
  ];

  # fingerprint login
  services.fprintd.enable = true;

  # automatic screen orientation
  hardware.sensor.iio.enable = true;

  mayniklas = {
    xmm7360.enable = true;
    gnome.enable = true;
    desktop = {
      enable = true;
      home-manager = true;
    };
  };

  environment.systemPackages = with pkgs; [ ];

  networking = {
    hostName = "daisy";
    networkmanager.enable = true;
  };

  system.stateVersion = "23.05";

}
