{ config, pkgs, ... }:

{
  imports = [
    ./kde.nix
    ./gnome.nix
  ];

  # General desktop configuration

  # XDG user dirs
  xdg.enable = true;
  xdg.userDirs = {
    desktop = "$HOME/Desktop";
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    pictures = "$HOME/Pictures";
    publicShare = "$HOME/Public";
    templates = "$HOME/Templates";
    videos = "$HOME/Videos";
  };

  # Screen locker
  programs.gnome-keyring = {
    enable = true;
  };

  # Qt configuration
  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
  };

  # GTK configuration
  gtk = {
    enable = true;
    gtk2.configLocation = "$HOME/.config/gtk-2.0/gtkrc";
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "Breeze_cursors";
      gtk-cursor-theme-size = 24;
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-cursor-theme-name = "Breeze_cursors";
      gtk-cursor-theme-size = 24;
      gtk-application-prefer-dark-theme = true;
    };
    iconTheme = {
      name = "Breeze";
      package = pkgs.breeze-icons;
    };
    theme = {
      name = "Breeze-Dark";
      package = pkgs.breeze-gtk;
    };
    cursorTheme = {
      name = "Breeze_cursors";
      package = pkgs.breeze-icons;
      size = 24;
    };
  };

  # Dconf settings (for GNOME)
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Mimeapps configuration
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/pdf" = "org.kde.okular.desktop";
      "image/jpeg" = "org.kde.gwenview.desktop";
      "image/png" = "org.kde.gwenview.desktop";
      "video/mp4" = "mpv.desktop";
      "audio/mpeg" = "vlc.desktop";
    };
  };
}
