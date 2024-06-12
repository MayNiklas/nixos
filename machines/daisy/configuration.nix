# TTY: Control + Alt + F1
# nix run github:numtide/nixos-anywhere -- --flake .#daisy root@192.168.5.140
{ config, lib, pkgs, ... }: {

  # TODO:
  # - [ ] Sleep / Hibernate / Suspend
  # - [ ] Disable keyboard when in tablet mode
  # - [ ] Flip screen when in tablet mode

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  home-manager.users."${config.mayniklas.home-manager.username}" = {
    home.packages = with pkgs; [ ];
  };

  # automatic screen orientation
  hardware.sensor.iio.enable = true;

  # touchscreen support
  services.xserver.wacom.enable = true;

  services.fprintd.enable = true;

  mayniklas = {
    desktop = {
      enable = true;
      home-manager = true;
    };
    gaming.enable = true;
    virtualisation.enable = true;
    # sway disables gnome and KDE
    sway.enable = true;
    # gnome.enable = true;
    # kde.enable = true;
  };

  environment.systemPackages = with pkgs; [ powertop ];

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
