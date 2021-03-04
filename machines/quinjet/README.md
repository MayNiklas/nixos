# Quinjet

Intel NUC8i5BEH home server running NixOS.

Short review:
- it consumes only very little energy which makes it perfect for running 24/7
- the CPU can boost up pretty high which makes it feel snappy during updates
- the CPU has 8 threads
- it's iGPU is very powerful for hw transcoding
- it's cost effective in both energy consuption as well as price
- it can fit up to 64GB of DDR4 RAM
- it holds 1 x NVME & 1 x 2,5 SATA drive

```
▸ nix-shell -p pkgs.inxi -p pkgs.lm_sensors --command "inxi -Fx"
System:    Host: quinjet Kernel: 5.4.99 x86_64 bits: 64 compiler: gcc v: 10.2.1 Console: tty 0 
           Distro: NixOS 21.05pre273332.5df05c902cd (Okapi) 
Machine:   Type: Desktop System: Intel Client Systems product: NUC8i5BEH v: J72747-304 serial: <superuser required> 
           Mobo: Intel model: NUC8BEB v: J72692-306 serial: <superuser required> UEFI: Intel 
           v: BECFL357.86A.0071.2019.0510.1505 date: 05/10/2019 
CPU:       Info: Quad Core model: Intel Core i5-8259U bits: 64 type: MT MCP arch: Kaby Lake note: check rev: A L2 cache: 6 MiB 
           flags: avx avx2 lm nx pae sse sse2 sse3 sse4_1 sse4_2 ssse3 vmx bogomips: 36799 
           Speed: 437 MHz min/max: 400/3800 MHz Core speeds (MHz): 1: 437 2: 445 3: 443 4: 472 5: 442 6: 441 7: 443 8: 433 
Graphics:  Message: No Device data found. 
           Display: server: No display server data found. Headless machine? tty: 248x37 
           Message: Unable to show advanced data. Required tool glxinfo missing. 
Audio:     Device-1: HDA Intel PCH driver: HDA-Intel message: bus/chip ids unavailable 
           Sound Server: ALSA v: k5.4.99 
Network:   IF-ID-5: eno1 state: up speed: 1000 Mbps duplex: full mac: 1c:69:7a:01:3e:15  
           IF-ID-9: wlp0s20f3 state: down mac: 0e:fe:7d:8d:5d:4d 
Bluetooth: Device-1: type: USB driver: btusb v: 0.8 bus ID: 1-10:2 
Drives:    Local Storage: total: 1.36 TiB used: 81.57 GiB (5.8%) 
           ID-1: /dev/nvme0n1 vendor: Crucial model: CT500P1SSD8 size: 465.76 GiB 
           ID-2: /dev/sda vendor: SanDisk model: SDSSDH3 1T00 size: 931.51 GiB 
Partition: ID-1: / size: 883.9 GiB used: 81.47 GiB (9.2%) fs: ext4 dev: /dev/sda3 
           ID-2: /boot size: 510 MiB used: 100.5 MiB (19.7%) fs: vfat dev: /dev/sda1 
Swap:      ID-1: swap-1 type: partition size: 32 GiB used: 4.8 MiB (0.0%) dev: /dev/sda2 
Sensors:   System Temperatures: cpu: 34.0 C mobo: 27.8 C 
           Fan Speeds (RPM): N/A 
Info:      Processes: 347 Uptime: 10:03:17  up 9 days 19:13,  1 user,  load average: 0.01, 0.06, 0.02 Memory: 31.24 GiB 
           used: 1.78 GiB (5.7%) Init: systemd Compilers: gcc: 10.2.0 Packages: N/A Shell: Bash v: 4.4.23 inxi: 3.3.01
           
▸ lsblk -f
NAME        FSTYPE             FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINT
sda                                                                                            
├─sda1      vfat               FAT32 boot  E434-B783                             409.4M    20% /boot
├─sda2      swap               1     swap  43fc78e6-46dd-4403-b80d-c29fec46873d                [SWAP]
└─sda3      ext4               1.0   nixos 8802e999-f7b5-4ed0-a461-436597082f0d  757.5G     9% /
nvme0n1                                                                                        
└─nvme0n1p1 VMFS_volume_member 6     
```
