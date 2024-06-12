{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.oneko;
in
{
  options.mayniklas.oneko = {
    enable = mkEnableOption "release oneko";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ oneko ];
    systemd.user.services.oneko = {
      enable = true;
      description = "oneko";
      serviceConfig.PassEnvironment = "DISPLAY";
      serviceConfig.ExecStart = "${pkgs.oneko}/bin/oneko -sakura";
      path = with pkgs; [ oneko ];
      wantedBy = [ "graphical-session.target" ];
    };
  };
}
