{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.sound;
in {

  options.mayniklas.sound = {
    enable = mkEnableOption "activate sound";
  };

  config = mkIf cfg.enable {

    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };

    environment.systemPackages = with pkgs; [ pavucontrol ];

    users.extraUsers.${config.mainUser}.extraGroups = [ "audio" ];

  };
}
