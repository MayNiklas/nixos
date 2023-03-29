{ self, config, pkgs, lib, ... }:

{

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

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

  nixpkgs.config = {
    # cudaSupport = true;
  };

  networking = {
    hostName = "gpu-server";
    firewall = {
      allowedTCPPorts = [ 9100 9115 ];
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
