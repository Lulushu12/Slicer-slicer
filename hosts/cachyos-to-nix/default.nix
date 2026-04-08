{ config, pkgs, lib, ... }:
  imports = [
    ./hardware.nix
    ./networking.nix
    ../../modules/system/boot.nix
    ../../modules/system/localization.nix
    ../../modules/system/services.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/desktop/kde.nix
    ../../modules/desktop/gnome.nix
    ../../modules/shell/shell-config.nix
    ../../modules/gaming/gaming.nix
    ../../modules/development/dev-tools.nix
  ];

  # System version (change with caution)
  system.stateVersion = "24.05";

  # Basic system settings
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;
    };
  };
}
