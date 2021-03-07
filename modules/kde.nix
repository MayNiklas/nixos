{ config, pkgs, lib, ... }: {
  # Enable the Plasma 5 Desktop Environment.
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    layout = "de";
    xkbOptions = "eurosign:e";
  };
}
