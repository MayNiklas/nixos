{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.gnome;
in
{

  options.mayniklas.gnome = { enable = mkEnableOption "activate gnome"; };

  config = mkIf cfg.enable {

    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    environment.systemPackages = with pkgs; [ gnomeExtensions.appindicator ];
    services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  };
}
