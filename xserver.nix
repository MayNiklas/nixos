{ config, pkgs, lib, ... }: {
  # Enable the Plasma 5 Desktop Environment.
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    videoDrivers = [ "nvidia" ];
    layout = "de";
    xkbOptions = "eurosign:e";
  };
  nixpkgs = { config.allowUnfree = true; };
}
