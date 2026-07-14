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
          hash = "sha256-xxBytuV1e0Vv5AOVLMVh4zPe3JRYNvRrF/LHykfk064=";
        })
      ];
    };
  };
}
