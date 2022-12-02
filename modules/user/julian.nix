{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.user.julian;
in
{

  options.mayniklas.user.julian = {
    enable = mkEnableOption "activate user julian";
  };

  config = mkIf cfg.enable {
    users.users.julian = {
      isNormalUser = true;
      home = "/home/julian";
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [
        (pkgs.fetchurl {
          url = "https://github.com/building-from-source.keys";
          sha256 = "0z4jhi81ql6kq37gjfdkn192ilpp282ypri1ilhak9696hhs77p9";
        })
      ];
    };
    nix.settings.allowed-users = [ "julian" ];
  };
}
