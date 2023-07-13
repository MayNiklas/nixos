{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.gnome;
in
{

  options.mayniklas.gnome = { enable = mkEnableOption "activate gnome"; };

  config = mkIf cfg.enable {

    services.xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    services.gnome = {
      core-developer-tools.enable = true;
      core-os-services.enable = true;
      core-shell.enable = true;
      core-utilities.enable = true;
      gnome-settings-daemon.enable = true;
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    environment.systemPackages = with pkgs; [ gnomeExtensions.appindicator ];
    services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  };
}
