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
      settings.mainbar = {
        layer = "top";
        position = "bottom";
        spacing = 4; # Gaps between modules (4px)
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-right = [ "tray" "network" "pulseaudio" "battery" "clock" ];
        tray = {
          spacing = 10;
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
