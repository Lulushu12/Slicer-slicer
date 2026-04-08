{ config, pkgs, ... }:

{
  imports = [
    ./modules/shell
    ./modules/desktop
    ./modules/development
    ./modules/media
    ./modules/gaming
  ];

  home = {
    username = "radu";
    homeDirectory = "/home/radu";
    stateVersion = "24.05";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Session variables
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    PAGER = "less";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
  };

  # Common packages for user
  home.packages = with pkgs; [
    # Browsers
    firefox
    chromium
    brave

    # Communication
    discord
    telegram-desktop
    slack

    # Media packages migrated to modules/media/default.nix

    # Office
    libreoffice

    # Utilities
    flameshot
    keepassxc
    syncthing
    qbittorrent

    # File managers (supplementary)
    # KDE/GNOME already have their own

    # Viewer apps migrated to their respective modules

    # Archive tools (UI)
    xarchiver

    # System tools
    gnome-disks
    gparted

    # Creative, 3D, and Audio packages migrated to modules/media/default.nix

    # Zoom
    zoom

    # Misc
    # Add more as needed
  ];
}
