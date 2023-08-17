{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.user.nik;
in
{

  options.mayniklas.user.nik = { enable = mkEnableOption "activate user nik"; };

  config = mkIf cfg.enable {
    users.users.nik = {
      isNormalUser = true;
      home = "/home/nik";
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [
        (pkgs.fetchurl {
          url = "https://github.com/mayniklas.keys";
          hash = "sha256-QW7XAqj9EmdQXYEu8EU74eFWml5V0ALvbQOnjk8ce/U=";
        })
      ];
    };
    nix.settings = { allowed-users = [ "nik" ]; trusted-users = [ "nik" ]; };
  };
}
