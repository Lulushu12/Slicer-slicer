# Home Manager configuration for user "radu".
#
# This file manages everything at the user level:
#   - Packages installed just for you (not system-wide)
#   - Shell aliases and configuration
#   - Git identity
#   - Dotfiles (editor settings, etc.)
#
# Apply changes with the same command as system changes:
#   sudo nixos-rebuild switch --flake /etc/nixos#nixos

{ pkgs, ... }:

{
  # Track which Home Manager release this config was written for.
  # Do NOT change this after first activation.
  home.stateVersion = "24.11";

  home.username    = "radu";
  home.homeDirectory = "/home/radu";

  # ── User packages ────────────────────────────────────────────────────────────
  # Add programs here. They live in your profile, not system-wide.
  # Search available packages: https://search.nixos.org/packages
  home.packages = with pkgs; [
    # ── Terminal utilities ───────────────────────────────────────────────────
    htop        # Interactive process viewer
    btop        # More visual process/resource monitor
    tree        # Print directory tree
    ripgrep     # Blazing-fast text search (`rg` command)
    bat         # Better `cat` — syntax highlighting, paging
    eza         # Better `ls` — colors, icons, git status
    fd          # Better `find` — simple syntax
    fzf         # Fuzzy finder — integrates with shell history, cd, etc.
    jq          # Parse and query JSON in the terminal
    duf         # Better `df` — disk usage overview
    ncdu        # Interactive disk usage browser (useful for Nix store exploration)

    # ── Nix development helpers ──────────────────────────────────────────────
    nix-tree      # Visualise what's in a derivation's dependency tree
    nixpkgs-fmt   # Format .nix files (`nixpkgs-fmt file.nix`)
    nix-diff      # Show what changed between two Nix builds
    nvd           # Show package diffs between NixOS generations

    # ── Editors / IDE ────────────────────────────────────────────────────────
    # Uncomment what you want:
    # vscode          # VS Code — also configurable declaratively via programs.vscode
    # jetbrains.idea-community

    # ── Misc ─────────────────────────────────────────────────────────────────
    # vlc           # Media player
    # libreoffice   # Office suite
  ];

  # ── Shell: Bash ──────────────────────────────────────────────────────────────
  # Home Manager writes a ~/.bashrc that loads all the settings below.
  programs.bash = {
    enable = true;

    shellAliases = {
      # ── NixOS shortcuts ─────────────────────────────────────────────────────
      # Apply your config changes:
      rebuild  = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      # Test without committing (rolls back on reboot):
      testbuild = "sudo nixos-rebuild test --flake /etc/nixos#nixos";
      # Roll back to the previous working generation:
      rollback = "sudo nixos-rebuild switch --rollback";
      # Update all flake inputs (nixpkgs, home-manager) then rebuild:
      update   = "sudo nix flake update /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      # Delete old generations to free disk space:
      clean    = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

      # ── Better defaults ──────────────────────────────────────────────────────
      ls   = "eza --icons";
      ll   = "eza -la --icons --git";
      la   = "eza -a --icons";
      lt   = "eza --tree --icons";
      cat  = "bat --paging=never";
      grep = "rg";
      find = "fd";

      # ── Navigation ───────────────────────────────────────────────────────────
      ".."  = "cd ..";
      "..." = "cd ../..";
    };

    initExtra = ''
      # ── fzf shell integration ─────────────────────────────────────────────
      # Ctrl+R: fuzzy-search your shell history
      # Ctrl+T: fuzzy-find a file and paste its path
      eval "$(fzf --bash)"

      # ── Show NixOS generation info ────────────────────────────────────────
      # Type `nixgen` to see your current and recent generations.
      nixgen() {
        echo "=== Current generation ==="
        nixos-rebuild list-generations | grep current
        echo ""
        echo "=== Recent generations (newest first) ==="
        nixos-rebuild list-generations | tail -n +2 | head -10
      }

      # ── Nix store shortcuts ───────────────────────────────────────────────
      # Type `nixwhy <package>` to see what depends on a package in the store.
      nixwhy() { nix-store --query --referrers "$(which "$1")"; }
    '';
  };

  # ── Git ──────────────────────────────────────────────────────────────────────
  programs.git = {
    enable    = true;
    userName  = "Radu";
    userEmail = "your@email.com";  # ← change this

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase        = false;   # Use merge strategy on pull (change to true for rebase)
      core.editor        = "vim";
      # Colourful, readable log output
      alias.lg = "log --oneline --graph --decorate --all";
    };

    # Highlight whitespace errors, show diffs in a readable format
    diff-so-fancy.enable = false;  # Set to true if you want fancy diffs (installs diff-so-fancy)
  };

  # ── Direnv ───────────────────────────────────────────────────────────────────
  # Automatically loads per-project Nix environments when you cd into a directory.
  # This is very useful once you start doing development with Nix flakes.
  programs.direnv = {
    enable            = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;  # Faster, cached integration with nix develop
  };

  # ── Let Home Manager manage itself ───────────────────────────────────────────
  programs.home-manager.enable = true;
}
