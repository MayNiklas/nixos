# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  mainUser = "nik";
  mainUserHome = "${config.users.extraUsers.${config.mainUser}.home}";
  nasIP = "192.168.5.10";

  mayniklas = {
    bluetooth = { enable = true; };
    docker = { enable = true; };
    hosts = { enable = true; };
    sound = { enable = true; };
    yubikey = { enable = true; };
    # Get UUID from blkid /dev/sda2
    grub-luks = {
      enable = true;
      uuid = "ea8b02e5-d2ee-44f8-a056-c55fba0d5c93";
    };
    nix-common = { enable = true; };
    nvidia = { enable = true; };
    openssh = { enable = true; };
    xserver = { enable = true; };
    zsh = { enable = true; };
  };

  networking = { hostName = "water-on-fire"; };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ansible
    bash-completion
    git
    nixfmt
    python
    wget
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
