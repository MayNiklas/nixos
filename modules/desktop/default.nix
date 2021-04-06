{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.desktop;
in {

  imports = [ ../../users/nik.nix ../../users/root.nix ];

  options.mayniklas.desktop = {
    enable = mkEnableOption "Enable the default desktop configuration";
    homeConfig = mkOption {
       type = types.attrs;
       default = null;
    };
  };

  config = mkIf cfg.enable {

    home-manager.users.nik = cfg.homeConfig;

  };
}

