{ config, pkgs, nixos-hardware, ... }: {

  imports = [
    # Include the results of the hardware scan.
    ./lte.nix
    ./hardware-configuration.nix
    # https://github.com/NixOS/nixos-hardware/tree/master/lenovo/thinkpad/x390
    nixos-hardware.nixosModules.lenovo-thinkpad-x390
  ];

  # LTE "support"
  xmm7360 = {
    enable = true;
    autoStart = false;
  };

  # fingerprint login
  services.fprintd.enable = true;

  mayniklas = {
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
