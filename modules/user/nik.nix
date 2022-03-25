{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.user.nik;
in {

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
          sha256 = "174dbx0kkrfdfdjswdny25nf7phgcb9k8i6z3rqqcy9l24f8xcp3";
        })
      ];
    };
    nix.allowedUsers = [ "nik" ];
  };
}
