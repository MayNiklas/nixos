{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mayniklas.programs.waybar;
in
{
  options.mayniklas.programs.waybar.enable = mkEnableOption "enable waybar";
  config = mkIf cfg.enable {

    programs.waybar = {
      enable = true;
    };

  };
}
