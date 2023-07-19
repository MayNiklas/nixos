{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.sway;
in
{

  options.mayniklas.sway = {
    enable = mkEnableOption "activate sway";
  };

  config = mkIf cfg.enable {

    ### BEGIN HOME MANAGER CONFIGURATION ###

    home-manager.users.nik = {

      # Use sway desktop environment with Wayland display server
      wayland.windowManager.sway = {

        enable = true;
        wrapperFeatures.gtk = true;

        # Sway-specific Configuration
        config = {

          input = {
            "type:keyboard" = {
              xkb_layout = "de";
              xkb_numlock = "enabled";
            };
            "type:touchpad" = {
              click_method = "clickfinger";
              tap = "enabled";
            };
          };

          modifier = "Mod4";

          terminal = "${pkgs.alacritty}/bin/alacritty";
          menu = "${pkgs.wofi}/bin/wofi --show run";

          # Status bar(s)
          bars = [
            {
              fonts.size = 15.0;
              command = "${pkgs.waybar}/bin/waybar";
              position = "bottom";
            }
          ];

          # # Display device configuration
          # output = {
          #   DP-1 = {
          #     # Set HIDP scale (pixel integer scaling)
          #     scale = "1";
          #     pos = "3840 0";
          #   };
          #   DP-2 = {
          #     # Set HIDP scale (pixel integer scaling)
          #     scale = "1";
          #     pos = "0 0";
          #   };
          # };

        };
      };

      programs.zsh = {
        shellAliases = rec {
          # on NVIDIA systems, sway needs to be started with --unsupported-gpu
          # WLR_NO_HARDWARE_CURSORS=1 is needed for the mouse cursor to work
          sway = mkIf config.mayniklas.nvidia.enable "export WLR_NO_HARDWARE_CURSORS=1 && exec sway --unsupported-gpu";
        };
      };

      home.packages = with pkgs; [
        swaylock
        swayidle
        wl-clipboard
        mako
      ];

    };

    ### END HOME MANAGER CONFIGURATION ###

    # xdg-desktop-portal works by exposing a series of D-Bus interfaces
    # known as portals under a well-known name
    # (org.freedesktop.portal.Desktop) and object path
    # (/org/freedesktop/portal/desktop).
    # The portal interfaces include APIs for file access, opening URIs,
    # printing and others.
    services.dbus.enable = true;
    xdg = {
      mime.enable = true;
      icons.enable = true;
      portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
      };
    };

    security = {
      # Allow swaylock to unlock the computer for us
      pam.services.swaylock.text = "auth include login";
      polkit.enable = true;
      rtkit.enable = true;
    };

    users.extraUsers.${config.mayniklas.var.mainUser}.extraGroups = [ "video" "audio" ];

    hardware = {
      # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
      nvidia.modesetting.enable = mkIf config.mayniklas.nvidia.enable true;
    };

  };
}
