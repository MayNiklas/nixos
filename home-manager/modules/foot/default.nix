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
      };
    };

  };
}
