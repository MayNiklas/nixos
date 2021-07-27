{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.nvidia;
in {

  options.mayniklas.nvidia = {
    enable = mkEnableOption "activate nvidia";
    beta-driver = mkEnableOption "use nvidia-beta driver";
  };

  config = mkIf cfg.enable {
    services.xserver = { videoDrivers = [ "nvidia" ]; };
    hardware.nvidia.package =
      mkIf cfg.beta-driver config.boot.kernelPackages.nvidiaPackages.beta;
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "nvidia-x11" "nvidia-settings" ];
  };

}
