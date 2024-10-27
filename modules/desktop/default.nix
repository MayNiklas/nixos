{ lib, pkgs, config, inputs, ... }:
with lib;
let cfg = config.mayniklas.desktop;
in
{

  options.mayniklas.desktop = {
    enable = mkEnableOption "Enable the default desktop configuration";
    home-manager = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable home-manager for this desktop
      '';
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      bash-completion
      dnsutils
      file
      git
      nixfmt
      usbutils
      wget
    ];

    mayniklas = {
      user = {
        nik = { enable = true; };
        root.enable = true;
      };
      home-manager = mkIf cfg.home-manager {
        enable = true;
        profile = "desktop";
      };
      bluetooth.enable = true;
      docker.enable = true;
      fonts.enable = true;
      sound.enable = true;
      locale.enable = true;
      # hosts.enable = true;
      networking.enable = true;
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
      package = lib.mkForce pkgs.gnome.gvfs;
    };

  };
}

