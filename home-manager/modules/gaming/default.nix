{ config, pkgs, ... }:

{
  # Gaming configuration for home-manager

  home.packages = with pkgs; [
    # Steam & Launchers
    steam
    steam-run
    proton-ge-custom
    protontricks
    winetricks

    # Gaming utilities
    mangohud
    goverlay
    gamemode
    lutris
    heroic
    # launcher # Note: 'launcher' is not a valid nixpkgs name. Use prismlauncher or steam-run.

    # Tools
    antimicrox
    jstest-gtk

    # Emulators
    dolphin-emu-primehack
    pcsx2
    mgba
    snes9x
  ];

  # Steam configuration
  home.file.".config/Steam/steam/steamclient.xml" = {
    text = ''
      <install>
        <DontRemindMeAboutRunningInWine value="1" />
        <RunInWine value="1" />
      </install>
    '';
  };

  # Lutris configuration
  home.file.".config/lutris/lutris.conf".text = ''
    [main]
    window_height=900
    window_width=1440
    dark_theme=true
    show_side_panel=true
    show_unavailable_games=false

    [default]
    game_path=$HOME/Games
    wine_path=$HOME/.cache/lutris/wine
  '';

  # MangoHUD configuration
  home.file.".config/MangoHUD/MangoHUD.conf".text = ''
    # MangoHUD Configuration for Gaming

    # Performance metrics
    fps
    cpu_stats
    gpu_stats
    ram
    vram
    vram_usage

    # Layout
    position=top-right
    font_size=24
    text_color=00FF00

    # Advanced
    swap
    intake_temp
    gpu_temp
    cpu_temp
    target_fps=0

    # Networking
    network
    net_color=00FF00

    # Logging
    log_duration=30
    fps_log_interval=100
  '';

  # Protontricks configuration
  home.sessionVariables = {
    PROTON_TIPS = "0";  # Disable Proton startup tips
    STEAM_FORCE_DESKTOPUI_SCALING = "2";  # Better scaling on high DPI
  };

  # Additional gaming-specific packages that might be needed
  home.file.".local/share/applications/steam.desktop" = {
    text = ''
      [Desktop Entry]
      Name=Steam
      Comment=Application for managing and playing games on Steam
      Exec=steam %U
      Icon=steam
      Terminal=false
      Type=Application
      MimeType=x-scheme-handler/steam;
      Categories=Utility;
      StartupNotify=true
    '';
  };
}
