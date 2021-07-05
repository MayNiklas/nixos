{ config, pkgs, lib, ... }: {
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
}
