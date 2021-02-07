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
    ../../modules/locale.nix
    ../../modules/hosts.nix
    ../../modules/openssh.nix
    ../../modules/virtualization.nix
    # ../../modules/plex.nix
  ];

  networking = {
    hostName = "the-bus";
    nameservers = [ "192.168.5.10" "192.168.5.1" "1.1.1.1" ];
    networkmanager.enable = true;
  };

  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
    };
    cleanTmpDir = true;
  };

  environment.systemPackages = with pkgs; [
    bash-completion
    git
    nixfmt
    wget
    htop
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
