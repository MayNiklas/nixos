{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mayniklas.programs.sway;
in
{
  options.mayniklas.programs.sway.enable = mkEnableOption "enable sway";
  config = mkIf cfg.enable {

    # Use sway desktop environment with Wayland display server
    # https://rycee.gitlab.io/home-manager/options.html#opt-wayland.windowManager.sway.enable

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

        terminal = "${pkgs.foot}/bin/foot";
        menu = "${pkgs.wofi}/bin/wofi --show run";

        # Status bar(s)
        bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];

        startup = [
          { command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"; }
        ];

        keybindings =
          let
            inherit (config.wayland.windowManager.sway.config) modifier left down up right menu terminal;
          in
          lib.mkOptionDefault
            {
              # control volume
              "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
              "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
              "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";

              # control brightness
              "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 10";
              "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10";
            };

        colors = let c = config.pinpox.colors; in {
          focused = {
            background = "#${c.Blue}";
            border = "#${c.BrightBlue}";
            childBorder = "#${c.Blue}";
            indicator = "#${c.BrightBlue}";
            text = "#${c.Black}";
          };
          focusedInactive = {
            background = "#${c.BrightWhite}";
            border = "#${c.BrightBlack}";
            childBorder = "#${c.BrightWhite}";
            indicator = "#${c.BrightBlack}";
            text = "#${c.White}";
          };
          unfocused = {
            background = "#${c.Black}";
            border = "#${c.BrightBlack}";
            childBorder = "#${c.Black}";
            indicator = "#${c.BrightBlack}";
            text = "#${c.BrightBlack}";
          };
          urgent = {
            background = "#${c.Red}";
            border = "#${c.Black}";
            childBorder = "#${c.Red}";
            indicator = "#${c.Red}";
            text = "#${c.White}";
          };
        };
      };

    };

    programs = {
      swaylock = {
        enable = true;
      };
      zsh = {
        shellAliases = rec {
          # suspend
          zzz = "systemctl suspend";
        };
      };
    };

    services = {
      swayidle = {
        enable = true;
        events = [
          { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock"; }
          { event = "lock"; command = "lock"; }
        ];
        timeouts = [
          {
            # timeout in seconds
            timeout = 60;
            command = "${pkgs.swaylock}/bin/swaylock -fF";
          }
        ];
      };
    };

    home.packages = with pkgs; [
      wl-clipboard
      mako
      wlr-randr
      xdg-utils # for opening default programs when clicking links
    ];

  };
}
