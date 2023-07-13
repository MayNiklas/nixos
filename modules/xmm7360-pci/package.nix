{ lib, stdenv, fetchFromGitHub, kernel, python3 }:

stdenv.mkDerivation rec {
  pname = "xmm7360-pci";
  version = "2022-08-13";

  src = fetchFromGitHub {
    owner = "xmm7360";
    repo = "xmm7360-pci";
    rev = "107b6baa9f380a55111a5ce29b987ef64c43104b";
    hash = "sha256-lrR1Q/+PmkOQQ3whBMSFhCdGWSwONPNDTCUKmoFD900=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  prePatch = ''
    substituteInPlace rpc/open_xdatachannel.py --replace "#!/usr/bin/env python3"  "#!${
      (python3.withPackages
        (ps: [ ps.ConfigArgParse ps.pyroute2 ps.dbus-python ]))
    }/bin/python3"
  '';

  makeFlags =
    [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    mkdir -p $out/bin/
    install -D xmm7360.ko $out/lib/modules/${kernel.modDirVersion}/misc/xmm7360.ko
    cp rpc/* $out/bin/
  '';

  meta = with lib; {
    description =
      "PCI driver for Fibocom L850-GL modem based on Intel XMM7360 modem";
    homepage = "https://github.com/xmm7360/xmm7360-pci/";
    license = licenses.free;
    platforms = [ "x86_64-linux" ];
  };
}
