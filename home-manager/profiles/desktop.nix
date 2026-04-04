{
  pkgs,
  homeManagerModules,
  ...
}:
{

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
      nix-init
      nix-tree
      nixpkgs-review
      nmap
      nvtopPackages.full
      kdePackages.okular
      # orca-slicer
      pciutils
      screen
      signal-desktop
      speedtest-cli
      spotify
      sublime-merge
      sublime3
      telegram-desktop
      # teamspeak_client
      thunderbird-bin
      unzip
      virt-manager
      wget
      vlc
      thunar
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
      development.enable = true;
      direnv.enable = true;
      foot.enable = true;
      git.enable = true;
      gtk.enable = true;
      kubernetes.enable = true;
      python.enable = true;
      tmux.enable = true;
      vim.enable = true;
      vscode.enable = true;
      kanshi.enable = true;
      mako.enable = true;
      wlsunset.enable = true;
      wofi.enable = true;
      zellij.enable = true;
      zsh.enable = true;
    };
    services.vscode-remote-ssh = {
      enable = true;
      claude = true;
    };
  };

  services.gnome-keyring = {
    enable = true;
  };

  # Imports
  imports = [
    ./common.nix
    ../colorscheme.nix
  ]
  ++ builtins.attrValues homeManagerModules;

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio;
    plugins = [ ];
  };

}
