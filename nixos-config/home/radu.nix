# Home Manager configuration for user "radu".
#
# Manages everything at the user level:
#   • Packages installed just for you
#   • Shell (zsh) + prompt (starship) configuration
#   • Terminal emulator (kitty)
#   • Theming (GTK dark mode, Qt)
#   • Git defaults
#   • Dot-files for Niri, Waybar, Mako, Fuzzel
#
# Apply changes:   rebuild   (alias defined below)

{ pkgs, config, ... }:

{
  home.stateVersion  = "24.11";
  home.username      = "radu";
  home.homeDirectory = "/home/radu";

  # ── Session environment variables ──────────────────────────────────────────
  home.sessionVariables = {
    EDITOR  = "kate";
    VISUAL  = "kate";
    BROWSER = "brave";
    # Native Wayland rendering for Electron apps (Obsidian, etc.)
    NIXOS_OZONE_EL     = "1";
    # Native Wayland for Firefox-based browsers (Brave, Mullvad, etc.)
    MOZ_ENABLE_WAYLAND = "1";
    # Qt Wayland backend with X11 fallback
    QT_QPA_PLATFORM    = "wayland;xcb";
  };

  # ════════════════════════════════════════════════════════════════════════════
  # PACKAGES
  # ════════════════════════════════════════════════════════════════════════════

  home.packages = with pkgs; [

    # ── Browsers ──────────────────────────────────────────────────────────────
    brave            # Chromium-based, built-in ad/tracker blocking
    vivaldi          # Feature-rich Chromium browser (unfree)
    mullvad-browser  # Privacy-hardened Firefox build

    # ── Multimedia: video / audio ─────────────────────────────────────────────
    vlc              # Universal media player
    spotify          # Music streaming (unfree)
    obs-studio       # Screen recording and streaming

    # ── Multimedia: image / vector ────────────────────────────────────────────
    gimp                      # Raster image editor
    inkscape-with-extensions  # Vector graphics editor (full)

    # ── Multimedia: video editing ─────────────────────────────────────────────
    kdenlive         # Non-linear video editor (KDE-native)
    # davinci-resolve  # DISABLED in VM: requires a real GPU.
    #                  # Uncomment on bare metal with a working GPU driver.

    # ── 3D / creative ─────────────────────────────────────────────────────────
    blender          # 3D modelling and animation (CPU rendering in VM — slow but works)

    # ── Communication ─────────────────────────────────────────────────────────
    vesktop          # Open-source Discord client

    # ── Productivity ──────────────────────────────────────────────────────────
    libreoffice-fresh  # Full office suite
    obsidian           # Markdown knowledge base (unfree)

    # ── Dev: Python ───────────────────────────────────────────────────────────
    python3  # Python 3 interpreter
    uv       # Fast package/env manager (replaces pip + pyenv + venv)

    # ── Dev: JavaScript / Node ────────────────────────────────────────────────
    nodejs_22   # Node.js LTS (includes npm and npx)
    pnpm        # Fast, disk-efficient package manager

    # ── Dev: Rust ─────────────────────────────────────────────────────────────
    # After first rebuild: rustup default stable
    rustup

    # ── Dev: Go ───────────────────────────────────────────────────────────────
    go       # Go compiler
    gopls    # Go language server
    gotools  # goimports and friends

    # ── Dev: Nix ──────────────────────────────────────────────────────────────
    nil        # Nix language server (autocomplete for .nix files)
    statix     # Nix linter
    deadnix    # Find unused variables in .nix files
    nh         # Nicer nixos-rebuild wrapper (`nh os switch`)
    nix-tree   # Visualise derivation dependency tree
    nix-diff   # Diff two Nix builds
    nvd        # Show package diffs between generations
    nixpkgs-fmt  # Format .nix files

    # ── Dev: misc ─────────────────────────────────────────────────────────────
    gh        # GitHub CLI
    lazygit   # Terminal UI for git

    # ── Terminal utilities ─────────────────────────────────────────────────────
    htop      # Process viewer
    btop      # Visual resource monitor
    tree      # Directory tree printer
    ripgrep   # Fast text search (rg)
    bat       # Better cat (syntax highlighting)
    eza       # Better ls (icons, git status)
    fd        # Better find
    fzf       # Fuzzy finder (Ctrl+R, Ctrl+T)
    jq        # JSON processor
    yq-go     # Like jq for YAML/TOML/XML
    duf       # Visual disk usage (df replacement)
    ncdu      # Interactive disk usage browser
    zoxide    # Smart cd that learns your dirs
    tldr      # Simplified man pages
    nix-index # Package-to-file index (command-not-found handler)
    p7zip     # 7-Zip CLI
    unrar     # Extract .rar archives

  ];

  # ════════════════════════════════════════════════════════════════════════════
  # SHELL: ZSH
  # ════════════════════════════════════════════════════════════════════════════

  programs.zsh = {
    enable            = true;
    enableCompletion  = true;
    autosuggestion.enable     = true;  # Grey suggestion as you type
    syntaxHighlighting.enable = true;  # Green = valid cmd, red = not found

    history = {
      size       = 50000;
      save       = 50000;
      path       = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      share      = true;   # Shared across all terminal windows
      extended   = true;   # Save timestamps
    };

    oh-my-zsh = {
      enable  = true;
      plugins = [
        "git"                # Aliases: gst, gcmsg, gp, gl, gd, gco, gcb…
        "sudo"               # Esc Esc → prepend sudo to last command
        "z"                  # `z proj` → jump to ~/code/my-project
        "colored-man-pages"  # Syntax-highlighted man pages
      ];
      theme = "";  # Disabled — starship handles the prompt
    };

    shellAliases = {
      # NixOS management
      rebuild   = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      testbuild = "sudo nixos-rebuild test --flake /etc/nixos#nixos";
      rollback  = "sudo nixos-rebuild switch --rollback";
      update    = "sudo nix flake update /etc/nixos && rebuild";
      clean     = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

      # Better defaults
      ls   = "eza --icons";
      ll   = "eza -la --icons --git";
      la   = "eza -a --icons";
      lt   = "eza --tree --icons";
      cat  = "bat --paging=never";
      grep = "rg";
      find = "fd";
      cd   = "z";

      # Navigation
      ".."   = "z ..";
      "..."  = "z ../..";
      "...." = "z ../../..";

      # Git extras (beyond oh-my-zsh git plugin)
      lg   = "lazygit";
      glog = "git log --oneline --graph --decorate --all";

      # Nix one-liners
      nsh  = "nix shell nixpkgs#";   # nsh ripgrep → temp shell with ripgrep
      nrun = "nix run nixpkgs#";     # nrun cowsay -- hello
    };

    initExtra = ''
      # zoxide — must be initialised after oh-my-zsh
      eval "$(zoxide init zsh)"

      # Show NixOS generation info
      nixgen() {
        echo "=== Current generation ==="
        nixos-rebuild list-generations | grep current
        echo ""
        echo "=== Recent generations (newest first) ==="
        nixos-rebuild list-generations | tail -n +2 | head -10
      }

      # Find what installed a given binary
      nixwhy() { nix-store --query --referrers "$(which "$1")"; }

      # command-not-found: suggests the nixpkgs package that contains a missing command.
      # Run `nix-index` once to build the database (~10 min).
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
  };

  # ════════════════════════════════════════════════════════════════════════════
  # PROMPT: STARSHIP
  # ════════════════════════════════════════════════════════════════════════════

  programs.starship = {
    enable               = true;
    enableZshIntegration = true;
    settings = {
      add_newline     = true;
      command_timeout = 1000;
      directory.truncation_length   = 3;
      directory.truncate_to_repo    = true;
      package.disabled              = true;
    };
  };

  # ════════════════════════════════════════════════════════════════════════════
  # TERMINAL: KITTY  (Tokyo Night colour scheme)
  # ════════════════════════════════════════════════════════════════════════════

  programs.kitty = {
    enable = true;
    font   = { name = "JetBrainsMono Nerd Font"; size = 13; };
    settings = {
      # Colours
      background           = "#1a1b26";
      foreground           = "#c0caf5";
      selection_background = "#283457";
      selection_foreground = "#c0caf5";
      cursor               = "#c0caf5";
      cursor_text_color    = "#1a1b26";
      url_color            = "#73daca";

      color0  = "#15161e";  color8  = "#414868";
      color1  = "#f7768e";  color9  = "#f7768e";
      color2  = "#9ece6a";  color10 = "#9ece6a";
      color3  = "#e0af68";  color11 = "#e0af68";
      color4  = "#7aa2f7";  color12 = "#7aa2f7";
      color5  = "#bb9af7";  color13 = "#bb9af7";
      color6  = "#7dcfff";  color14 = "#7dcfff";
      color7  = "#a9b1d6";  color15 = "#c0caf5";

      # Behaviour
      background_opacity    = "0.95";
      window_padding_width  = 8;
      scrollback_lines      = 10000;
      enable_audio_bell     = false;
      copy_on_select        = "clipboard";
      strip_trailing_spaces = "smart";

      # Tab bar
      hide_window_decorations = "yes";
      tab_bar_style           = "powerline";
      tab_bar_min_tabs        = 2;
    };
  };

  # ════════════════════════════════════════════════════════════════════════════
  # MEDIA PLAYER: MPV
  # ════════════════════════════════════════════════════════════════════════════

  programs.mpv = {
    enable = true;
    config = {
      profile               = "gpu-hq";
      vo                    = "gpu";
      hwdec                 = "auto-safe";
      sub-auto              = "fuzzy";
      volume                = 75;
      save-position-on-quit = true;
    };
  };

  # ════════════════════════════════════════════════════════════════════════════
  # GIT
  # ════════════════════════════════════════════════════════════════════════════

  programs.git = {
    enable = true;
    # No name/email here — set locally with:
    #   git config --global user.name  "Your Name"
    #   git config --global user.email "you@example.com"
    extraConfig = {
      init.defaultBranch   = "main";
      pull.rebase          = true;
      push.autoSetupRemote = true;
      core.editor          = "vim";
      merge.conflictstyle  = "diff3";
      alias.lg   = "log --oneline --graph --decorate --all";
      alias.undo = "reset HEAD~1 --mixed";
      alias.wip  = "commit -am 'WIP'";
    };
    delta = {
      enable  = true;
      options = {
        navigate     = true;
        line-numbers = true;
        dark         = true;
        syntax-theme = "TwoDark";
      };
    };
  };

  # ════════════════════════════════════════════════════════════════════════════
  # DIRENV  (per-project Nix environments)
  # ════════════════════════════════════════════════════════════════════════════

  programs.direnv = {
    enable               = true;
    enableZshIntegration = true;
    nix-direnv.enable    = true;
  };

  # ════════════════════════════════════════════════════════════════════════════
  # THEMING: GTK (dark mode — Breeze Dark + Papirus icons)
  # ════════════════════════════════════════════════════════════════════════════

  gtk = {
    enable = true;
    theme       = { name = "Breeze-Dark";     package = pkgs.kdePackages.breeze; };
    iconTheme   = { name = "Papirus-Dark";    package = pkgs.papirus-icon-theme; };
    cursorTheme = { name = "breeze_cursors";  package = pkgs.kdePackages.breeze; size = 24; };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  # ════════════════════════════════════════════════════════════════════════════
  # THEMING: QT (mirrors GTK dark mode)
  # ════════════════════════════════════════════════════════════════════════════

  qt = {
    enable             = true;
    platformTheme.name = "kde";
    style = { name = "breeze"; package = pkgs.kdePackages.breeze; };
  };

  # ════════════════════════════════════════════════════════════════════════════
  # DOT-FILE: NIRI compositor config
  # ════════════════════════════════════════════════════════════════════════════
  # Reload without restarting: niri msg action reload-config

  home.file.".config/niri/config.kdl".text = ''
    prefer-no-csd

    input {
        keyboard {
            xkb {
                layout "us"
            }
            repeat-delay 300
            repeat-rate  50
        }
        touchpad {
            tap
            natural-scroll
            dwt
        }
    }

    // Run `niri msg outputs` to find your display name and modes.
    // Uncomment and adjust if you need a specific resolution:
    // output "Virtual-1" {
    //     mode "1920x1080@60.0"
    //     scale 1.0
    // }

    layout {
        gaps 12
        default-column-width { proportion 0.5; }
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            proportion 1.0
        }
        focus-ring {
            width 2
            active-color   "#7aa2f7"
            inactive-color "#414868"
        }
        border {
            off
        }
    }

    animations {
        slowdown 1.0
    }

    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    // Solid dark background. Replace with a wallpaper path if you want one:
    //   spawn-at-startup "swaybg" "-i" "/path/to/wallpaper.jpg" "-m" "fill"
    spawn-at-startup "swaybg" "-c" "#1a1b26"

    window-rule {
        geometry-corner-radius 8
        clip-to-geometry true
    }
    window-rule {
        match app-id="org.kde.ark"
        open-floating true
    }
    window-rule {
        match app-id="org.kde.kcalc"
        open-floating true
    }
    window-rule {
        match app-id="pavucontrol"
        open-floating true
    }


    binds {
        Mod+Return  { spawn "kitty"; }
        Mod+D       { spawn "fuzzel"; }

        Mod+Q         { close-window; }
        Mod+F         { maximize-column; }
        Mod+Shift+F   { fullscreen-window; }
        Mod+R         { switch-preset-column-width; }
        Mod+C         { center-column; }

        Mod+H     { focus-column-left; }
        Mod+L     { focus-column-right; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }

        Mod+Shift+H     { move-column-left; }
        Mod+Shift+L     { move-column-right; }
        Mod+Shift+J     { move-window-down-or-to-workspace-down; }
        Mod+Shift+K     { move-window-up-or-to-workspace-up; }
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Down  { move-window-down-or-to-workspace-down; }
        Mod+Shift+Up    { move-window-up-or-to-workspace-up; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-window-to-workspace 1; }
        Mod+Shift+2 { move-window-to-workspace 2; }
        Mod+Shift+3 { move-window-to-workspace 3; }
        Mod+Shift+4 { move-window-to-workspace 4; }
        Mod+Shift+5 { move-window-to-workspace 5; }
        Mod+Shift+6 { move-window-to-workspace 6; }
        Mod+Shift+7 { move-window-to-workspace 7; }
        Mod+Shift+8 { move-window-to-workspace 8; }
        Mod+Shift+9 { move-window-to-workspace 9; }

        Print       { screenshot; }
        Ctrl+Print  { screenshot-screen; }
        Alt+Print   { screenshot-window; }

        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute"   "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioPlay  { spawn "playerctl" "play-pause"; }
        XF86AudioNext  { spawn "playerctl" "next"; }
        XF86AudioPrev  { spawn "playerctl" "previous"; }

        XF86MonBrightnessUp   { spawn "brightnessctl" "s" "10%+"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "s" "10%-"; }

        Mod+V       { spawn "sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"; }
        Mod+Escape  { spawn "swaylock" "--color" "1a1b26"; }

        Mod+Shift+E { quit; }
        Mod+Shift+P { power-off-monitors; }
    }
  '';

  # ════════════════════════════════════════════════════════════════════════════
  # DOT-FILE: WAYBAR
  # ════════════════════════════════════════════════════════════════════════════

  home.file.".config/waybar/config.jsonc".text = ''
    {
        "layer": "top",
        "position": "top",
        "height": 34,
        "spacing": 4,
        "modules-left":   ["niri/workspaces", "niri/window"],
        "modules-center": ["clock"],
        "modules-right":  ["pulseaudio", "cpu", "memory", "network", "tray"],

        "niri/workspaces": {
            "format": "{icon}",
            "format-icons": { "active": "●", "default": "○" }
        },
        "niri/window": { "max-length": 50 },

        "clock": {
            "format":     "{:%H:%M}",
            "format-alt": "{:%A, %d %B %Y  %H:%M}",
            "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
        },
        "cpu":    { "format": " {usage}%", "interval": 5 },
        "memory": { "format": " {percentage}%", "interval": 10 },
        "pulseaudio": {
            "format":       "{icon} {volume}%",
            "format-muted": "󰝟 muted",
            "format-icons": { "default": ["󰕿", "󰖀", "󰕾"] },
            "on-click": "pavucontrol",
            "scroll-step": 5
        },
        "network": {
            "format-wifi":        " {essid}",
            "format-ethernet":    " connected",
            "format-disconnected": "⚠ disconnected",
            "tooltip-format":     "{ifname}: {ipaddr}/{cidr}"
        },
        "tray": { "spacing": 8 }
    }
  '';

  home.file.".config/waybar/style.css".text = ''
    * { font-family: "JetBrainsMono Nerd Font", monospace; font-size: 13px; border: none; border-radius: 0; min-height: 0; }

    window#waybar { background: #1a1b26; color: #c0caf5; border-bottom: 2px solid #414868; }

    #workspaces button           { padding: 0 6px; color: #565f89; background: transparent; }
    #workspaces button.active    { color: #7aa2f7; }
    #workspaces button:hover     { background: #24283b; color: #c0caf5; }

    #window    { color: #9ece6a;  padding: 0 8px; }
    #clock     { color: #bb9af7; font-weight: bold; }
    #cpu       { color: #7dcfff; padding: 0 8px; }
    #memory    { color: #9ece6a; padding: 0 8px; }
    #network   { color: #73daca; padding: 0 8px; }
    #pulseaudio          { color: #e0af68; padding: 0 8px; }
    #pulseaudio.muted    { color: #565f89; }
    #tray      { padding: 0 8px; }
  '';

  # ════════════════════════════════════════════════════════════════════════════
  # DOT-FILE: MAKO (notifications)
  # ════════════════════════════════════════════════════════════════════════════

  home.file.".config/mako/config".text = ''
    background-color=#1a1b26
    text-color=#c0caf5
    border-color=#7aa2f7
    border-radius=8
    border-size=2
    width=320
    height=110
    margin=8
    padding=12
    font=JetBrainsMono Nerd Font 11
    default-timeout=5000
    max-visible=5

    [urgency=low]
    border-color=#565f89

    [urgency=high]
    border-color=#f7768e
    default-timeout=0
  '';

  # ════════════════════════════════════════════════════════════════════════════
  # DOT-FILE: FUZZEL (app launcher)
  # ════════════════════════════════════════════════════════════════════════════

  home.file.".config/fuzzel/fuzzel.ini".text = ''
    [main]
    font=JetBrainsMono Nerd Font:size=13
    dpi-aware=auto
    prompt=
    width=35
    lines=10
    terminal=kitty -e

    [colors]
    background=1a1b26ff
    text=c0caf5ff
    match=7aa2f7ff
    selection=414868ff
    selection-text=c0caf5ff
    selection-match=7dcfffff
    border=7aa2f7ff

    [border]
    width=2
    radius=8
  '';

  # ════════════════════════════════════════════════════════════════════════════
  programs.home-manager.enable = true;
}
