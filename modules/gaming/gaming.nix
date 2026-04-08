{ config, pkgs, lib, ... }:
  # Gaming setup - Steam, Lutris, Wine, Proton, etc.

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    package = pkgs.steam.override {
      extraLibraries = p: with p; [
        libGL
        glib
        libxkbcommon
      ];
    };
  };

  # 32-bit support for Steam
  hardware.graphics.enable32Bit = true;

  # Gaming packages
  environment.systemPackages = with pkgs; [
    # Steam & Launchers
    steam
    steam-run
    steamcmd

    # Proton & Wine
    proton
    proton-ge-custom
    wine
    wine32
    winetricks
    protontricks

    # Gaming tools
    lutris
    gamemode
    mangohud
    goverlay

    # Performance monitoring
    gpu-screen-recorder
    looking-glass-client

    # Emulation
    dolphin-emu
    pcsx2

    # Other gaming utilities
    antimicrox
    jstest-gtk
    joyutils
  ];

  # Enable gamemode for better gaming performance
  programs.gamemode.enable = true;
  programs.gamemode.settings = {
    general = {
      renice = 15;
      ioprio = "0:4";
    };
  };

  # hardware.opengl is deprecated in 24.05, covered by hardware.graphics above

  # Kernel modules for gaming
  boot.kernelModules = [ "uinput" ];

  # Virtual machine support for some games
  boot.kernel.sysctl."vm.max_map_count" = 2147483642;
}
