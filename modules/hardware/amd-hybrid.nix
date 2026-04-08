{ config, pkgs, lib, ... }:
{
  # OpenGL / Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ]; # Load AMD driver

  # Hybrid graphics setup for Intel CPU + AMD GPU (PRIME)
  hardware.amdgpu.initrd.enable = true;

  environment.systemPackages = with pkgs; [
    # Tools to monitor AMD GPUs
    radeontop
    vulkan-tools
    glxinfo
  ];
}
