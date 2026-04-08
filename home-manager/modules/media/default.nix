{ config, pkgs, ... }:

{
  # Media and creative software configuration

  home.packages = with pkgs; [
    # Video
    mpv
    vlc
    ffmpeg
    handbrake
    kdenlive
    obs-studio
    shotcut
    kdePackages.haruna

    # Audio
    audacity
    ardour
    qsynth
    fluidsynth
    cmus
    spotify
    pavucontrol

    # Image
    gimp
    krita
    inkscape
    imagemagick
    graphicsmagick
    darktable
    rawtherapee
    kdePackages.gwenview

    # Photo management
    digikam
    darktable

    # 3D
    blender
    meshlab

    # PDF
    okular
    pdftkfx

    # Document viewers
    evince
    zathura

    # Color picker
    kdePackages.kcolorchooser
    gcolor3

    # Font management
    fontforge
    font-manager

    # Ebook
    calibre
    foliate
  ];

  # VLC configuration
  home.file.".config/vlc/vlcrc".text = ''
    # VLC Media Player configuration

    [main]
    interface=qt
    qt-display-modes=1

    [video]
    vout=xv
    fullscreen=0

    [audio]
    audio-language=en
  '';

  # mpv configuration
  home.file.".config/mpv/mpv.conf".text = ''
    # MPV player configuration

    profile=gpu-hq
    gpu-context=auto
    vo=gpu
    ao=pipewire

    # Subtitles
    sub-font="DejaVu Sans"
    sub-font-size=45

    # Screenshot
    screenshot-directory=~/Pictures/Screenshots
    screenshot-format=png

    # Play folder contents
    keep-open=no
  '';

  # Mpv input configuration
  home.file.".config/mpv/input.conf".text = ''
    # MPV input configuration
    q quit
    Q quit-watch-later
    f cycle fullscreen
    p cycle pause
    > playlist-next
    < playlist-prev
    + add volume 2
    - add volume -2
    m cycle mute
    [ multiply speed 0.9091
    ] multiply speed 1.1
    { multiply speed 0.5
    } multiply speed 2.0
    = set speed 1.0
    j cycle sub
    J cycle sub down
    i cycle-values window-scale 2 1.5 1 0.5
  '';

  # Blender configuration is removed from here because .blend preferences are binary files.
  # Writing raw text strings like '# Auto-generated' into it will corrupt the preferences file.

  # Audacity configuration
  home.file.".config/Audacity/audacity.cfg".text = ''
    [Playback]
    PlaybackDevice=

    [Recording]
    RecordingDevice=

    [Project Rate]
    DefaultProjectRate=44100

    [UI]
    GUI=wxPython 3.0
    Locale=en
    Language=en
  '';
}
