# 2. Check 5 times before giving up
{ writeShellScriptBin, iputils, ... }:
writeShellScriptBin "mtu-check" ''
  # start with a known good MTU
  MTU=1380
  
  IP=1.1.1.1
  
  # if argument is given, use it as IP
  if [ -n "$1" ]; then
      IP=$1
  fi

  # counter for failed pings in a row
  counter=0

  # check maximum transmission unit (MTU) of a network
  # loop until we get an error
  while true; do
      # try to ping with the current MTU
      echo "Trying MTU of $MTU"
      ${iputils}/bin/ping -c 1 -M do -s $MTU $IP >/dev/null 2>&1
      if [ $? -ne 0 ]; then
          counter=$(($counter + 1))
          # if we failed 5 times in a row, we assume the MTU is too big
          if [ $counter -eq 5 ]; then
            # ping failed, so the MTU is too big
            echo "Ping with MTU size $MTU failed..."
            echo "Adding 28 Bytes for ICMP and IP header to the previous value..."
            # 8 Bytes ICMP-Header
            # 20 Bytes IP-Header
            MTU=$(($MTU + 28 - 1))
            echo "MTU of network is $MTU Bytes"
            exit 0
          fi
      else
          # ping succeeded, so the MTU is too small
          # increase it by 1 and try again
          MTU=$(($MTU + 1))

          # reset counter if we had a successful ping
          counter=0
      fi
  done
''
