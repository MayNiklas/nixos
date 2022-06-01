{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.devolopment;
in
{
  options.mayniklas.programs.firefox.enable = mkEnableOption "enable firefox";

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-bin;
      profiles = {
        nik = {
          isDefault = true;
          settings = {
            "browser.startup.homepage" = "https://github.com/MayNiklas";
            "devtools.theme" = "dark";
          };
        };
      };
    };
  };
}
