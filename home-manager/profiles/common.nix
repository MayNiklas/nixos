{ config, pkgs, lib, ... }: {

  # Install these packages for my user
  home.packages = with pkgs; [
    attic-client
    nil
    nixd
    nixpkgs-fmt
  ];

  mayniklas = {
    programs = { };
  };


  # Include man-pages
  manual.manpages.enable = true;

  programs.command-not-found.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
