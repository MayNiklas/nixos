{ pkgs, ... }:
pkgs.writeShellScriptBin "set-performance" ''
  # get available CPU governor profiles
  available_profiles=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)

  # use fzf to select a profile
  profile=$(echo $available_profiles | tr ' ' '\n' | ${pkgs.fzf}/bin/fzf)

  # if user is not root, use sudo
  if [ "$EUID" -ne 0 ]
  then
    echo "Need root privileges to set CPU governor profile! Using sudo..."
    echo $profile | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  else
    echo $profile | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  fi
''
