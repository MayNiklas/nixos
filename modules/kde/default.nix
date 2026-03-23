{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.kde;
in
{

  options.mayniklas.kde = { enable = mkEnableOption "activate kde"; };

  config = mkIf cfg.enable {

    # Enable the Plasma 6 Desktop Environment.
    services.xserver = {
      enable = true;
      xkb.layout = "de";
      xkb.options = "eurosign:e";
    };
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}
