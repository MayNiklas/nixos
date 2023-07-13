{ config, pkgs, nixos-hardware, ... }: {

  imports = [
    # Include the results of the hardware scan.
    ./lte.nix
    ./hardware-configuration.nix
    # https://github.com/NixOS/nixos-hardware/tree/master/lenovo/thinkpad/x390
    nixos-hardware.nixosModules.lenovo-thinkpad-x390
  ];

  # fingerprint login
  services.fprintd.enable = true;

  netkit.xmm7360 = {
    enable = true;
    autoStart = true;
  };

  boot = {
    # Kernel 6.4 - because why not?
    kernelPackages = pkgs.linuxPackages_5_15;
  };

  environment.systemPackages = with pkgs; [
    usbutils
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
