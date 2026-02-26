# Common system settings: locale, timezone, fonts, and audio.
# These apply to all users and don't depend on the desktop choice.

{ pkgs, ... }:

{
  # ── Timezone & locale ────────────────────────────────────────────────────────
  # Find your timezone: `timedatectl list-timezones | grep Europe`
  time.timeZone = "Europe/Bucharest";

  i18n.defaultLocale = "en_US.UTF-8";

  # Use Romanian formats for dates, currency, etc. while keeping English UI.
  # Remove these if you prefer everything in English.
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT    = "ro_RO.UTF-8";
    LC_MONETARY       = "ro_RO.UTF-8";
    LC_NAME           = "ro_RO.UTF-8";
    LC_NUMERIC        = "ro_RO.UTF-8";
    LC_PAPER          = "ro_RO.UTF-8";
    LC_TELEPHONE      = "ro_RO.UTF-8";
    LC_TIME           = "ro_RO.UTF-8";
  };

  # Keyboard layout for the virtual console (TTY before the GUI loads).
  console.keyMap = "us";  # Change to "ro" for a Romanian layout

  # ── Fonts ────────────────────────────────────────────────────────────────────
  fonts = {
    enableDefaultPackages = true;  # A basic set of common fonts
    packages = with pkgs; [
      noto-fonts           # Excellent Unicode coverage — covers most scripts
      noto-fonts-cjk-sans  # Chinese, Japanese, Korean
      noto-fonts-emoji     # Color emoji

      # Nerd Fonts: patched fonts with developer icons for terminals and editors.
      # In NixOS 24.11+ each font is a separate package under `nerd-fonts`.
      nerd-fonts.jetbrains-mono  # Great for coding
      nerd-fonts.fira-code       # Ligature-heavy coding font
    ];

    fontconfig.defaultFonts = {
      serif      = [ "Noto Serif" ];
      sansSerif  = [ "Noto Sans" ];
      monospace  = [ "JetBrainsMono Nerd Font" ];
      emoji      = [ "Noto Color Emoji" ];
    };
  };

  # ── Audio: PipeWire ──────────────────────────────────────────────────────────
  # PipeWire is the modern Linux audio stack. It replaces PulseAudio and JACK,
  # and supports both transparently so all apps work out of the box.
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;  # Needed for 32-bit games/apps
    pulse.enable      = true;  # PulseAudio compatibility layer
    # jack.enable = true;      # Uncomment if you do pro-audio work
  };

  # Disable the legacy PulseAudio daemon — PipeWire replaces it.
  hardware.pulseaudio.enable = false;

  # RTKit lets PipeWire request realtime scheduling — reduces audio glitches.
  security.rtkit.enable = true;

  # ── Optional: Printing ───────────────────────────────────────────────────────
  # Uncomment to enable CUPS printing support.
  # services.printing.enable = true;

  # ── Optional: Bluetooth ──────────────────────────────────────────────────────
  # Uncomment if your machine (or VM host with USB passthrough) has Bluetooth.
  # hardware.bluetooth.enable = true;
  # hardware.bluetooth.powerOnBoot = true;
}
