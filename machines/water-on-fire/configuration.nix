# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ self, ... }:

{

  imports = [ ./hardware-configuration.nix ];

  mayniklas = {
    desktop = {
      enable = true;
      homeConfig = {
        imports = [
          ../../home-manager/home.nix
          { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
        ];
      };
    };
    eizo-alienware = { enable = true; };
    # Get UUID from blkid /dev/sda2
    grub-luks = {
      enable = true;
      uuid = "ea8b02e5-d2ee-44f8-a056-c55fba0d5c93";
    };
    nvidia = { enable = true; };
    wg = {
      enable = true;
      ip = "10.88.88.24";
      allowedIPs = [ "10.88.88.0/24" ];
    };
    virtualisation.enable = true;
    xserver = { enable = true; };
  };

  networking = {
    hostName = "water-on-fire";
    useDHCP = false;
    interfaces.br0.useDHCP = true;
    bridges.br0.interfaces = [ "enp36s0" "enp43s0" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
