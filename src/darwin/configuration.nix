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
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;
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

  networking.computerName = "Jacob's MacBook Air";
  networking.hostName = "Jacobs-MacBook-Air";
  networking.localHostName = "Jacobs-MacBook-Air.local";

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

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  security.pam.enableSudoTouchIdAuth = true;

  services.yabai.enable = true;
  services.yabai.package = pkgs.yabai;
  services.yabai.extraConfig = ''
sudo yabai --load-sa
yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"

yabai -m config mouse_follows_focus          on
yabai -m config focus_follows_mouse          autofocus
yabai -m config window_origin_display        default
yabai -m config window_placement             second_child
yabai -m config window_topmost               off
yabai -m config window_shadow                off
yabai -m config window_opacity               off
yabai -m config active_window_opacity        1.0
yabai -m config normal_window_opacity        0.90
yabai -m config window_border                on
yabai -m config window_border_width          4
yabai -m config active_window_border_color   0xffffffff
yabai -m config normal_window_border_color   0xff555555
yabai -m config insert_feedback_color        0xffd75f5f
yabai -m config split_ratio                  0.50
yabai -m config auto_balance                 off
yabai -m config mouse_modifier               fn
yabai -m config mouse_action1                move
yabai -m config mouse_action2                resize
yabai -m config mouse_drop_action            swap
yabai -m config layout                       bsp
yabai -m config top_padding                  12
yabai -m config bottom_padding               12
yabai -m config left_padding                 12
yabai -m config right_padding                12
yabai -m config window_gap                   06
yabai -m config external_bar all:0:20

echo "yabai configuration loaded"
  '';

  services.skhd.enable = true;
  services.skhd.package = pkgs.skhd;
  services.skhd.skhdConfig = ''
# --- Windows ---

## Change the focused window.
cmd - up : \
    yabai -m window --focus stack.prev || \
    yabai -m window --focus north || \
    yabai -m window --focus stack.last
cmd - down : \
    yabai -m window --focus stack.next || \
    yabai -m window --focus south || \
    yabai -m window --focus stack.first
cmd - left : yabai -m window --focus west
cmd - right : yabai -m window --focus east

## Move a window
lshift + cmd - up : yabai -m window --warp north
lshift + cmd - down : yabai -m window --warp south
lshift + cmd - left : yabai -m window --warp west
lshift + cmd - right : yabai -m window --warp east

## Resize a window
lalt + cmd - up : \
    yabai -m window --resize top:0:-50 || \
    yabai -m window --resize bottom:0:-50
lalt + cmd - down : \
    yabai -m window --resize bottom:0:50 || \
    yabai -m window --resize top:0:50
lalt + cmd - left : \
    yabai -m window --resize left:-50:0 || \
    yabai -m window --resize right:-50:0
lalt + cmd - right : \
    yabai -m window --resize right:50:0 || \
    yabai -m window --resize left:50:0

# --- Spaces ---

## Create a new space (ctrl + enter)
lctrl - 0x24 : \
    yabai -m space --create && \
    index="$(yabai -m query --spaces --display | jq 'map(select(."is-native-fullscreen" == false))[-1].index')" && \
    yabai -m space --focus "''${index}"

## Destroy the current space (ctrl + delete)
lctrl - 0x33 : yabai -m space --destroy

## Change the focused space
lctrl - left : if [[ \
        $(yabai -m query --spaces --space | jq '.index' ) != \
        $(yabai -m query --displays --display | jq '.spaces[0]') \
    ]]; then \
            yabai -m space --focus prev; \
        else \
            yabai -m space --focus $(yabai -m query --displays --display | jq '.spaces[-1]'); \
        fi
lctrl - right : if [[ \
        $(yabai -m query --spaces --space | jq '.index' ) != \
        $(yabai -m query --displays --display | jq '.spaces[-1]') \
    ]]; then \
            yabai -m space --focus next; \
        else \
            yabai -m space --focus $(yabai -m query --displays --display | jq '.spaces[0]'); \
        fi

## Move a window between spaces
lshift + lctrl - left : if [[ \
        $(yabai -m query --spaces --space | jq '.index' ) != \
        $(yabai -m query --displays --display | jq '.spaces[0]') \
    ]]; then \
            yabai -m window --space prev && \
            yabai -m space --focus prev; \
        else \
            yabai -m window --space $(yabai -m query --displays --display | jq '.spaces[-1]') && \
            yabai -m space --focus $(yabai -m query --displays --display | jq '.spaces[-1]'); \
        fi
lshift + lctrl - right : if [[ \
        $(yabai -m query --spaces --space | jq '.index' ) != \
        $(yabai -m query --displays --display | jq '.spaces[-1]') \
    ]]; then \
            yabai -m window --space next && \
            yabai -m space --focus next; \
        else \
            yabai -m window --space $(yabai -m query --displays --display | jq '.spaces[0]') && \
            yabai -m space --focus $(yabai -m query --displays --display | jq '.spaces[0]'); \
        fi

# --- Displays ---

## Change the focused display
lalt - left : \
    yabai -m display --focus prev || \
    yabai -m display --focus last
lalt - right : \
    yabai -m display --focus next || \
    yabai -m display --focus first

## Move a window between displays
lshift + lalt - left : \
    (yabai -m window --display prev && yabai -m display --focus prev) || \
    (yabai -m window --display last && yabai -m display --focus last)
lshift + lalt - right : \
    (yabai -m window --display next && yabai -m display --focus next) || \
    (yabai -m window --display first && yabai -m display --focus first)

# --- Stacking ---

## Create a stack
lctrl + cmd - s : yabai -m window --stack next

# --- Layout ---

## Change layout
lctrl + cmd - 1 : \
    yabai -m config --space mouse window_border on && \
    yabai -m space mouse --layout bsp
lctrl + cmd - 2 : \
    yabai -m config --space mouse window_border off && \
    yabai -m space mouse --layout stack
lctrl + cmd - 3 : \
    yabai -m config --space mouse window_border off && \
    yabai -m space mouse --layout float

# --- Other ---

## Toggle floating window, and center it
lctrl + cmd - y : \
    yabai -m window --toggle float && \
    yabai -m window --toggle border && \
    yabai -m window --grid 4:4:1:1:2:2

## Equalize the size of all windows
lctrl + cmd - e : yabai -m space mouse --balance

# Toggle gaps for the current space
lctrl + cmd - g : \
    yabai -m space mouse --toggle padding && \
    yabai -m space mouse --toggle gap
  '';

  services.spacebar.enable = true;
  services.spacebar.package = pkgs.spacebar;
}

