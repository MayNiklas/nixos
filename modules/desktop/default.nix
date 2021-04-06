{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.desktop;
in {

  imports = [ ../../users/nik.nix ../../users/root.nix ];

  options.mayniklas.desktop = {
    enable = mkEnableOption "Enable the default desktop configuration";
  };

  config = mkIf cfg.enable {

  };
}

