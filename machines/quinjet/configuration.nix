# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  mainUser = "nik";
  mainUserHome = "${config.users.extraUsers.${config.mainUser}.home}";
  nasIP = "192.168.5.10";

  mayniklas = {
    yubikey = { enable = true; };
    plex = { enable = true; };
    pihole = {
      enable = true;
      port = "8080";
    };
    librespeedtest = {
      enable = true;
      port = "8000";
    };
    plex = { enable = true; };
  };

  networking = { hostName = "quinjet"; };

  environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
