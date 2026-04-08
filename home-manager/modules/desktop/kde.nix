{ config, pkgs, ... }:

{
  # KDE Plasma specific home-manager configuration

  # KDE packages for the user
  home.packages = with pkgs; [
    # KDE Plasma utilities
    kdePackages.kdeplasma-addons
    kdePackages.plasma-browser-integration
    kdePackages.kscreen
    kdePackages.kdeconnect

    # Additional KDE apps
    kdePackages.merkuro
    kdePackages.akregator
    kdePackages.krusader

    # Theming utilities
    kdePackages.kvantum
    kvantum-theme-nordic-git

    # KDE development tools
    kdePackages.dolphin-plugins
    kdePackages.kio-gdrive
  ];

  # KDE configuration files
  xdg.configFile = {
    # NOTE: Uncomment these once you place your exported CachyOS files into ./kde-configs/ directory.
    # Otherwise, Nix will crash at evaluation for 'No such file'.
    
    # "alacritty/alacritty.toml".source = ./kde-configs/alacritty.toml;
    # "plasmashellrc".source = ./kde-configs/plasmashellrc;
    # "kglobalshortcutsrc".source = ./kde-configs/kglobalshortcutsrc;
    # "kwinrc".source = ./kde-configs/kwinrc;
  };

  # Session variables for KDE
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
  };

  # Powerlevel10k for KDE terminal
  # home.file.".config/zsh/.p10k.zsh".source = ./kde-configs/.p10k.zsh;
}
