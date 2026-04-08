{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware.nix
    ./networking.nix
    ../../modules/system/boot.nix
    ../../modules/system/localization.nix
    ../../modules/system/services.nix
    ../../modules/hardware/amd-hybrid.nix
    ../../modules/hardware/laptop.nix
    ../../modules/desktop/kde.nix
    ../../modules/desktop/gnome.nix
    ../../modules/shell/shell-config.nix
    ../../modules/gaming/gaming.nix
    ../../modules/development/dev-tools.nix
  ];

  # System version
  system.stateVersion = "24.05";

  # Allow proprietary software
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    auto-optimise-store = true;
    max-jobs = "auto";
  };
}
