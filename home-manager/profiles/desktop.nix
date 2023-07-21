{ config, pkgs, lib, ... }: {

  # Install these packages for my user
  home.packages =
    let
      drone-gen = pkgs.callPackage ../../packages/drone-gen { };
    in
    with pkgs; [
      _1password-gui
      asciinema
      atom
      cura
      dconf
      discord
      dolphin
      drone-cli
      filezilla
      firefox
      glances
      gnome.gnome-system-monitor
      gparted
      h
      htop
      hugo
      iperf3
      nmap
      nvtop
      obs-studio
      okular
      signal-desktop
      speedtest-cli
      spotify
      sublime-merge
      sublime3
      tdesktop
      teamspeak_client
      thunderbird-bin
      unzip
      vagrant
      virt-manager
      vlc
      xfce.thunar
      youtube-dl
      zoom-us

      drone-gen
    ];

  mayniklas = {
    programs = {
      alacritty.enable = true;
      chromium.enable = true;
      devolopment.enable = true;
      foot.enable = true;
      git.enable = true;
      gtk.enable = true;
      # i3.enable = true;
      rofi.enable = true;
      tmux.enable = true;
      vim.enable = true;
      vscode.enable = true;
      zsh.enable = true;
    };
  };

  services.gnome-keyring = { enable = true; };

  # Imports
  imports = [
    ../colorscheme.nix
    ../modules/alacritty
    ../modules/chromium
    ../modules/devolopment
    ../modules/foot
    ../modules/git
    ../modules/gtk
    ../modules/i3
    ../modules/nvim
    ../modules/rofi
    ../modules/sway
    ../modules/tmux
    ../modules/vs-fix
    ../modules/vscode
    ../modules/waybar
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
