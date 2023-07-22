{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mayniklas.programs.foot;
in
{
  options.mayniklas.programs.foot.enable =
    mkEnableOption "enable foot";

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      inconsolata-nerdfont # Fallback Nerd Font to provide special glyphs
    ];

    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          dpi-aware = "yes";
          term = "xterm-256color";
          # font = "Berkeley Mono:size=11";
        };
        scrollback = {
          lines = 10000;
        };
        cursor = {
          style = "beam";
          blink = "yes";
        };
        colors = {
          # alpha=1.0
          background = "${config.pinpox.colors.Black}";
          foreground = "${config.pinpox.colors.White}";
          ## Normal/regular colors (color palette 0-7)
          regular0 = "${config.pinpox.colors.Black}"; # black
          regular1 = "${config.pinpox.colors.Red}"; # red
          regular2 = "${config.pinpox.colors.Green}"; # green
          regular3 = "${config.pinpox.colors.Yellow}"; # yellow
          regular4 = "${config.pinpox.colors.Blue}"; # blue
          regular5 = "${config.pinpox.colors.Magenta}"; # magenta
          regular6 = "${config.pinpox.colors.Cyan}"; # cyan
          regular7 = "${config.pinpox.colors.White}"; # white
          ## Bright colors (color palette 8-15)
          bright0 = "${config.pinpox.colors.BrightBlack}"; # black
          bright1 = "${config.pinpox.colors.BrightRed}"; # red
          bright2 = "${config.pinpox.colors.BrightGreen}"; # green
          bright3 = "${config.pinpox.colors.BrightYellow}"; # yellow
          bright4 = "${config.pinpox.colors.BrightBlue}"; # blue
          bright5 = "${config.pinpox.colors.BrightMagenta}"; # magenta
          bright6 = "${config.pinpox.colors.BrightCyan}"; # cyan
          bright7 = "${config.pinpox.colors.BrightWhite}"; # white
        };
      };
    };

  };
}
