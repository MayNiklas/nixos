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

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
      gnome-music
      epiphany # web browser
      geary # email reader
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # Help view
      gnome-initial-setup
    ]) ++ (with pkgs.gnome; [
    ]);

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnomeExtensions.appindicator
      # gnomeExtensions.zoom-wayland-extension
    ];

    services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  };
}
