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

  users.users.jacobranson = {
    name = "jacobranson";
    home = "/Users/jacobranson";
  };

  environment.systemPackages = with pkgs; [];

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
     (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];

  homebrew.enable = true;
  homebrew.autoUpdate = true;
  homebrew.casks = [
    "kitty"
    "orion"
    "obsidian"
    "visual-studio-code"
    "utm"
    "bartender"
    "keepingyouawake"
    "scroll-reverser"
    "notunes"
  ];

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  security.pam.enableSudoTouchIdAuth = true;
}

