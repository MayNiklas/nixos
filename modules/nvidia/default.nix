{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.nvidia;
in
{

  options.mayniklas.nvidia = {
    enable = mkEnableOption "activate nvidia";
    beta-driver = mkEnableOption "use nvidia-beta driver";
  };

  config = mkIf cfg.enable {

    services.xserver = { videoDrivers = [ "nvidia" ]; };

    hardware = {
      opengl.enable = true;
      opengl.driSupport32Bit = mkIf config.virtualisation.docker.enable true;
      # use nvidia-beta driver when beta-driver is enabled
      nvidia.package =
        mkIf cfg.beta-driver config.boot.kernelPackages.nvidiaPackages.beta;
    };

    # when docker is enabled, enable nvidia-docker
    virtualisation.docker.enableNvidia = mkIf config.virtualisation.docker.enable true;

    environment.systemPackages = with pkgs; [ nvtop ];

    nixpkgs.config = {
      # allow nvidia-x11 and nvidia-settings to be installed (unfree)
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [ "nvidia-x11" "nvidia-settings" ];
      # build packages with cudaSupport
      cudaSupport = true;
    };

  };

}
