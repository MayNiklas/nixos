{ writeShellScriptBin, minicom }:
writeShellScriptBin "usb-serial" ''
  # if not root, re-execute this script with sudo
  if [ "$(id -u)" -ne 0 ]; then
    exec sudo "$0" "$@"
  fi

  ${minicom}/bin/minicom -b 115200 -c on -D /dev/ttyUSB0
''
