{ config, pkgs, ... }:

let darknet = pkgs.callPackage ./packages/darknet { };

in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
    discord
    darknet
    dolphin
    drone-cli
    firefox
    gcc
    glances
    gnome3.dconf
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
    ./modules/chromium.nix
    ./modules/devolopment.nix
    ./modules/git.nix
    ./modules/gtk.nix
    ./modules/i3.nix
    ./modules/alacritty.nix
    ./modules/rofi.nix
    ./modules/vim.nix
    ./modules/vscode.nix
    ./modules/zsh.nix
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
