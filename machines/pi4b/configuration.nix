{ self, ... }: {

  imports = [ ./hardware-configuration.nix ];

  mayniklas = {
    octoprint.enable = true;
    server = {
      enable = true;
      homeConfig = { imports = [ ../../home-manager/home-server.nix ]; };
    };
    system = "aarch64-linux";
    system-config = "aarch64-unknown-linux-gnu";
  };

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;

  boot.loader = {
    raspberryPi = {
      enable = true;
      version = 4;
    };
    # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
    grub.enable = false;
    # Enables the generation of /boot/extlinux/extlinux.conf
    generic-extlinux-compatible.enable = true;
  };

  networking = {
    hostName = "pi4b"; # Define your hostname.
    networkmanager = { enable = true; };
    wireless.enable = false;
  };

  system.stateVersion = "21.03";

}
