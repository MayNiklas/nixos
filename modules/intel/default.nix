{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.intel;
in
{

  options.mayniklas.intel = {
    enable = mkEnableOption "activate intel";
  };

  config = mkIf cfg.enable {

    # tools to watch iGPU usage
    environment.systemPackages = with pkgs; [
      intel-gpu-tools
      nvtop
      powertop
      config.boot.kernelPackages.turbostat
    ];

    # I have to check, which of the following options are really needed
    # for hardware transcoding to work
    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        extraPackages = with pkgs; [
          intel-media-driver
          libvdpau-va-gl
          vaapiIntel
          vaapiVdpau
        ];
      };
    };

    # load i915 kernel module
    boot.initrd.kernelModules = [ "i915" ];

  };

}
