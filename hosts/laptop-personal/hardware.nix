{ config, pkgs, lib, ... }:
{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  
  # Ensure Intel microcode is prioritized for the Skylake 6th Gen CPU
  boot.kernelModules = [ "kvm-intel" ];
  hardware.cpu.intel.updateMicrocode = true;

  # TODO: Rerun `nixos-generate-config --show-hardware-config` on the physical laptop and replace these UUIDs.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/YOUR-ROOT-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/YOUR-BOOT-UUID";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/YOUR-SWAP-UUID"; }
  ];
}
