# Desktop environment: Niri (primary) + KDE Plasma 6 (fallback).
#
# ─── Session selection ────────────────────────────────────────────────────────
# At the SDDM login screen you will see two session choices:
#   • "Niri"             → Wayland scrollable-tiling compositor (daily driver)
#   • "Plasma (Wayland)" → KDE Plasma 6 on Wayland (familiar fallback)
#   • "Plasma (X11)"     → KDE Plasma 6 on X11 (compatibility fallback)
#
# ─── Niri basics ─────────────────────────────────────────────────────────────
# Niri is a scrollable-tiling Wayland compositor. Windows tile horizontally
# into columns; columns scroll left/right on an infinite canvas per workspace.
#
#   Mod+Return    → open Kitty terminal
#   Mod+D         → open Fuzzel launcher
#   Mod+Q         → close focused window
#   Mod+H/L       → focus column left/right
#   Mod+J/K       → focus window up/down within a column
#   Mod+1–5       → switch workspace
#   Mod+Shift+E   → quit Niri
#
# The full keybinding list is in home/radu.nix under home.file (niri/config.kdl).
#
# ─── VM note ─────────────────────────────────────────────────────────────────
# Both Niri and KDE work fine in QEMU/KVM with a VirtIO-GPU device.
# If the Niri session fails to start (e.g. driver issue), select the
# Plasma (X11) session at the login screen as a reliable fallback.

{ pkgs, ... }:

{
  # ── Login manager (SDDM) ───────────────────────────────────────────────────
  services.displayManager.sddm = {
    enable = true;
    # Run SDDM itself on Wayland (uses kwin_wayland as compositor for the
    # login screen). This is optional but gives a fully Wayland boot.
    wayland.enable = true;
  };

  # ── KDE Plasma 6 ───────────────────────────────────────────────────────────
  services.desktopManager.plasma6.enable = true;

  # ── X server ───────────────────────────────────────────────────────────────
  # Required for KDE's X11 session and XWayland (runs X11 apps inside Wayland).
  services.xserver = {
    enable = true;
    xkb.layout  = "us";   # GUI keyboard layout. Change to "ro" for Romanian.
    xkb.variant = "";
  };

  # ── Niri ───────────────────────────────────────────────────────────────────
  # Installs Niri, registers its Wayland session with SDDM, and enables polkit.
  programs.niri.enable = true;

  # ── XDG desktop portals ────────────────────────────────────────────────────
  # Portals handle file pickers, screen sharing, and app sandboxing.
  # We configure per-session portals:
  #   • KDE sessions  → xdg-desktop-portal-kde
  #   • Niri session  → xdg-desktop-portal-gtk
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde   # Full KDE portal (file picker, etc.)
      xdg-desktop-portal-gtk               # GTK portal used by Niri
    ];
    config = {
      # Per-session portal routing
      niri.default     = [ "gtk" ];
      KDE.default      = [ "kde" ];
      # Fallback for any other session
      common.default   = [ "gtk" ];
    };
  };

  # ── Wayland / Niri ecosystem packages ─────────────────────────────────────
  # These are the supporting tools that make Niri a complete desktop.
  environment.systemPackages = with pkgs; [

    # ── KDE applications ──────────────────────────────────────────────────
    kdePackages.kate          # Text editor (great for editing .nix files)
    kdePackages.kcalc         # Calculator
    kdePackages.ark           # Archive manager (zip, tar, 7z, etc.)
    kdePackages.filelight     # Visual disk usage — handy for Nix store exploration
    kdePackages.dolphin       # File manager (works standalone outside KDE too)
    kdePackages.gwenview      # Image viewer
    kdePackages.spectacle     # Screenshot tool (KDE session)

    # ── Niri status bar ───────────────────────────────────────────────────
    waybar               # Highly configurable status bar (config in home/radu.nix)

    # ── App launcher ──────────────────────────────────────────────────────
    fuzzel               # Fast, minimal Wayland launcher — recommended for Niri

    # ── Notifications ─────────────────────────────────────────────────────
    mako                 # Lightweight Wayland notification daemon
    libnotify            # `notify-send` CLI to fire notifications from scripts

    # ── Wallpaper ─────────────────────────────────────────────────────────
    swaybg               # Simple wallpaper setter (solid colour or image)
    # swww               # Animated wallpaper daemon — uncomment if you want GIF wallpapers

    # ── Screenshots ───────────────────────────────────────────────────────
    grim                 # Wayland screenshot tool (whole screen or region)
    slurp                # Interactive region selector (used with grim)

    # ── Screen lock ───────────────────────────────────────────────────────
    swaylock             # Lock screen (works on all Wayland compositors)
    swayidle             # Idle daemon (auto-lock after N seconds of inactivity)

    # ── Clipboard ─────────────────────────────────────────────────────────
    wl-clipboard         # `wl-copy` and `wl-paste` — Wayland clipboard CLI
    cliphist             # Clipboard history manager (bind to a key in niri config)

    # ── Media controls ────────────────────────────────────────────────────
    playerctl            # CLI media player control (play/pause/next via key bindings)
    pavucontrol          # PulseAudio/PipeWire volume control GUI

    # ── Brightness (bare metal only — harmless in VM) ─────────────────────
    brightnessctl        # Screen brightness control

    # ── General Wayland / Qt support ──────────────────────────────────────
    xdg-utils            # `xdg-open` file association handling
    qt6.qtwayland        # Qt 6 Wayland platform plugin
    libsForQt5.qt5ct     # Qt 5 style configurator

  ];

  # ── Qt platform theme ──────────────────────────────────────────────────────
  # Ensures Qt 5 and Qt 6 apps use the Breeze theme and respect dark mode.
  qt = {
    enable         = true;
    platformTheme  = "kde";
    style          = "breeze";
  };
}
