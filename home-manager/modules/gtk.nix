{ config, pkgs, lib, ... }: {
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
}
