# TTY: Control + Alt + F1
# nix run github:numtide/nixos-anywhere -- --flake .#daisy root@192.168.5.140
{ config, lib, pkgs, ... }: {

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  home-manager.users."${config.mayniklas.home-manager.username}" = {
    home.packages = [ ];
  };

  # automatic screen orientation
  # hardware.sensor.iio.enable = false;

  mayniklas = {
    desktop = {
      enable = true;
      home-manager = true;
    };
    gaming.enable = true;
    # sway disables gnome and KDE
    # sway.enable = true;
    # gnome.enable = true;
    kde.enable = true;
  };

  environment.systemPackages = with pkgs; [ ];

  networking = {
    hostName = "daisy";
    networkmanager.enable = true;
  };

  # swapfile
  swapDevices = [{
    device = "/var/swapfile";
    size = (32 * 1024);
  }];

  system.stateVersion = "23.05";

}
