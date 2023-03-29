{ self, config, pkgs, lib, whisper-api, ... }:

{

  imports =
    [

      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # include packages from flake inputs
      {
        nixpkgs.overlays = [
          (self: super: {
            whisper_api = whisper-api.packages.${pkgs.system}.whisper_api_withCUDA;
          })
        ];
      }

    ];

  home-manager.users.nik = {
    home.packages = with pkgs; [
      # my packages
      whisper_api

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
    nvidia = { enable = true; };
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

  ### WHISPER_API
  # systemd.services.whisper_api = {
  #   description = "A whisper_api";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = lib.mkMerge [
  #     {
  #       User = "whisper_api";
  #       Group = "whisper_api";
  #       WorkingDirectory = "${pkgs.whisper_api.src}";
  #       ExecStart = "${pkgs.whisper_api}/bin/whisper_api";
  #       Restart = "on-failure";
  #     }
  #   ];
  # };

  # users.users = {
  #   whisper_api = {
  #     isSystemUser = true;
  #     createHome = true;
  #     home = "/var/lib/whisper_api";
  #     group = "whisper_api";
  #     description = "whisper_api system user";
  #   };
  # };

  # users.groups = {
  #   whisper_api = { };
  # };
  ###

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  networking = {
    hostName = "gpu-server";
    firewall = {
      allowedTCPPorts = [ 3001 9100 9115 ];
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
