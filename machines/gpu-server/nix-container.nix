{ config, nixpkgs-unstable, ... }: {
  containers = {
    # nixos-container root-login nvidia
    # systemctl status container@nvidia
    nvidia = {
      autoStart = true;
      ephemeral = true;
      nixpkgs = nixpkgs-unstable;
      bindMounts = {
        "/run/opengl-driver/lib" = {
          hostPath = "/run/opengl-driver/lib";
          isReadOnly = false;
        };
      };
      allowedDevices = [
        {
          modifier = "rw";
          node = "/dev/nvidia0";
        }
        {
          modifier = "rw";
          node = "/dev/nvidiactl";
        }
      ];
      config = { config, pkgs, ... }: {

        environment.systemPackages = with pkgs; [
          (pkgs.python3.withPackages
            (p: with p; [
              torchWithCuda
            ]))
          htop
          nvtop
          wget
          openai-whisper
        ];
        services.xserver.videoDrivers = [ "nvidia" ];
        nixpkgs.config = {
          allowUnfree = true;
          cudaSupport = true;
        };
        system.stateVersion = "23.05";

      };
    };
  };
}
