{ config, pkgs, lib, ... }:
  # GNOME Desktop Environment (alongside KDE for easy switching)
  services.xserver = {
    enable = true;
    # SDDM handles both KDE and GNOME selection
    displayManager.gdm.enable = false;  # Use SDDM for consistency
  };

  services.desktopManager.gnome = {
    enable = true;
  };

  # Remove GNOME apps we don't need
  environment.gnome.excludePackages = with pkgs; [
    gnome-console
    gnome-tour
  ];

  # GNOME packages
  environment.systemPackages = with pkgs; [
    # Core GNOME
    gnome.gnome-shell
    gnome.mutter
    gnome.gnome-settings-daemon

    # GNOME Apps
    gnome.nautilus
    gnome.gedit
    gnome.epiphany
    gnome.calendar
    gnome.contacts
    gnome.evolution
    gnome.evolution-data-server

    # GNOME Control Center
    gnome.gnome-control-center
    gnome.gnome-tweaks

    # Theming
    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock

    # Additional utilities
    glib  # For glib-compile-schemas
  ];

  # Required for GNOME to work properly with SDDM
  programs.dconf.enable = true;

  # GNOME keyring
  services.gnome.gnome-keyring.enable = true;
}
