{ config, pkgs, lib, ... }:
  # Localization settings

  # Timezone
  time.timeZone = "Europe/Bucharest";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us,ro";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  # Console keyboard
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    dejavu_fonts
    fira-code
    fira-mono
    hack
    jetbrains-mono
    meslo-lgs-nf
    fantasque-sans-mono
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "DejaVu Serif" ];
      sansSerif = [ "DejaVu Sans" ];
      monospace = [ "DejaVu Sans Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
