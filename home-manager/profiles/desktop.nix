{ config, pkgs, lib, ... }: {

  # Allow "unfree" licenced packages
  nixpkgs.config = { allowUnfree = true; };

  # Install these packages for my user
  home.packages = let
    drone-gen = pkgs.callPackage ../../packages/drone-gen { };
    vs-fix = pkgs.callPackage ../../packages/vs-fix { };
  in with pkgs; [
    _1password-gui
    atom
    cura
    dconf
    discord
    dolphin
    drone-cli
    filezilla
    firefox
    gcc
    glances
    gparted
    htop
    htop
    hugo
    iperf3
    iperf3
    nixfmt
    nixfmt
    nixpkgs-fmt
    nmap
    nvtop
    obs-studio
    signal-desktop
    spotify
    sublime-merge
    sublime3
    tdesktop
    teamspeak_client
    thunderbird-bin
    unzip
    unzip
    vagrant
    vim
    virt-manager
    vlc
    xfce.thunar
    youtube-dl
    zoom-us

    drone-gen
    vs-fix
  ];

  mayniklas = {
    programs = {
      alacritty.enable = true;
      chromium.enable = true;
      devolopment.enable = true;
      git.enable = true;
      gtk.enable = true;
      i3.enable = true;
      rofi.enable = true;
      vim.enable = true;
      vscode.enable = true;
      zsh.enable = true;
    };
  };

  services.gnome-keyring = { enable = true; };

  # Imports
  imports = [
    ../modules/alacritty
    ../modules/chromium
    ../modules/devolopment
    ../modules/git
    ../modules/git
    ../modules/gtk
    ../modules/i3
    ../modules/rofi
    ../modules/vim
    ../modules/vim
    ../modules/vs-fix
    ../modules/vscode
    ../modules/zsh
    ../modules/zsh
  ];

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
