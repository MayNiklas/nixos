{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.xfce;
in {

  options.mayniklas.xfce = { enable = mkEnableOption "activate xfce"; };

  config = mkIf cfg.enable {

    nixpkgs.config.pulseaudio = true;

    services.xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce.enable = true;
      };
      displayManager.defaultSession = "xfce";
    };

  };
}
