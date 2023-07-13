{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.xmm7360;
  xmm7360-pci = config.boot.kernelPackages.callPackage ./xmm7360-pci.nix { };
in
{
  options.xmm7360 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Fibocom L850-GL WWAN Modem.";
    };
    autoStart = mkOption {
      type = types.bool;
      default = false;
      description = "Start the service on startup.";
    };
  };

  config = mkIf cfg.enable {

    # sudo start-modem
    environment.systemPackages =
      let
        inherit (pkgs) kmod;
        start-modem = pkgs.writeShellScriptBin "start-modem" ''
          # load needed kernel module
          ${kmod}/bin/modprobe xmm7360 || true

          # start script
          ${xmm7360-pci}/bin/open_xdatachannel.py -a internet.v6.telekom
        '';
      in
      with pkgs; [
        start-modem
      ];

    boot = {
      # 5.15 works with xmm7360-pci
      kernelPackages = pkgs.linuxPackages_5_15;
      # https://github.com/xmm7360/xmm7360-pci/
      extraModulePackages = [ xmm7360-pci ];
      blacklistedKernelModules = [ "iosm" ];
    };

    # Currently, due to absence of power management
    # xmm7360 needs to be brought down and reconnected on resume.
    powerManagement.resumeCommands = ''
      ${config.systemd.package}/bin/systemctl try-restart xmm7360 || true
    '';

    systemd.services.xmm7360 =
      let
        inherit (pkgs) kmod;
        # Be ensured that the device is freshly booted
        preStartScript = pkgs.writeShellScript "xmm7360-poststop" ''
          ${kmod}/bin/modprobe xmm7360 || true
          echo "Module loading completed"
        '';
        # Clean up whatever, including bringing the interface down and delete it anyway.
        postStopScript = pkgs.writeShellScript "xmm7360-poststop" ''
          ${kmod}/bin/rmmod xmm7360 || true
        '';
      in
      {
        wantedBy = lib.optionals (cfg.autoStart) [ "multi-user.target" ];
        description = "Configuration service for Fibocom L850-GL";
        # Sleep for 10 seconds to make sure that device is fully up.
        # Include it here in ExecStart so that it would block the activation process anyway.
        script = ''
          sleep 10
          ${xmm7360-pci}/bin/open_xdatachannel.py -a internet.v6.telekom
        '';
        serviceConfig = {
          # We want to keep it up, else the rules set up are discarded immediately.
          Type = "oneshot";
          RemainAfterExit = true; # Used together with oneshot
          TimeoutStartSec = "1min 30s"; # Timeout if it can't start and try again
          ExecStartPre = preStartScript;
          # Clean-up
          ExecStopPost = postStopScript;
          Restart = "on-failure";
          # SuccessExitStatus = 1;
        };
      };

  };
}
