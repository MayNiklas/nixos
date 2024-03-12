{ config, pkgs, lib, ... }: {

  # Install these packages for my user
  home.packages =
    let
      preview-update = pkgs.callPackage ../../packages/preview-update { };
    in
    with pkgs; [
      _1password-gui
      asciinema
      bambu-studio
      cura
      dconf
      discord
      dolphin
      drone-cli
      etcher
      filezilla
      firefox
      glances
      gnome.gnome-system-monitor
      gparted
      h
      htop
      hugo
      iperf3
      minicom
      nil
      nix-top
      nix-tree
      nmap
      nvtop
      okular
      ondsel
      orca-slicer
      preview-update
      screen
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
      (vlc.override { libbluray = libbluray.override { withAACS = true; withBDplus = true; }; })
      xfce.thunar
      xournalpp
      youtube-dl
      zoom-us

      mayniklas.gen-module
      mayniklas.set-performance
    ];

  mayniklas = {
    programs = {
      alacritty.enable = true;
      ansible.enable = true;
      chromium.enable = true;
      devolopment.enable = true;
      direnv.enable = true;
      foot.enable = true;
      git.enable = true;
      gtk.enable = true;
      tmux.enable = true;
      vim.enable = true;
      vscode.enable = true;
      wofi.enable = true;
      zsh.enable = true;
    };
  };

  services.gnome-keyring = { enable = true; };

  # Imports
  imports = [
    ../colorscheme.nix
    ../modules/alacritty
    ../modules/ansible
    ../modules/chromium
    ../modules/devolopment
    ../modules/direnv
    ../modules/foot
    ../modules/git
    ../modules/gtk
    ../modules/i3
    ../modules/nvim
    ../modules/sway
    ../modules/swaylock
    ../modules/tmux
    ../modules/vs-fix
    ../modules/vscode
    ../modules/waybar
    ../modules/wofi
    ../modules/zsh
  ];

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio;
    plugins = with pkgs.obs-studio-plugins; [ ];
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
