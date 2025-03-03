{ config, pkgs, lib, ... }: {

  # Install these packages for my user
  home.packages =
    # let
    #   # override vlc to enable bluray support
    #   vlc = (pkgs.vlc.override { libbluray = pkgs.libbluray.override { withAACS = true; withBDplus = true; }; });
    # in
    with pkgs; [
      _1password-gui
      asciinema
      bambu-studio
      dconf
      discord
      kdePackages.dolphin
      drone-cli
      element-desktop
      # etcher
      file
      filezilla
      firefox
      glances
      gnome-system-monitor
      gparted
      h
      htop
      hugo
      iperf3
      minicom
      nix-fast-build
      nix-tree
      nixpkgs-review
      nmap
      nvtopPackages.full
      kdePackages.okular
      ondsel
      # orca-slicer
      pciutils
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
      virt-manager
      wget
      vlc
      xfce.thunar
      xournalpp
      yt-dlp
      zoom-us

      mayniklas.check-updates
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
      kubernetes.enable = true;
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
    ./common.nix
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
    ../modules/kubernetes
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

}
