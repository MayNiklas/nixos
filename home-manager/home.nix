{ config, pkgs, ... }:
let

in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.command-not-found.enable = true;

  mayniklas = {
    programs.vim.enable = true;
    programs.vscode.enable = true;
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nik";
  home.homeDirectory = "/home/nik";

  # Allow "unfree" licenced packages
  nixpkgs.config = { allowUnfree = true; };

  # Install these packages for my user
  home.packages = with pkgs; [
    _1password-gui
    atom
    discord
    dolphin
    drone-cli
    firefox
    gcc
    glances
    gnome3.dconf
    gparted
    htop
    hugo
    iperf3
    nmap
    nvtop
    obs-studio
    signal-desktop
    spotify
    sublime-merge
    sublime3
    teamspeak_client
    tdesktop
    thunderbird-bin
    unzip
    vagrant
    vim
    virt-manager
    vlc
    youtube-dl
    zoom-us
  ];

  # Imports
  imports = [
    ./modules/chromium
    ./modules/devolopment
    ./modules/git
    ./modules/gtk
    ./modules/i3
    ./modules/alacritty
    ./modules/rofi
    ./modules/vim
    ./modules/vscode
    ./modules/zsh
  ];

  services.gnome-keyring = { enable = true; };

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
