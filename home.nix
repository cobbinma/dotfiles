{ pkgs, ... }:

let
  extraNodePackages = import ./node/default.nix {};
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "cobbing";
  home.homeDirectory = "/Users/cobbing";

  fonts.fontconfig.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # tools
    pkgs.thefuck
    pkgs.glab
    pkgs.flyctl
    pkgs.grpcui
    pkgs.wget
    pkgs.jq
    pkgs.docker
    extraNodePackages.better-commits

    pkgs.spotify
    pkgs.spotify-player

    # languages

    ## rust 🦀
    pkgs.rustup
    pkgs.cargo-watch
    pkgs.rover

    # go
    pkgs.golangci-lint

    ## typescript
    pkgs.fnm
    pkgs.bun
    pkgs.yarn

    ## mobile
    pkgs.nodePackages.expo-cli

    ## python
    pkgs.ruff
    pkgs.poetry
    (pkgs.python312.withPackages (p: with p; [
      "aiohttp" # async HTTP
      "ipython" # interactive shell
      "jupyter" # interactive notebooks
      "pandas" # data analysis
      "pytest"
      "setuptools" # setup.py
    ]))

    ## protobuf
    pkgs.protobuf
    pkgs.buf

    ## elixir
    pkgs.elixir

    ## gleam
    pkgs.gleam

    # databases
    pkgs.sqlite
    pkgs.postgresql

    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/matthew.cobbing/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shellAliases = {
    hms = "home-manager switch";
    hmu = "nix-channel --update && home-manager switch";
    master = "git checkout master && git pull";
    main = "git checkout main && git pull";
  };

  programs.git = {
    enable = true;
    userName = "cobbinma";
    userEmail = "cobbinma@gmail.com";
    extraConfig = {
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
      pull.ff = "only";
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/id_rsa_github";
        identitiesOnly = true;
        user = "git";
      };
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.vscode = {
    enable = true;
    userSettings = {
      "workbench.colorTheme" = "Tokyo Night";
      "terminal.integrated.defaultProfile.osx" = "zsh";
      "workbench.iconTheme" = "vscode-icons";
      "[proto3]" = { "editor.defaultFormatter" = "bufbuild.vscode-buf"; };
    };
    extensions = with pkgs.vscode-extensions; [
      enkia.tokyo-night
      yzhang.markdown-all-in-one
      rust-lang.rust-analyzer
      golang.go
      hashicorp.terraform
      ms-azuretools.vscode-docker
      svelte.svelte-vscode
      zxh404.vscode-proto3
      esbenp.prettier-vscode
      ms-vscode.makefile-tools
      tamasfe.even-better-toml
      wakatime.vscode-wakatime
      astro-build.astro-vscode
      vscode-icons-team.vscode-icons
      shd101wyy.markdown-preview-enhanced
      mechatroner.rainbow-csv
    ];
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "docker" "golang" "kubectl"];
    };
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    initExtra = ''
      export PATH=$PATH:~/.nix-profile/bin
      export PATH=$PATH:/opt/homebrew/bin
      export PATH=$PATH:$(go env GOPATH)/bin
      export PATH=$PATH:~/.cargo/bin

      eval $(fnm env)

      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';

  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 14;
        normal.family = "JetBrainsMono Nerd Font";
      };
      window = {
        padding = {
          x = 2;
          y = 2;
        };
        decorations = "full";
      };
      shell.program = "${pkgs.zsh}/bin/zsh";
      colors = {
        primary = {
          background = "#24283b";
          foreground = "#a9b1d6";
        };
        normal = {
          black =   "#32344a";
          red =     "#f7768e";
          green =   "#9ece6a";
          yellow =  "#e0af68";
          blue =    "#7aa2f7";
          magenta = "#ad8ee6";
          cyan =    "#449dab";
          white =   "#9699a8";
        };
        bright = {
          black =    "#444b6a";
          red =      "#ff7a93";
          green =    "#b9f27c";
          yellow =   "#ff9e64";
          blue =     "#7da6ff";
          magenta =  "#bb9af7";
          cyan =     "#0db9d7";
          white =    "#acb0d0";
        };
      };
    };
  };

  programs.zoxide = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "tokyonight";
      themes.tokyonight = {
        fg = [ 169 177 214 ];
        bg = [ 36 40 69 ];
        black = [ 56 62 90 ];
        red = [ 249 51 87 ];
        green = [ 158 206 106 ];
        yellow = [ 224 175 104 ];
        blue = [ 122 162 247 ];
        magenta = [ 187 154 247 ];
        cyan = [ 42 195 222 ];
        white = [ 192 202 245 ];
        orange = [ 255 158 100 ];
      };
    };
  };

  programs.go = {
    enable = true;
    package = pkgs.go_1_21;
  };

  programs.thefuck = {
    enable = true;
    enableZshIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

