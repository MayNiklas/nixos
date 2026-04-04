{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.mayniklas.programs.mako;
  c = config.pinpox.colors;
in
{
  options.mayniklas.programs.mako.enable = mkEnableOption "enable mako";

  config = mkIf cfg.enable {

    services.mako = {
      enable = true;
      settings = {
        font = "Berkeley Mono 11";
        background-color = "#${c.Black}";
        text-color = "#${c.White}";
        border-color = "#${c.Blue}";
        border-size = 2;
        border-radius = 3;
        padding = "10";
        margin = "10";
        default-timeout = 5000;
        group-by = "app-name";
        max-visible = 3;

        "urgency=low" = {
          border-color = "#${c.BrightBlack}";
        };
        "urgency=critical" = {
          border-color = "#${c.Red}";
          default-timeout = 0;
        };
      };
    };

  };
}
