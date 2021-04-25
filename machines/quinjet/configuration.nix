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
    in-stock-bot = { enable = true; };
    yubikey = { enable = true; };
    networking = { enable = true; };
    pihole = {
      enable = true;
      port = "8080";
    };
    plex = { enable = true; };
    plex-version-bot = { enable = true; };
    server = {
      enable = true;
      homeConfig = { imports = [ ../../home-manager/home-server.nix ]; };
    };
    scene-extractor = { enable = true; };
    librespeedtest = {
      enable = true;
      port = "8000";
    };
    youtube-dl = { enable = true; };
  };

  networking = { hostName = "quinjet"; };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
