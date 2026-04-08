{ config, pkgs, ... }:

{
  # Development tools and environment configuration for home-manager

  home.packages = with pkgs; [
    # IDEs
    vscode
    vscodium
    jetbrains.idea-community
    sublime4

    # Language-specific tools
    nodejs_20
    nodePackages.npm
    nodePackages.pnpm
    yarn
    nodePackages.typescript
    nodePackages.prettier

    python312
    python312Packages.pip
    python312Packages.virtualenv
    pyright
    black
    mypy
    flake8
    isort

    rustup
    rust-analyzer
    cargo-edit
    cargo-watch
    cargo-expand

    go
    gopls
    golangci-lint

    # Build tools
    just
    cargo-make
    meson
    ninja
    cmake

    # API testing
    insomnia
    postman
    httpie

    # Database tools
    dbeaver
    sqlitebrowser

    # Docker
    docker
    docker-compose
    lazydocker

    # Git tools
    gitFull
    gh  # GitHub CLI
    lazygit
    git-lfs

    # Terminal tools for dev
    ripgrep
    fd
    fzf
    jq
    yq
    xmlstarlet

    # Debugging
    gdb
    lldb
    valgrind

    # Documentation
    pandoc
    ghostscript
  ];

  # Nix development flakes integration
  home.file.".config/nix/flake-utils.nix" = {
    text = ''
      # Template for new flake.nix files
      # Copy this to your project directory as flake.nix and customize
    '';
  };

  # Environment variables for development
  home.sessionVariables = {
    RUSTFLAGS = "-C target-cpu=native";
    GOPATH = "$HOME/.local/share/go";
    PYTHONPATH = "$HOME/.local/lib/python3.12/site-packages";
  };

  # direnv configuration
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      use_flake() {
        watch_file flake.nix flake.lock
        if [[ ! -f flake.nix ]]; then
          log_error 'No flake.nix found'
          return 1
        fi
        eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
      }
    '';
  };

  # VS Code configuration (optional)
  programs.vscode = {
    enable = false;  # Set to true if you want home-manager to manage VSCode
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      rust-lang.rust-analyzer
      golang.Go
      ms-vscode.cpptools
      github.copilot
    ];
    userSettings = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.formatOnSave" = true;
      "python.linting.enabled" = true;
      "python.linting.pylintEnabled" = true;
    };
  };

  # Helix editor configuration (modern vim alternative)
  programs.helix = {
    enable = false;  # Set to true if you prefer Helix over Vim
    settings = {
      editor = {
        line-number = "relative";
        mouse = true;
        auto-save = true;
      };
    };
  };
}
