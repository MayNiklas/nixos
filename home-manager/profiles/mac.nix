{ config, pkgs, ... }:

{

  mayniklas = {
    programs = {
      git.enable = true;
      vim.enable = true;
    };
  };

  # Imports
  imports = [
    ../modules/git
    ../modules/vim
  ];

  home.username = "nik";
  # for some reason I have to comment this out?
  # Should not be necessary, but I get an error otherwise
  # home.homeDirectory = "/Users/nik";

  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
