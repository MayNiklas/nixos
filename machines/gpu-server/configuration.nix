{ self, config, pkgs, lib, whisper-api, ... }:

{

  imports =
    [

      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      whisper-api.nixosModules.whisper_api

    ];

  home-manager.users.nik = {
    home.packages = with pkgs; [
      glances
    ];
  };

  mayniklas = {
    docker.enable = true;
    grub.enable = true;
    locale.enable = true;
    metrics = {
      node = {
        enable = true;
        flake = true;
      };
    };
    nvidia = {
      enable = true;
      beta-driver = true;
    };
    openssh.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
    user = {
      nik.enable = true;
      root.enable = true;
    };
    zsh.enable = true;
  };

  virtualisation.oci-containers = {
    containers.whisper_api = {
      autoStart = true;
      image = "mayniklas/whisper_api:latest";
      ports = [ "3001:3001" ];
      extraOptions = [ "--gpus" "all" ];
      environment = {
        "PRELOAD" = "true";
        "PORT" = "3001";
      };
    };
  };

  # Why is this needed?
  # For some reason, stopping the systemd service does not stop the container.
  # Still: fixes my problem.
  systemd.services.docker-whisper_api = {
    preStop = "${pkgs.docker}/bin/docker stop whisper_api";
  };

  # services.whisper_api = {
  #   enable = true;
  #   preload = true;
  #   listen = "0.0.0.0";
  #   port = 3001;
  #   openFirewall = true;
  # };

  # Lower GPU power consumption on newer kernels?
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  networking = {
    hostName = "gpu-server";
    firewall = {
      allowedTCPPorts = [
        9100
        9115
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}





