{ config, pkgs, lib, ... }:
  # System services

  # Sound (PipeWire)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Disable PulseAudio (conflicting with PipeWire)
  hardware.pulseaudio.enable = false;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;

  # Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      hplip
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      workstation = true;
    };
  };

  # CUPS PDF printer
  services.printing.extraConf = ''
    LogLevel warn
    MaxLogSize 0
  '';

  # Udev rules for various devices
  services.udev.packages = with pkgs; [
    bluez
    libmtp
  ];

  # User groups
  users.groups.plugdev = {};
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", GROUP="plugdev", MODE="0660"
    SUBSYSTEM=="hidraw", GROUP="plugdev", MODE="0660"
  '';

  # systemd-resolved for DNS
  services.resolved = {
    enable = true;
    dnssec = "no";  # Disable if you have DNS issues
  };

  # Automatic mounting of external drives
  services.udisks2.enable = true;

  # Fstrim for SSDs
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # SMART disk monitoring
  services.smartd = {
    enable = true;
  };

  # Docker daemon
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  # libvirt for virtual machines
  virtualisation.libvirtd = {
    enable = false;  # Change to true if you use VMs
  };

  # Power management
  services.power-profiles-daemon.enable = true;

  # Dbus (required for many services)
  services.dbus.enable = true;

  # XDG file manager
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };

  # Automated garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
