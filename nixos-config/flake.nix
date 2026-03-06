{
  description = "Radu's NixOS system configuration";

  inputs = {
    # NixOS stable channel — everything is pinned to the same version.
    # To upgrade later: run `nix flake update` then `sudo nixos-rebuild switch --flake /etc/nixos#nixos`
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      # Reuse the same nixpkgs as the system — avoids downloading a second copy.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    nixosSystem = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # ── System configuration ────────────────────────────────────────────
        ./hosts/nixos/default.nix

        # ── Home Manager (manages user-level config alongside system) ───────
        home-manager.nixosModules.homeManager
        {
          # Share system nixpkgs — no duplicate downloads
          home-manager.useGlobalPkgs = true;
          # Install user packages to /etc/profiles instead of ~/.nix-profile
          home-manager.useUserPackages = true;
          # Back up any dotfiles that conflict instead of failing
          home-manager.backupFileExtension = "backup";

          home-manager.users.radu = import ./home/radu.nix;
        }
      ];
    };
  in
  {
    nixosConfigurations = {
      nixos = nixosSystem;
      # Alias for CI systems that append --no-write-lock-file to the hostname
      "nixos--no-write-lock-file" = nixosSystem;
    };
  };
}
