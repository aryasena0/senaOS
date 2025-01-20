{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "sena";
  gitEmail = "sena@lichtlabs.org";

  # Hyprland Settings
  monitorSettings = ''
  monitor=eDP-1, 1920x1200@165.00Hz, 0x1080, 1
  monitor=DP-1, 1920x550@60.02Hz, 0x1080, 1
  '';

  # Waybar Settings
  clock24h = false;

  # Program Options
  browser =
    "brave"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "kitty"; # Set Default System Terminal
  keyboardLayout = "us";
}
