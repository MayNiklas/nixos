{ config, pkgs, ... }:
let

in {

  # Imports
  imports = [
    ./modules/chromium
    ./modules/devolopment
    ./modules/git
    # ./modules/gtk
    # ./modules/i3
    ./modules/alacritty
    # ./modules/rofi
    ./modules/vim
    ./modules/vscode
    ./modules/zsh
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
