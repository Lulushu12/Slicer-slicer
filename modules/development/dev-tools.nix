{ config, pkgs, lib, ... }:
  # Development tools and utilities

  environment.systemPackages = with pkgs; [
    # Build tools
    gcc
    clang
    make
    cmake
    ninja
    meson
    autoconf
    automake
    libtool
    pkg-config

    # Version control
    git
    mercurial

    # Compilers & runtimes
    python3
    python312
    go
    rust
    rustup
    nodejs_20
    nodePackages.npm
    nodePackages.pnpm
    ruby
    php
    java

    # Package managers
    # No paru, use nix-env or nix shell
    cargo
    pip

    # Debuggers & profilers
    gdb
    lldb
    valgrind
    perf

    # Text editors
    vim
    neovim
    nano
    emacs
    micro

    # IDE & editors
    vscode
    jetbrains.idea-community
    jetbrains.clion
    sublime4
    helix

    # Documentation
    man-db
    man-pages
    tldr
    texi2html
    doxygen

    # Language servers
    clang-tools
    nodePackages.typescript-language-server
    pylsp
    gopls
    rust-analyzer

    # Code analysis & formatting
    shellcheck
    shfmt
    prettier
    black
    rustfmt
    clang-format

    # API & Web tools
    curl
    wget
    httpie
    postman
    insomnia

    # Docker & containers
    docker
    docker-compose
    podman
    containerd

    # Version management tools
    asdf
    nvm

    # Terminal utilities
    tmux
    screen
    zsh
    bash
    fish

    # File tools
    ripgrep
    fd
    eza
    lsd
    tree
    ncdu

    # System monitoring
    htop
    btop
    glances
    iotop
    nethogs
    iftop

    # Terminal multiplexers & helpers
    fzf
    bat
    delta
    enhancd

    # Documentation & note-taking
    pandoc
    hugo
    sphinx

    # Misc dev tools
    direnv
    nix-direnv
  ];

  # Optional: Enable direnv for automatic environment loading
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Optional: Enable git with LFS
  programs.git = {
    enable = true;
  };

  # Optional: Configure SSH for development
  services.openssh.enable = true;
}
