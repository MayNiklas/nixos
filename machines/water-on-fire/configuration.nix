# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Users
    ../../users/nik.nix
    ../../users/root.nix

    # Modules
    ../../modules/grub-luks.nix
    ../../modules/bluetooth.nix
    ../../modules/locale.nix
    ../../modules/networking.nix
    ../../modules/nix-common.nix
    ../../modules/nvidia.nix
    ../../modules/openssh.nix
    ../../modules/options.nix
    ../../modules/hosts.nix
    ../../modules/sound.nix
    ../../modules/docker.nix
    ../../modules/xserver.nix
    ../../modules/yubikey.nix
  ];

  mainUser = "nik";
  mainUserHome = "${config.users.extraUsers.${config.mainUser}.home}";

  # Get UUID from blkid /dev/sda2
  mayniklas = {
    grub-luks = {
      enable = true;
      uuid = "ea8b02e5-d2ee-44f8-a056-c55fba0d5c93";
    };
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
