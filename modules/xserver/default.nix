{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.xserver;
in {

  options.mayniklas.xserver = { enable = mkEnableOption "activate xserver"; };

  config = mkIf cfg.enable {

    # Enable the X11 windowing system.
    services.xserver = {
      layout = "de";
      xkbOptions = "eurosign:e";
      enable = true;
      autorun = true;
      dpi = 125;
      libinput = {
        enable = true;
        touchpad.accelProfile = "flat";
      };

      config = ''
        Section "InputClass"
          Identifier "mouse accel"
          Driver "libinput"
          MatchIsPointer "on"
          Option "AccelProfile" "flat"
          Option "AccelSpeed" "0"
        EndSection
      '';

      desktopManager = {
        xterm.enable = false;
        session = [{
          name = "home-manager";
          start = ''
            export `dbus-launch`
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
             waitPID=$!
          '';
        }];
      };

      displayManager.lightdm.enable = true;

    };

  };
}
