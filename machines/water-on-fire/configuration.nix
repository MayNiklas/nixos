# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Users
    ./users/nik.nix
    ./users/root.nix

    # Modules
    # ./modules/kde-plasma.nix
    # ./modules/i3.nix    
    ./modules/bootloader.nix
    ./modules/bluetooth.nix    
    ./modules/locale.nix
    ./modules/networking.nix
    ./modules/openssh.nix
    ./modules/sound.nix
    ./modules/virtualization.nix
    ./modules/xserver.nix
    ./modules/yubikey.nix
  ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ansible
    bash-completion
    git
    nixfmt
    python
    wget
    pavucontrol
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
