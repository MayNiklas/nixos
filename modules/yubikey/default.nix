{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.yubikey;
in
{

  options.mayniklas.yubikey = { enable = mkEnableOption "activate yubikey"; };

  config = mkIf cfg.enable {

    programs.ssh.startAgent = false;

    environment.systemPackages = with pkgs; [ yubioath-flutter ];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = mkIf (!config.services.xserver.desktopManager.plasma6.enable) pkgs.pinentry-gnome3;
    };

    # Needed for yubikey to work
    environment.shellInit = ''
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    '';

    # Setup Yubikey SSH and GPG
    services.pcscd.enable = true;
    services.udev.packages = [ pkgs.yubikey-personalization ];

  };
}
