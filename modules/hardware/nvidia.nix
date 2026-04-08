{ config, pkgs, lib, ... }:
  # NVIDIA RTX 2070 SUPER Configuration
  # Proprietary driver (open source available but proprietary is more stable for Turing)

  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # For 32-bit games on Steam
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Use proprietary drivers (most stable for RTX 2070)
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Vulkan and OpenGL support
  hardware.graphics.extraPackages = with pkgs; [
    vulkan-loader
    vulkan-tools
  ];

  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [
    vulkan-loader
  ];

  # NVIDIA-specific packages
  environment.systemPackages = with pkgs; [
    nvidia-settings
    nvidia-utils
    cudatoolkit
  ];

  # Power management (RTX 2070 doesn't support newer features like suspend)
  powerManagement.enable = true;
}
