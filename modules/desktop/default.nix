{ lib, pkgs, config, inputs, self-overlay, overlay-unstable, ... }:
with lib;
let cfg = config.mayniklas.desktop;
in {

  imports = [ ../../users/nik.nix ../../users/root.nix ];

  options.mayniklas.desktop = {
    enable = mkEnableOption "Enable the default desktop configuration";
    home-manager = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable home-manager for this desktop
      '';
    };
    git = mkOption {
      type = types.bool;
      default = true;
      description = ''
        enable git for this desktop
      '';
    };
    gtk = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable gtk for this desktop
      '';
    };
    vim = mkOption {
      type = types.bool;
      default = true;
      description = ''
        enable vim for this desktop
      '';
    };
    rofi = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable rofi for this desktop
      '';
    };
    i3 = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable i3 for this desktop
      '';
    };
  };

  config = mkIf cfg.enable {

    home-manager.users.nik = mkIf cfg.home-manager {

      # Pass inputs to home-manager modules
      _module.args.flake-inputs = inputs;

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
      programs.command-not-found.enable = true;
      home.username = "nik";
      home.homeDirectory = "/home/nik";
      # Allow "unfree" licenced packages
      nixpkgs.config = { allowUnfree = true; };
      services.gnome-keyring = { enable = true; };

      mayniklas = {
        programs = {
          alacritty.enable = true;
          chromium.enable = true;
          devolopment.enable = true;
          git.enable = mkIf cfg.git true;
          gtk.enable = mkIf cfg.gtk true;
          rofi.enable = mkIf cfg.rofi true;
          i3.enable = mkIf cfg.i3 true;
          vim.enable = mkIf cfg.vim true;
          vscode.enable = true;
          zsh.enable = true;
        };
      };

      # Install these packages for my user
      home.packages = with pkgs; [
        _1password-gui
        atom
        cura
        darknet
        discord
        dolphin
        drone-cli
        filezilla
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
        xfce.thunar
        youtube-dl
        zoom-us
      ];

      imports = [
        ../../home-manager/modules/chromium
        ../../home-manager/modules/devolopment
        ../../home-manager/modules/git
        ../../home-manager/modules/gtk
        ../../home-manager/modules/i3
        ../../home-manager/modules/alacritty
        ../../home-manager/modules/rofi
        ../../home-manager/modules/vim
        ../../home-manager/modules/vscode
        ../../home-manager/modules/zsh
      ];

      home.stateVersion = "21.03";

    };

    environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

    mayniklas = {
      bluetooth.enable = true;
      docker.enable = true;
      fonts.enable = true;
      sound.enable = true;
      locale.enable = true;
      hosts.enable = true;
      nix-common = {
        enable = true;
        # disable-cache = true;
      };
      openssh.enable = true;
      yubikey.enable = true;
      zsh.enable = true;
    };

    programs.dconf.enable = true;

    # For user-space mounting things like smb:// and ssh:// in thunar etc. Dbus
    # is required.
    services.gvfs = {
      enable = true;
      # Default package does not support all protocols. Use the full-featured
      # gnome version
      package = lib.mkForce pkgs.gnome3.gvfs;
    };

  };
}

