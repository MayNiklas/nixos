{ config, pkgs, ... }:
let

in {
  programs.home-manager.enable = true;

  home.username = "marek";
  home.homeDirectory = "/home/marek";

  nixpkgs.config = { allowUnfree = true; };

  home.packages = with pkgs; [
    dolphin
    firefox
    glances
    gparted
    htop
    thunderbird-bin
    unzip
  ];

  services.gnome-keyring = { enable = true; };

  home.stateVersion = "21.03";
}
