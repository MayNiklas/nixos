{ config, pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [ docker-compose ];

  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  users.extraUsers.${config.mainUser}.extraGroups = [ "docker" ];

}
