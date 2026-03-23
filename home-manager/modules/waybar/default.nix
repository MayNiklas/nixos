{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mayniklas.programs.waybar;
in
{
  options.mayniklas.programs.waybar.enable = mkEnableOption "enable waybar";
  config = mkIf cfg.enable {

    # Applets, shown in tray
    services = {
      # Networking
      network-manager-applet.enable = true;
      # Bluetooth
      blueman-applet.enable = true;
      # Pulseaudio
      pasystray.enable = true;
      # Battery Warning
      cbatticon.enable = true;
    };

    programs.waybar = {
      enable = true;

      style =
        let
          c = config.pinpox.colors;
        in
        ''
          @define-color Black #${c.Black};
          @define-color BrightBlack #${c.BrightBlack};
          @define-color White #${c.White};
          @define-color BrightWhite #${c.BrightWhite};
          @define-color Yellow #${c.Yellow};
          @define-color BrightYellow #${c.BrightYellow};
          @define-color Green #${c.Green};
          @define-color BrightGreen #${c.BrightGreen};
          @define-color Cyan #${c.Cyan};
          @define-color BrightCyan #${c.BrightCyan};
          @define-color Blue #${c.Blue};
          @define-color BrightBlue #${c.BrightBlue};
          @define-color Magenta #${c.Magenta};
          @define-color BrightMagenta #${c.BrightMagenta};
          @define-color Red #${c.Red};
          @define-color BrightRed #${c.BrightRed};
          ${fileContents ./style.css}
        '';

      settings.mainbar = {
        layer = "top";
        position = "bottom";
        spacing = 4; # Gaps between modules (4px)
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-right = [ "tray" "idle_inhibitor" "cpu" "memory" "backlight" "network" "pulseaudio" "battery" "clock" ];
        tray = {
          spacing = 10;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
        };
        backlight = {
          format = "{percent}% {icon}";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        };
        cpu = {
          interval = 5;
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          interval = 5;
          format = "{}% ";
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%)  ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        pulseaudio = {
          scroll-step = 1; # %, can be a float
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = "ﱝ {icon} {format_source}";
          format-muted = "ﱝ {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            default = [ "" "" "" ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
      };
    };

  };
}
