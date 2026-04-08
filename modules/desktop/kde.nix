{ config, pkgs, lib, ... }:
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  services.desktopManager.plasma6 = {
    enable = true;
  };

  # KDE Plasma packages
  environment.systemPackages = with pkgs; [
    # Core Plasma
    kdePackages.plasma-desktop
    kdePackages.plasma-workspaces
    kdePackages.kwin

    # KDE Apps
    kdePackages.dolphin
    kdePackages.kate
    kdePackages.korganizer
    kdePackages.kontact
    kdePackages.kdepim-addons
    kdePackages.kmail
    kdePackages.spectacle
    kdePackages.ark
    kdePackages.okular
    kdePackages.gwenview
    kdePackages.haruna
    kdePackages.kscreen
    kdePackages.bluedevil

    # Theming
    kdePackages.breeze
    kdePackages.breeze-gtk
    kdePackages.breeze-icons

    # System tray
    kdePackages.klipper
    kdePackages.kwalletd

    # KDE Plasma addons
    kdePackages.plasma-browser-integration
    kdePackages.kdeplasma-addons

    # Additional utilities
    kdePackages.ksshaskpass
    kdePackages.kwallet-pam
  ];

  # KDE configuration
  services.xserver.desktopManager.plasma6.phononBackend = "vlc";
}
