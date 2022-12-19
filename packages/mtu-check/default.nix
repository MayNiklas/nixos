{ pkgs, stdenv, ... }:
let
  mtu-check-skript = pkgs.writeShellScriptBin "mtu-check" ''
    # start with a known good MTU
    MTU=1380
    IP=1.1.1.1

    # check maximum transmission unit (MTU) of a network
    # loop until we get an error
    while true; do
        # try to ping with the current MTU
        echo "Trying MTU of $MTU"
        ping -c 1 -M do -s $MTU $IP >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            # ping failed, so the MTU is too big
            echo "Ping with MTU size $MTU failed..."
            echo "Adding 28 Bytes for ICMP and IP header to the previous value..."
            # 8 Bytes ICMP-Header
            # 20 Bytes IP-Header
            MTU=$(($MTU + 28 - 1))
            echo "MTU of network is $MTU Bytes"
            exit 0
        else
            # ping succeeded, so the MTU is too small
            # increase it by 1 and try again
            MTU=$(($MTU + 1))
        fi
    done
  '';
in
stdenv.mkDerivation {

  pname = "mtu-check";
  version = "0.1.0";

  # Needed if no src is used. Alternatively place script in
  # separate file and include it as src
  dontUnpack = true;

  installPhase = ''
    cp -r ${mtu-check-skript} $out
  '';
}

