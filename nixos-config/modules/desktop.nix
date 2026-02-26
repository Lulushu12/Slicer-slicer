# KDE Plasma 6 desktop environment.
#
# Note on Wayland vs X11 in VirtualBox:
#   VirtualBox guest additions work much better with X11 — screen auto-resize,
#   clipboard sharing, and drag-and-drop all rely on the X11 display driver.
#   We use X11 here for reliability inside the VM.
#
#   When you move to real hardware, switch to Wayland by:
#     1. Removing `services.displayManager.sddm.settings` below
#     2. Adding: `services.displayManager.sddm.wayland.enable = true;`

{ pkgs, ... }:

{
  # ── Login manager (SDDM) ─────────────────────────────────────────────────────
  # SDDM is the display manager (login screen) that ships with KDE.
  services.displayManager.sddm = {
    enable       = true;
    # Force the X11 session — more reliable in VirtualBox.
    # Remove this block and enable wayland.enable on real hardware.
    settings.General.DisplayServer = "x11";
  };

  # ── Desktop environment ──────────────────────────────────────────────────────
  services.desktopManager.plasma6.enable = true;

  # X11 server — required for KDE on X11 and for XWayland compatibility.
  services.xserver = {
    enable = true;
    xkb.layout  = "us";  # Keyboard layout inside the GUI. Change to "ro" if preferred.
    xkb.variant = "";
  };

  # ── KDE & system applications ────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    kdePackages.kate          # KDE text editor (good for editing .nix files)
    kdePackages.kcalc         # Calculator
    kdePackages.ark           # Archive manager (zip, tar, etc.)
    kdePackages.filelight     # Disk usage visualizer — handy for Nix store
    firefox                   # Web browser
    xdg-utils                 # Makes `xdg-open` work (open files with correct app)
  ];

  # ── XDG portals ──────────────────────────────────────────────────────────────
  # Required for file pickers, screen sharing, and app sandboxing to work
  # correctly in KDE (especially with Flatpak apps, if you add them later).
  xdg.portal = {
    enable      = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };
}
