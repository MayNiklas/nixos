{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.networking;
in
{

  options.mayniklas.networking = {
    enable = mkEnableOption "activate networking";
  };

  config = mkIf cfg.enable {

    networking = {
      # Enable networkmanager
      networkmanager.enable = true;
    };
    users.extraUsers.${config.mayniklas.var.mainUser}.extraGroups =
      [ "networkmanager" ];
  };

}
