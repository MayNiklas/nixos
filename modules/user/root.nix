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
          sha256 = "174dbx0kkrfdfdjswdny25nf7phgcb9k8i6z3rqqcy9l24f8xcp3";
        })
      ];
    };
  };
}
