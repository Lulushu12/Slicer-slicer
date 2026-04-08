{ config, pkgs, lib, ... }:
  # Shell configuration at system level

  # Set default shell to zsh for root
  users.defaultUserShell = pkgs.zsh;

  # Enable zsh at system level
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
    syntaxHighlighting.enable = true;
  };

  # Fish shell
  programs.fish = {
    enable = true;
  };

  # Bash configuration
  programs.bash = {
    completion.enable = true;
  };

  # System-wide packages for shell utilities
  environment.systemPackages = with pkgs; [
    # Shell tools
    zsh
    zsh-completions
    zsh-syntax-highlighting
    zsh-autosuggestions
    fish
    bash-completion

    # Terminal multiplexers
    tmux
    screen

    # Modern replacements for classic tools
    ripgrep
    fd
    fzf
    bat
    delta
    eza
    lsd
    tree

    # File utilities
    unzip
    unrar
    p7zip
    tar
    gzip
    xz
    bzip2

    # Compression
    zip
    zstd

    # Network utilities
    curl
    wget
    openssh
    mtr
    iperf
    bind
    dnsutils

    # System utilities
    htop
    btop
    glances
    duf
    ncdu
    lsof
    strace
    ltrace

    # Text processing
    sed
    awk
    grep
    gawk

    # Utilities
    jq
    yq
    diffutils
    patchutils
    less
  ];
}
