{ config, lib, pkgs, ... }: {

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  home-manager.users."${config.mayniklas.home-manager.username}" = {
    home.packages = with pkgs; [ ];
  };

  mayniklas = {
    docker = { enable = true; };
    metrics = {
      node = {
        enable = true;
        flake = true;
      };
    };
    server = {
      enable = true;
      home-manager = true;
    };
    nvidia.enable = true;
  };

  lollypops.deployment = {
    local-evaluation = false;
    ssh = {
      user = "root";
      host = "192.168.5.241";
    };
  };

  environment.systemPackages = with pkgs; [ powertop ];

  networking = {
    hostName = "fitz";
    networkmanager.enable = true;
  };

  system.stateVersion = "23.05";

}
