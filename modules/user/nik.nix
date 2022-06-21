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
          hash = "sha256-N4qner8Ss2APBjqbIIFFZSDIKsyuQTcRB0heluwC0vo=";
        })
      ];
    };
    nix.allowedUsers = [ "nik" ];
  };
}
