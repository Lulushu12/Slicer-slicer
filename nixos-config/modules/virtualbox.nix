# VirtualBox guest additions.
#
# What this enables:
#   - Automatic screen resolution adjustment when you resize the VM window
#   - Shared clipboard between host and VM (set in VirtualBox: Devices → Clipboard)
#   - Drag-and-drop between host and VM
#   - Shared folders (mount with: `sudo mount -t vboxsf <sharename> /mnt/share`)
#     Members of the `vboxsf` group can access shared folders without sudo.
#
# The guest additions version is kept in sync with your VirtualBox installation
# automatically by NixOS — no manual updates needed.

{ ... }:

{
  virtualisation.virtualbox.guest = {
    enable       = true;
    dragAndDrop  = true;
  };
}
