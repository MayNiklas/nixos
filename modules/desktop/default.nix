{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.desktop;
in {

  imports = [ ../../users/nik.nix ../../users/root.nix ];

  options.mayniklas.desktop = {
    enable = mkEnableOption "Enable the default desktop configuration";
    homeConfig = mkOption {
      type = types.attrs;
      default = null;
      description = ''
        Documentation placeholder
      '';
    };
  };

  config = mkIf cfg.enable {

    home-manager.users.nik = cfg.homeConfig;

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
        disable-cache = true;
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

