{ config, pkgs, ... }:

{
  # GNOME specific home-manager configuration

  # GNOME packages for the user
  home.packages = with pkgs; [
    # GNOME utilities
    gnome.nautilus
    gnome.gedit
    gnome.evince
    gnome.eog
    gnome.gnome-tweaks
    gnome.gnome-calendar
    gnome.contacts

    # GNOME extensions
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
    gnomeExtensions.blur-my-shell

    # Additional GNOME apps
    gnome.evolution
    gnome.gnome-maps
    gnome.gnome-weather
  ];

  # Dconf settings for GNOME customization
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-application-prefer-dark-theme = true;
      clock-format = "24h";
      show-battery-percentage = true;
    };

    "org/gnome/shell" = {
      # Extensions to enable
      enabled-extensions = [
        "appindicatorSupport@rgcjonas.gmail.com"
        "dash-to-dock@micxl.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
      # Favorites in the dock
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.gedit.desktop"
        "vlc.desktop"
        "org.gnome.Calendar.desktop"
      ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-fixed = true;
      dock-position = "LEFT";
      autohide = false;
      show-apps-at-top = false;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      search-view = "list-view";
      show-create-link = true;
    };

    # "org/gnome/desktop/background" = {
    #   picture-uri = "file:///usr/share/pixmaps/gnome-background.png"; # /usr/share doesn't exist on NixOS
    #   picture-uri-dark = "file:///usr/share/pixmaps/gnome-background.png";
    # };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      ambient-enabled = true;
      idle-brightness = 50;
      power-button-action = "interactive";
    };
  };

  # GTK configuration for GNOME
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      size = 24;
    };
    gtk3.extraConfig = {
      gtk-button-images = true;
      gtk-menu-images = true;
    };
  };

  # Session variables for GNOME
  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "adwaita";
    QT_QPA_PLATFORMTHEME = "gnome";
  };
}
