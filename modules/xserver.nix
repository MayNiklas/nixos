{ config, pkgs, lib, ... }: {
  # Enable the X11 windowing system.
  services.xserver = {
    videoDrivers = [ "nvidia" ];
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

    screenSection = ''
      Option         "metamodes" "DP-0: 3440x1440_120 +1920+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On, AllowGSYNCCompatible=On}, DP-2: 1920x1200_60 +0+240 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
    '';

    desktopManager = {
      xterm.enable = false;
      session = [{
        name = "home-manager";
        start = ''
          ${pkgs.runtimeShell} $HOME/.hm-xsession &
           waitPID=$!
        '';
      }];
    };

    displayManager.lightdm.enable = true;
  };
  nixpkgs = { config.allowUnfree = true; };
}
