{ config, pkgs, ... }:

{
  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    dotDir = ".config/zsh";
    history = {
      extended = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 10000;
      size = 10000;
    };

    # Powerlevel10k prompt
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk62ybfe2b6mtpy8c34lbdnigypwgipg";
        };
      }
    ];

    initExtra = ''
      # p10k initialization
      if [[ -r "$HOME/.config/zsh/.p10k.zsh" ]]; then
        source "$HOME/.config/zsh/.p10k.zsh"
      fi

      # Add local bin to PATH
      export PATH="$HOME/.local/bin:$PATH"

      # Aliases
      alias ll='ls -lah'
      alias la='ls -la'
      alias l='ls -lh'
      alias cls='clear'
      alias grep='grep --color=auto'
      alias diff='diff --color=auto'
      alias ip='ip -color=auto'

      # Dev aliases
      alias gs='git status'
      alias ga='git add'
      alias gc='git commit'
      alias gp='git push'
      alias gl='git log --oneline -n 20'

      # nix aliases
      alias nfl='nix flake lock'
      alias nfu='nix flake update'
      alias nfn='nix flake new'
      alias nds='nix develop'
    '';

    shellAliases = {
      # Basic navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "cd-" = "cd -";
    };
  };

  # Bash configuration (fallback)
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      # Add local bin to PATH
      export PATH="$HOME/.local/bin:$PATH"

      # Aliases
      alias ll='ls -lah'
      alias la='ls -la'
    '';
  };

  # Starship prompt (alternative, disable if using p10k)
  # programs.starship = {
  #   enable = true;
  #   settings = {
  #     add_newline = false;
  #   };
  # };

  # direnv integration
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # fzf integration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # git configuration
  programs.git = {
    enable = true;
    userName = "radu";
    userEmail = "radu@example.com";  # Change to actual email
    extraConfig = {
      core.editor = "vim";
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };

  # bat (cat replacement)
  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      style = "numbers,changes";
    };
  };

  # eza (ls replacement)
  programs.eza = {
    enable = true;
    enableAliases = true;
  };

  # tmux configuration
  programs.tmux = {
    enable = true;
    historyLimit = 10000;
    baseIndex = 1;
    keyMode = "vi";
  };
}
