{ config, pkgs, lib, ... }:
  # Boot configuration

  boot = {
    # GRUB bootloader
    loader.grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      efiInstallAsRemovable = false;
    };

    loader.efi = {
      canTouchEfiVariables = true;
    };

    # Kernel settings
    kernelPackages = pkgs.linuxPackages_latest;

    # Kernel parameters
    kernelParams = [
      "quiet"
      "splash"
      "discard"  # Enable TRIM for SSDs
    ];

    # Plymouth splash screen (optional)
    plymouth = {
      enable = false;  # Disable for faster boot, enable if you want splash screen
    };

    # Kernel modules
    kernelModules = [
      "kvm-amd"  # AMD virtualization
      "uinput"   # For input devices
    ];

    # Bootloader timeout
    loader.timeout = 10;

    # Enable TRIM for SSDs handled in kernelParams above
  };

  # Systemd settings
  systemd = {
    # Reduce shutdown timeout
    extraConfig = "DefaultTimeoutStopSec=10s";
  };
}
