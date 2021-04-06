{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.nvidia;
in {

  options.mayniklas.nvidia = { enable = mkEnableOption "activate nvidia"; };

  config = mkIf cfg.enable {
    services.xserver = { videoDrivers = [ "nvidia" ]; };
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "nvidia-x11" "nvidia-settings" ];
  };

}
