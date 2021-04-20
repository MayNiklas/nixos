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
    wg = {
      enable = true;
      router = true;
      ip = "10.88.88.2";
      allowedIPs = [
        "10.88.88.1/32"
        "10.88.88.3/32"
        "10.88.88.6/32"
        "10.88.88.20/32"
        "10.88.88.21/32"
        "10.88.88.22/32"
        "10.88.88.23/32"
        "10.88.88.24/32"
        "10.88.88.201/32"
        "192.168.22.0/24"
        "192.168.42.0/24"
        "192.168.88.0/24"
        "192.168.98.0/24"
        "192.168.99.0/24"
      ];
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
