{ writeShellScriptBin, pciutils }:
writeShellScriptBin "ASPM-status" ''
  # if not root, re-execute this script with sudo
  if [ "$(id -u)" -ne 0 ]; then
    exec sudo "$0" "$@"
  fi

  # print the ASPM status of all PCI devices
  ${pciutils}/bin/lspci -vv | awk '/ASPM/{print $0}' RS= | grep --color -P '(^[a-z0-9:.]+|ASPM )'
''
