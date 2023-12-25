{ pkgs, lib, config, ... }:
with lib;
let cfg = config.mayniklas.programs.zellij;
in
{
  options.mayniklas.programs.zellij.enable =
    mkEnableOption "zellij terminal mutliplexer";

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      (pkgs.callPackage ./start-zellij.nix { })
    ];

    programs.zellij = {
      enable = true;
      settings = {
        theme = "custom";
        themes.custom = {
          fg = "#${config.pinpox.colors.White}";
          bg = "#${config.pinpox.colors.Black}";
          black = "#${config.pinpox.colors.Black}";
          red = "#${config.pinpox.colors.Red}";
          green = "#${config.pinpox.colors.Green}";
          yellow = "#${config.pinpox.colors.BrightYellow}";
          blue = "#${config.pinpox.colors.Blue}";
          magenta = "#${config.pinpox.colors.Magenta}";
          cyan = "#${config.pinpox.colors.Cyan}";
          white = "#${config.pinpox.colors.White}";
          orange = "#${config.pinpox.colors.Yellow}";
        };
      };
    };

  };
}
