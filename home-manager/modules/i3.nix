{ config, pkgs, lib, ... }:
let vars = import ./vars.nix;
in {

  home.packages = with pkgs; [
    dmenu
    i3status
    i3lock
    i3blocks
    arandr
    feh
    rofi
    xorg.xmodmap
    xorg.xdpyinfo
    pulsemixer
    alacritty
    gnome3.gnome-screenshot
  ];

  services = {
    network-manager-applet.enable = true;
    blueman-applet.enable = true;
    pasystray.enable = true;
  };

  xsession.scriptPath = ".hm-xsession";
  xsession.enable = true;

  xsession.windowManager.i3 = {
    enable = true;

    package = pkgs.i3-gaps;

    config = {
      modifier = "Mod4";

 #     bars = [ ]; 
      bars = [{
        position = "top";
        statusCommand = "${pkgs.i3status}/bin/i3status";
      }];

      menu = "rofi";

      window.commands = [{
        command = "border pixel 2";
        criteria = { class = "^.*"; };
      }];

      startup = [
        {
          command = "autorandr -c";
          always =
            false; # Important, run only on first start (will loop otherwise)!
          notification = false;
        }
        {
          command = "${pkgs.feh}/bin/feh --bg-fill ~/wallpaper-CS2420.jpg wallpaper-AW3420.jpg";
          always = true;
          notification = false;
        }
        {
          command = "xfce4-volumed-pulse &";
          always = false;
          notification = false;
        }
        {
          command = "nitrogen --restore";
          always = true;
          notification = false;
        }
        {
          command = "pkill -USR1 polybar";
          always = true;
          notification = false;
        }
      ];

      floating = { border = 2; };

      focus = {
        followMouse = true;
        forceWrapping = true;
      };

      gaps = {
        bottom = 5;
        horizontal = 5;
        inner = 5;
        left = 5;
        outer = 5;
        right = 5;
        top = 5;
        vertical = 5;
        smartBorders = "no_gaps";
        smartGaps = true;
      };

      keybindings =
        let modifier = config.xsession.windowManager.i3.config.modifier;
        in lib.mkOptionDefault {

          "${modifier}+d" = "exec dmenu_run";

          "${modifier}+Shift+Escape" = "exec xkill";

          "${modifier}+t" =
            "exec ${pkgs.rofi}/bin/rofi -show run -lines 7 -eh 1 -bw 0  -fullscreen -padding 200";

          "${modifier}+Shift+x" = "exec xscreensaver-command -lock";

          "${modifier}+Shift+Tab" = "workspace prev";

          "${modifier}+Tab" = "workspace next";

          "XF86AudioLowerVolume" =
            "exec --no-startup-id pactl set-sink-volume 0 -5%"; # decrease sound volume

          "XF86AudioMute" =
            "exec --no-startup-id pactl set-sink-mute 0 toggle"; # mute sound

          "XF86AudioNext" = "exec playerctl next";

          "XF86AudioPlay" = "exec playerctl play-pause";

          "XF86AudioPrev" = "exec playerctl previous";

          "XF86AudioRaiseVolume" =
            "exec --no-startup-id pactl set-sink-volume 0 +5% #increase sound volume";

          "XF86AudioStop" = "exec playerctl stop";

          "XF86MonBrightnessDown" =
            "exec xbacklight -dec 20"; # decrease screen brightness

          "XF86MonBrightnessUp" =
            "exec xbacklight -inc 20"; # increase screen brightness

          "Print" =
            "exec gnome-screenshot -c -i";
        };

      terminal = "alacritty";

      workspaceLayout = "tabbed";

    };
  };
}
