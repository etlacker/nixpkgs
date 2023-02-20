{ config, pkgs, lib ? pkgs.lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jacobranson";
  home.homeDirectory = "/Users/jacobranson";


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1301040457

  # Terminal emulator
  programs.kitty = {
    enable = true;

    settings = {
      shell = "/etc/profiles/per-user/jacobranson/bin/tmux new-session -ADs main";
      confirm_os_window_close = 0;
    };

    theme = "One Dark";
  };

  # Terminal multiplexer
  programs.tmux = {
    enable = true;

    shell = "/etc/profiles/per-user/jacobranson/bin/zsh";

    plugins = with pkgs.tmuxPlugins; [
      onedark-theme
      resurrect
    ];

    extraConfig = ''
      set -g default-terminal "screen-256color"
      set -g mouse on
      set-option -g set-clipboard on
    '';
  };

  # Terminal shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    dotDir = ".config/zsh";

    initExtra = ''
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down
    '';

    history = {
      path = "\${ZDOTDIR}/zsh_history";
      ignoreDups = true;
    };

    sessionVariables = {
      "SHELL" = "\$HOME/.nix-profile/bin/zsh";
      "PAGER" = "\$HOME/.nix-profile/bin/moar";
      "EDITOR" = "\$HOME/.nix-profile/bin/nvim";
    };

    shellAliases = {
      switch = "darwin-rebuild switch --flake ~/.config/nixpkgs";
      less = "moar";
      cat = "bat";
      fonts = "fc-list";
      gs = "git status";
    };

    zplug = {
      enable = true;
      zplugHome = "${config.xdg.configHome}/zsh/zplug";

      plugins = [
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "zsh-users/zsh-history-substring-search"; }
        { name = "wfxr/forgit"; }
      ];
    };
  };

  # Terminal prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Terminal editor
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = ''
      colorscheme onedark
    '';

    plugins = with pkgs.vimPlugins; [
      onedark-nvim
   ];
  };

  # Terminal fuzzy finder
  programs.fzf = {
    enable = true;
  };

  # Version control
  programs.git = {
    enable = true;
    lfs.enable = true;
    delta.enable = true;
    userName = "Jacob Ranson";
    userEmail = "code@jacobranson.dev";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  # Alternative to `ls`
  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  # Alternative to `cat`
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };

  # Alternative to `top`
  programs.htop = {
    enable = true;
  };

  # Search nixpkgs locally
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };
  
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  # Other packages
  home.packages = with pkgs; [
    comma
    fd
    silver-searcher
    ripgrep
    moar
    neofetch
  ];
}

