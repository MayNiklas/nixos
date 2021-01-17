{ config, pkgs, lib, ... }: {

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.systemPackages = with pkgs; [ docker-compose ];

  virtualisation.docker.enable = true;

}
