{ config, pkgs, lib ? pkgs.lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ericlacker";
  home.homeDirectory = "/Users/ericlacker";


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
      shell = "/etc/profiles/per-user/ericlacker/bin/zsh";

      confirm_os_window_close = 0;
      placement_strategy = "center";
      remember_window_size = "no";
      initial_window_width = "120c";
      initial_window_height = "40c";
      #hide_window_decorations = "titlebar-only";
      macos_titlebar_color = "background";
      wayland_titlebar_color = "background";
      macos_show_window_title_in = "none";

      tab_bar_style = "powerline";

      font_family = "CaskaydiaCove Nerd Font Mono";
      bold_font = "CaskaydiaCove Nerd Font Mono Bold";
      itlaic_font = "CaskaydiaCove Nerd Font Mono Italic";
      bold_italic_font = "CaskaydiaCove Nerd Font Mono Bold Italic";
      font_size = "12.0";
    };

    theme = "One Dark";
  };

  # Terminal multiplexer
  # programs.tmux = {
  #   enable = true;

  #   shell = "/etc/profiles/per-user/ericlacker/bin/zsh";

  #   plugins = with pkgs.tmuxPlugins; [
  #     onedark-theme
  #     resurrect
  #   ];

  #   extraConfig = ''
  #     set -g mouse on
  #     set-option -g set-clipboard on
  #   '';
  # };

  # Terminal shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    dotDir = ".config/zsh";

    initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
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
      "SHELL" = "/etc/profiles/per-user/ericlacker/bin/zsh";
      "PAGER" = "/etc/profiles/per-user/ericlacker/bin/moar";
      "EDITOR" = "/etc/profiles/per-user/ericlacker/bin/nvim";
    };

    shellAliases = {
      switch = "darwin-rebuild switch --flake ~/.config/nixpkgs/nixpkgs";
      darwin-help = "man 5 configuration.nix";
      fonts = "kitty +list-fonts | less";
      less = "moar";
      # cat = "bat";
      # gs = "git status";
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
    userName = "Eric Lacker";
    userEmail = "eric@lacker.us";
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
  # programs.bat = {
  #   enable = true;
  #   config = {
  #     theme = "TwoDark";
  #   };
  # };

  # Alternative to `top`
  # programs.htop = {
  #   enable = true;
  # };

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
    coreutils
    findutils
    # gnugrep
    # gnused
    # gawk
    man
    which
    # perl
    comma
    fd
    # silver-searcher
    ripgrep
    moar
    neofetch
    fontconfig
  ];
}

