{ config, lib, pkgs, ... }:

let sources = import ../../nix/sources.nix; in {
  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    pkgs.bat
    pkgs.fd
    pkgs.firefox
    pkgs.fzf
    pkgs.git-crypt
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.rofi
    pkgs.tree
    pkgs.watch
    pkgs.zathura
    pkgs.ripgrep

    pkgs.go
    pkgs.gopls
    pkgs.zig-master

    pkgs.tlaplusToolbox
    pkgs.tetex

    pkgs.google-cloud-sdk
    pkgs.awscli2
    pkgs.kubectl
    pkgs.python
    pkgs.terraform
    pkgs.terraform-ls
    pkgs.nodejs
    pkgs.envsubst
    pkgs.neovim-nightly
    pkgs.yarn

    pkgs.buf
    pkgs.redis
    pkgs.unzip
    pkgs.ansible
  ];

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_GB.UTF-8";
    LC_CTYPE = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
    EDITOR = "nvim";
  };

  home.file.".inputrc".source = ./inputrc;

  xdg.configFile."i3/config".text = builtins.readFile ./i3;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;

  # tree-sitter parsers
  xdg.configFile."nvim/parser/proto.so".source = "${pkgs.tree-sitter-proto}/parser";
  xdg.configFile."nvim/queries/proto/folds.scm".source =
    "${sources.tree-sitter-proto}/queries/folds.scm";
  xdg.configFile."nvim/queries/proto/highlights.scm".source =
    "${sources.tree-sitter-proto}/queries/highlights.scm";
  xdg.configFile."nvim/queries/proto/textobjects.scm".source =
    ./textobjects.scm;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.command-not-found.enable = true;

  programs.gpg.enable = true;

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      glol = "git prettylog";
      gl = "git pull";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
    };
  };

  programs.direnv= {
    enable = true;

    config = {
      whitelist = {
        prefix= [
          "$HOME/code/go/src/github.com/hashicorp"
          "$HOME/code/go/src/github.com/mitchellh"
          "$HOME/code/go/src/github.com/vancelongwill"
        ];

        exact = ["$HOME/.envrc"];
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    shellAliases = {
      vim = "nvim";
    };

    initExtraBeforeCompInit = ''
fpath+=(/nix/var/nix/profiles/per-user/vance/home-manager/home-path/share/zsh/site-functions)
    '';

    initExtra = ''
export FZF_DEFAULT_COMMAND='rg --files'

# go path
export PATH=$PATH:$(go env GOPATH)
export PATH=$PATH:$(go env GOPATH)/bin

fb() {
  git branch --sort=committerdate -v --color=always | grep -v '/HEAD\s' |
      fzf --height 40% --ansi --multi --tac | sed 's/^..//' | awk '{print $1}' |
      sed 's#^remotes/[^/]*/##' | xargs git checkout
}

fba() {
  git branch -a --sort=committerdate -v --color=always | grep -v '/HEAD\s' |
      fzf --height 40% --ansi --multi --tac | sed 's/^..//' | awk '{print $1}' |
      sed 's#^remotes/[^/]*/##' | xargs git checkout
}
    '';

    oh-my-zsh = {
      enable = true;

      plugins = [
        "command-not-found"
        "git"
        "history"
      ];
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };

    plugins = [
     {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.4.0";
          sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
        };
      }
    ];

  };

  programs.git = {
    enable = true;
    userName = "Vance Longwill";
    userEmail = "vance@evren.co.uk";
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "vancelongwill";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

  programs.go = {
    enable = true;
    goPrivate = [
      "github.com/vancelongwill"
      "bitbucket.org/fraction-high-security-engineering/*"
      "github.com/dojo-engineering/*"
      "github.com/paymentsense/*"
      "github.com/Paymentsense/*"
      "github.com/PaddleHQ/*"
    ];
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shortcut = "l";
    secureSocket = false;
    prefix = "C-b";

    extraConfig = ''
      set-option -g default-terminal "screen-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set-option -sg escape-time 10

      set -g mouse on
      setw -g mode-keys vi
      # If you don’t mind artifically introducing a few Vim-only features to the vi mode, you can set things up so that v starts a selection and y finishes it in the same way that Space and Enter do, more like Vim:
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      # prevent "release mouse click to copy and exit copy mode and reset scroll position"
      # keeps scroll position after highlight/mouse release
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Vim style pane navigation (instead of arrow keys)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # <C-b>b to go to last window since <C-b>l is overwritten by the above pane navigation bindings
      bind b last-window
    '';
  };

  programs.alacritty = {
    enable = true;

    settings = {
      env.TERM = "xterm-256color";

      key_bindings = [
        { key = "K"; mods = "Command"; chars = "ClearHistory"; }
        { key = "V"; mods = "Command"; action = "Paste"; }
        { key = "C"; mods = "Command"; action = "Copy"; }
        { key = "Key0"; mods = "Command"; action = "ResetFontSize"; }
        { key = "Equals"; mods = "Command"; action = "IncreaseFontSize"; }
        { key = "Subtract"; mods = "Command"; action = "DecreaseFontSize"; }
      ];
    };
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty;
  };

  programs.i3status = {
    enable = true;

    general = {
      colors = true;
      color_good = "#8C9440";
      color_bad = "#A54242";
      color_degraded = "#DE935F";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "tty";

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  xsession.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
  };
}
