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

          keybindings =
            let
              inherit (config.home-manager.users.nik.wayland.windowManager.sway.config) modifier left down up right menu terminal;
            in
            {
              "${modifier}+Return" = "exec ${terminal}";
              "${modifier}+Shift+q" = "kill";
              "${modifier}+d" = "exec ${menu}";

              "${modifier}+${left}" = "focus left";
              "${modifier}+${down}" = "focus down";
              "${modifier}+${up}" = "focus up";
              "${modifier}+${right}" = "focus right";

              "${modifier}+Left" = "focus left";
              "${modifier}+Down" = "focus down";
              "${modifier}+Up" = "focus up";
              "${modifier}+Right" = "focus right";

              "${modifier}+Shift+${left}" = "move left";
              "${modifier}+Shift+${down}" = "move down";
              "${modifier}+Shift+${up}" = "move up";
              "${modifier}+Shift+${right}" = "move right";

              "${modifier}+Shift+Left" = "move left";
              "${modifier}+Shift+Down" = "move down";
              "${modifier}+Shift+Up" = "move up";
              "${modifier}+Shift+Right" = "move right";

              "${modifier}+b" = "splith";
              "${modifier}+v" = "splitv";
              "${modifier}+f" = "fullscreen toggle";
              "${modifier}+a" = "focus parent";

              "${modifier}+s" = "layout stacking";
              "${modifier}+w" = "layout tabbed";
              "${modifier}+e" = "layout toggle split";

              "${modifier}+Shift+space" = "floating toggle";
              "${modifier}+space" = "focus mode_toggle";

              "${modifier}+1" = "workspace number 1";
              "${modifier}+2" = "workspace number 2";
              "${modifier}+3" = "workspace number 3";
              "${modifier}+4" = "workspace number 4";
              "${modifier}+5" = "workspace number 5";
              "${modifier}+6" = "workspace number 6";
              "${modifier}+7" = "workspace number 7";
              "${modifier}+8" = "workspace number 8";
              "${modifier}+9" = "workspace number 9";

              "${modifier}+Shift+1" = "move container to workspace number 1";
              "${modifier}+Shift+2" = "move container to workspace number 2";
              "${modifier}+Shift+3" = "move container to workspace number 3";
              "${modifier}+Shift+4" = "move container to workspace number 4";
              "${modifier}+Shift+5" = "move container to workspace number 5";
              "${modifier}+Shift+6" = "move container to workspace number 6";
              "${modifier}+Shift+7" = "move container to workspace number 7";
              "${modifier}+Shift+8" = "move container to workspace number 8";
              "${modifier}+Shift+9" = "move container to workspace number 9";

              "${modifier}+Shift+minus" = "move scratchpad";
              "${modifier}+minus" = "scratchpad show";

              "${modifier}+Shift+c" = "reload";
              "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

              "${modifier}+r" = "mode resize";

              # control volume
              "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
              "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
              "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
            }
            # Thinkpad laptop
            # -> needs some keybindings to control the hardware
            // lib.optionalAttrs (config.networking.hostName == "daisy")
              {
                # control brightness
                "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 10";
                "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10";
              };

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
        wlr-randr
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

    programs.light.enable = true;

    security = {
      # Allow swaylock to unlock the computer for us
      pam.services.swaylock.text = "auth include login";
      polkit.enable = true;
      rtkit.enable = true;
    };

    users.extraUsers.${config.mayniklas.var.mainUser}.extraGroups = [ "video" "audio" ];

    hardware = {
      # fixes'ÈGL_EXT_platform_base not supported'
      opengl.enable = true;
      # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
      nvidia.modesetting.enable = mkIf config.mayniklas.nvidia.enable true;
    };

  };
}
