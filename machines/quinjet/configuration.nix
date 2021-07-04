# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ self, ... }:

{

  imports = [ ./hardware-configuration.nix ];

  mayniklas = {
    docker = { enable = true; };
    grub = { enable = true; };
    hosts = { enable = true; };
    yubikey = { enable = true; };
    server = {
      enable = true;
      homeConfig = {
        imports = [
          ../../home-manager/home-server.nix
          { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
        ];
      };
    };
    virtualisation = { enable = true; };
  };

  networking = {
    hostName = "quinjet";
    useDHCP = false;
    interfaces.br0.useDHCP = true;
    bridges.br0.interfaces = [ "eno1" ];
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
