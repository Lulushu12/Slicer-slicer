# QEMU / KVM guest tools with SPICE display protocol.
#
# ─── Which hypervisor are you using? ────────────────────────────────────────
# • QEMU/KVM (virt-manager, Proxmox, etc.) → import this file (default)
# • VirtualBox                              → swap to modules/virtualbox.nix
#   in hosts/nixos/default.nix
#
# What SPICE gives you inside the VM:
#   • Auto-resize: the VM display adapts when you resize the window on the host
#   • Shared clipboard between host and guest (enable SPICE channel in the
#     hypervisor settings under "Display → SPICE")
#   • USB device redirection (optional, needs SPICE USB channel enabled)
#
# What the QEMU guest agent adds:
#   • Clean shutdown / reboot from the hypervisor UI
#   • Freeze-consistent snapshots while the VM is running
#   • Memory balloon device support (dynamic memory adjustment)
#
# ─── virt-manager quick setup ────────────────────────────────────────────────
# When creating the VM, under "Display":
#   Type      → SPICE
#   Listen    → None (for local use)
# Under "Video":
#   Model     → VirtIO  (best performance, supports 3D acceleration)
# Under "Sound":
#   Model     → ich9 or virtio  (both work with PipeWire)

{ pkgs, ... }:

{
  # QEMU guest agent — hypervisor ↔ VM coordination
  services.qemuGuest.enable = true;

  # SPICE agent — clipboard sharing and dynamic screen resolution
  services.spice-vdagentd.enable = true;

  environment.systemPackages = [
    pkgs.spice-vdagent  # User-space SPICE agent (clipboard, resize)
  ];
}
