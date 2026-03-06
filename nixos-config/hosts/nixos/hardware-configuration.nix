# Auto-generated hardware configuration for the "nixos" VirtualBox VM.
#
# Originally produced by `nixos-generate-config` and committed here so the
# flake can be evaluated from GitHub without requiring a local copy.
#
# If you reinstall NixOS or migrate to new hardware, regenerate this file with:
#   sudo nixos-generate-config --show-hardware-config
# then replace the contents below with the fresh output.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ── Kernel modules ───────────────────────────────────────────────────────────
  boot.initrd.availableKernelModules = [
    "ata_piix"      # VirtualBox SATA/IDE controller
    "ohci_pci"      # USB 1.x
    "ehci_pci"      # USB 2.0
    "ahci"          # AHCI SATA
    "sd_mod"        # SCSI disk
    "sr_mod"        # SCSI CD-ROM
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  # ── Filesystems ──────────────────────────────────────────────────────────────
  # Adjust UUIDs / labels to match your actual disk layout.
  # Run `blkid` on the VM to get the real values.
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/sda2"; }
  ];

  # ── CPU ──────────────────────────────────────────────────────────────────────
  # VirtualBox exposes the host CPU; this enables microcode updates for both
  # common vendor families so the config works on AMD and Intel hosts alike.
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  # ── Platform ─────────────────────────────────────────────────────────────────
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
