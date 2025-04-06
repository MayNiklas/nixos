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
          hash = "sha256-eBO4j3NA/Jh01la5DZPwkl1r4tb0RKz7BNvhTBlH3Sk=";
        })
      ];
    };
    nix.settings = { allowed-users = [ "nik" ]; trusted-users = [ "nik" ]; };
  };
}
