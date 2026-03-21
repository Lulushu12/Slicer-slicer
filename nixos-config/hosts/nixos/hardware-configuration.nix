# Hardware configuration for a KVM/QEMU virtual machine with VirtIO devices.
#
# ── IMPORTANT ────────────────────────────────────────────────────────────────
# This file is a best-effort template for a standard virt-manager/KVM setup.
# If your disk layout differs (different partition count, EFI, LVM, etc.),
# regenerate this file on the installed system with:
#
#   sudo nixos-generate-config --show-hardware-config
#
# then replace the contents below with the fresh output.
# ─────────────────────────────────────────────────────────────────────────────
#
# Expected virt-manager setup:
#   Disk bus   → VirtIO  (/dev/vda)
#   Video      → VirtIO  (best performance, supports 3D acceleration)
#   Display    → SPICE   (for clipboard sharing and auto-resize)
#   Sound      → ich9 or virtio
#   Partition layout: /dev/vda1 = BIOS boot (8M), /dev/vda2 = swap (4G), /dev/vda3 = / (ext4)

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ── Kernel modules ───────────────────────────────────────────────────────────
  # VirtIO modules for KVM/QEMU paravirtualised devices.
  boot.initrd.availableKernelModules = [
    "virtio_pci"      # VirtIO PCI bus (required for all VirtIO devices)
    "virtio_blk"      # VirtIO block device (/dev/vda)
    "virtio_scsi"     # VirtIO SCSI (alternative block driver — loaded just in case)
    "virtio_net"      # VirtIO network card
    "virtio_balloon"  # Memory balloon (dynamic RAM adjustment from host)
    "xhci_pci"        # USB 3.0 controller (QEMU emulates this)
    "ahci"            # AHCI SATA (for any emulated SATA devices)
    "sd_mod"          # SCSI/SATA disk module
    "sr_mod"          # SCSI CD-ROM (ISO boot media)
  ];
  boot.initrd.kernelModules = [ "virtio_pci" "virtio_blk" ];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  # ── Filesystems ──────────────────────────────────────────────────────────────
  # Three-partition GPT layout:
  #   vda1 — 8 MiB BIOS boot partition (GRUB core.img lives here, not mounted)
  #   vda2 — 4 GiB swap
  #   vda3 — remainder, ext4 root (/)
  #
  # If the NixOS installer used UUID labels instead of device paths, run:
  #   blkid /dev/vda2 /dev/vda3
  # and substitute the UUIDs here:
  #   device = "/dev/disk/by-uuid/xxxx-xxxx";
  fileSystems."/" = {
    device = "/dev/vda3";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/vda2"; }
  ];

  # ── CPU ──────────────────────────────────────────────────────────────────────
  # KVM passes through the host CPU family; enable microcode updates for both
  # AMD and Intel so the config works regardless of the host processor.
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  # ── Platform ─────────────────────────────────────────────────────────────────
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
