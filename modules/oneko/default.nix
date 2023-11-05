{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.oneko;
in
{
  options.mayniklas.oneko = {
    enable = mkEnableOption "activate oneko";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ oneko ];
    systemd.user.services.oneko = {
      description = "oneko";
      serviceConfig.PassEnvironment = "DISPLAY";
      serviceConfig.ExecStart = "oneko -sakura";
      path = with pkgs; [ oneko ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
