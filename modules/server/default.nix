{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.server;
in {

  imports = [ ../../users/nik.nix ../../users/root.nix ];

  options.mayniklas.server = {
    enable = mkEnableOption "Enable the default server configuration";
    homeConfig = mkOption {
       type = types.attrs;
       default = null;
    };
  };

  config = mkIf cfg.enable {

    home-manager.users.nik = cfg.homeConfig;

  };
}

