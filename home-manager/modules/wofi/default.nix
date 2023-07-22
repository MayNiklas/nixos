{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mayniklas.programs.wofi;
in
{
  options.mayniklas.programs.wofi.enable = mkEnableOption "enable wofi";

  config = mkIf cfg.enable {

    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.wofi.enable
    programs.wofi = {
      enable = true;
      settings = {
        location = "bottom-right";
        allow_markup = true;
        width = 500;
      };
    };

  };
}
