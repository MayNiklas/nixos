# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, modulesPath, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    "${toString modulesPath}/virtualisation/vmware-image.nix"

    # Users
    ../../users/nik.nix
    ../../users/root.nix

    # Modules
    ../../modules/locale.nix
    ../../modules/nix-common.nix
    ../../modules/openssh.nix
  ];

  networking.hostName = "nixos-vm";

  environment.systemPackages = with pkgs; [
    bash-completion
    git
    nixfmt
    wget
    htop
  ];

  virtualisation.vmware.guest.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
