{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.gtk;
in
{
  options.mayniklas.programs.gtk.enable = mkEnableOption "enable gtk";

  config = mkIf cfg.enable {
    # GTK settings
    gtk = {
      enable = true;

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "materia-theme";
        package = pkgs.materia-theme;
      };
      gtk3.extraConfig.gtk-cursor-theme-name = "breeze";
    };

    home.sessionVariables.GTK_THEME = "materia-theme";
  };
}
