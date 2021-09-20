{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
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

  nix.allowedUsers = [ "julian" ];
}
