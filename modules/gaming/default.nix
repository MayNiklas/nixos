{ pkgs, lib, config, ... }:
with lib;
let cfg = config.mayniklas.gaming;
in
{

  options.mayniklas.gaming = {
    enable = mkEnableOption "activate gaming";
  };

  config = mkIf cfg.enable {

    # Steam files:
    # .steam
    # .steampath
    # .steampid
    # .local/share/Steam
    programs.steam.enable = true;

    home-manager.users."${config.mayniklas.var.mainUser}".home.packages = with pkgs; [
      (lutris.override {
        extraPkgs = pkgs: [
          wine
          winetricks
        ];
      })
      # A free, open source launcher for Minecraft
      prismlauncher
    ];

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

  };

}
