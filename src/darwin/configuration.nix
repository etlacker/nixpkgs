{ pkgs, lib, ... }:

{
  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.settings.trusted-users = [
    "@admin"
  ];
  nix.configureBuildUsers = true;

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  programs.nix-index.enable = true;
  programs.nix-index.package = pkgs.nix-index;

  users.users.ericlacker = {
    name = "ericlacker";
    home = "/Users/ericlacker";
  };

  environment.systemPackages = with pkgs; [];

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
     (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];

  homebrew.enable = true;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;
  homebrew.taps = [
    "homebrew/cask-drivers"
  ];
  homebrew.casks = [
    # Fix macOS annoyances
    # "rectangle"
    # "hiddenbar"
    # "keepingyouawake"
    # "mouse-fix"
    # "notunes"

    # Native macOS essentials
    # "orion"
    "codeedit"
    # "rapidapi"
    # "iterm2"
    "utm"
    # "iina"
    # "setapp"

    # Non-native essentials
    "bitwarden"
    # "element"
    # "signal"
    "obsidian"
    "visual-studio-code"
    # "logi-options-plus"
    # "nextcloud"
    "firefox"
  ];

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.FXDefaultSearchScope = "SCcf";
  system.defaults.finder.FXEnableExtensionChangeWarning = false;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.ShowStatusBar = true;
  system.defaults.finder._FXShowPosixPathInTitle = true;

  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.Dragging = true;
  system.defaults.trackpad.TrackpadRightClick = true;

  # system.keyboard.enableKeyMapping = true;
  # system.keyboard.remapCapsLockToControl = true;
  security.pam.enableSudoTouchIdAuth = true;

  # services.yabai.enable = true;
  # services.yabai.package = pkgs.yabai;
  # services.yabai.extraConfig = (builtins.readFile ./assets/yabai/yabairc);

  # services.skhd.enable = true;
  # services.skhd.package = pkgs.skhd;
  # services.skhd.skhdConfig = (builtins.readFile ./assets/skhd/skhdrc);
}
