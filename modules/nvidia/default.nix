{ lib, pkgs, config, flake-self, ... }:
with lib;
let
  cfg = config.mayniklas.nvidia;

  withCUDA = import flake-self.inputs.nixpkgs {
    system = "${pkgs.system}";
    config = { allowUnfree = true; cudaSupport = true; };
  };

  cudaoverlay = (self: super: {
    # access overlay by using pkgs.withCUDA.<package>
    inherit withCUDA;
    # packages that should be built with CUDA support on NVIDIA systems
    inherit (withCUDA)
      nvtop
      ;
  });

in
{

  options.mayniklas.nvidia = {
    enable = mkEnableOption "activate nvidia";
    cudaSupport = mkEnableOption "enable CUDA support";
    beta-driver = mkEnableOption "use nvidia-beta driver";
  };

  config = mkIf cfg.enable {

    nixpkgs = {
      config.cudaSupport = mkIf cfg.cudaSupport true;
      overlays = [ cudaoverlay ];
    };

    home-manager.users = mkIf config.mayniklas.home-manager.enable {
      "${config.mayniklas.home-manager.username}" = {
        nixpkgs = {
          config.cudaSupport = mkIf cfg.cudaSupport true;
          overlays = [ cudaoverlay ];
        };
      };
    };

    services.xserver = {
      videoDrivers = [ "nvidia" ];
    };

    hardware = {

      opengl = {
        enable = true;
        driSupport32Bit = true;
      };

      nvidia = {
        # use nvidia-beta driver when beta-driver is enabled
        package = mkIf cfg.beta-driver config.boot.kernelPackages.nvidiaPackages.beta;

        powerManagement.enable = true;
      };

    };

    # when docker is enabled, enable nvidia-docker
    virtualisation.docker.enableNvidia = mkIf config.virtualisation.docker.enable true;

    environment.systemPackages = with pkgs; [ nvtop ];

    nixpkgs.config = {

      # allow nvidia-x11 and nvidia-settings to be installed (unfree)
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "cudatoolkit"
          "nvidia-persistenced"
          "nvidia-settings"
          "nvidia-x11"
        ];

      # note:
      # cudaSupport = true; would build all packages that offer cuda with CUDA support
      # Unfortunately, this would have some big drawbacks:
      # - CUDA stuff is not in cache.nixos.org (since unfree)
      # - would have to build everything from source
      # - CUDA stuff is not build by Hydra -> builds tend to fail more often since it's not tested
      # - packages like webkitgtk receive a lot of updates, and take a long time to build!
      # -> CUDA support enabled for the whole system does not seem to be practical
      # -> we should find a solution to enable CUDA support for specific packages only!
      # -> many packages offer different versions of the same package, one with CUDA support, one without
      # cudaSupport = true;

    };

  };

}
