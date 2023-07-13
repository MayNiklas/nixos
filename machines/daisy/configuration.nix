{ config, pkgs, nixos-hardware, ... }: {

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # https://github.com/NixOS/nixos-hardware/tree/master/lenovo/thinkpad/x390
    nixos-hardware.nixosModules.lenovo-thinkpad-x390
  ];

  # fingerprint login
  services.fprintd.enable = true;

  boot =
    let
      xmm7360-pci = config.boot.kernelPackages.callPackage ./xmm7360-pci.nix { };
    in
    {
      # Kernel 6.4 - because why not?
      kernelPackages = pkgs.linuxPackages_6_4;
      extraModulePackages = [ xmm7360-pci ];
    };

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
