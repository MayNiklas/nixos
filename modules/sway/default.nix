{ pkgs, lib, config, ... }:
with lib;
let cfg = config.mayniklas.sway;
in
{

  options.mayniklas.sway = {
    enable = mkEnableOption "activate sway";
  };

  config = mkIf cfg.enable {

    mayniklas = {
      wayland.enable = true;
      gnome.enable = mkForce false;
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd start-sway";
          user = "greeter";
        };
      };
    };

    home-manager.users."${config.mayniklas.home-manager.username}" = {
      mayniklas.programs = {
        sway.enable = true;
        swaylock.enable = true;
      };
      home.packages = [ ];
    };

  };

}
