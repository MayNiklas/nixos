{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.user.nik.home-manager;

in {

  options.mayniklas.user.nik.home-manager = {
    desktop = mkEnableOption "activate headless home-manager profile for nik";
  };

  config = mkIf cfg.desktop {

    mayniklas.user.nik.home-manager.enable = true;

    home-manager.users.nik = {

      services.gnome-keyring = { enable = true; };

      mayniklas = {
        programs = {
          alacritty.enable = true;
          chromium.enable = true;
          devolopment.enable = true;
          gtk.enable = true;
          rofi.enable = true;
          i3.enable = true;
          vscode.enable = true;
        };
      };

      # Install these packages for my user
      home.packages = with pkgs; [
        _1password-gui
        atom
        cura
        discord
        dolphin
        drone-cli
        filezilla
        firefox
        gcc
        glances
        dconf
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
        xfce.thunar
        youtube-dl
        zoom-us
      ];

      imports = [
        ./modules/alacritty
        ./modules/chromium
        ./modules/devolopment
        ./modules/git
        ./modules/gtk
        ./modules/i3
        ./modules/rofi
        ./modules/vim
        ./modules/vs-fix
        ./modules/vscode
        ./modules/zsh
      ];

    };

  };
}
