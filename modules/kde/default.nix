{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.kde;
in {

  options.mayniklas.kde = {
    enable = mkEnableOption "activate kde" // { default = true; };
  };

  config = mkIf cfg.enable {

    # Enable the Plasma 5 Desktop Environment.
    services.xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      layout = "de";
      xkbOptions = "eurosign:e";
    };
  };
}