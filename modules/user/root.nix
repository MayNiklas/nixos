{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.user.root;
in {

  options.mayniklas.user.root = {
    enable = mkEnableOption "activate user root";
  };

  config = mkIf cfg.enable {
    users.users.root = {
      openssh.authorizedKeys.keyFiles = [
        (pkgs.fetchurl {
          url = "https://github.com/mayniklas.keys";
          hash = "sha256-eBO4j3NA/Jh01la5DZPwkl1r4tb0RKz7BNvhTBlH3Sk=";
        })
      ];
    };
  };
}
