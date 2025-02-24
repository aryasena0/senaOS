{ pkgs, username, host, lib, ... }:
let
  inherit (import ./variables.nix) gitUsername gitEmail;
  # aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in {
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  # Import Program Configurations
  imports = [
    ../../config/emoji.nix
    ../../config/fastfetch
    ../../config/hyprland.nix
    ../../config/neovim.nix
    ../../config/tmux.nix
    ../../config/rofi/rofi.nix
    ../../config/rofi/config-emoji.nix
    ../../config/rofi/config-long.nix
    ../../config/swaync.nix
    ../../config/waybar.nix
    ../../config/wlogout.nix
    ../../config/fastfetch
  ];

  # Place Files Inside Home Directory
  home.file."Pictures/Wallpapers" = {
    source = ../../config/wallpapers;
    recursive = true;
  };
  home.file.".config/wlogout/icons" = {
    source = ../../config/wlogout;
    recursive = true;
  };
  home.file.".face.icon".source = ../../config/face.jpg;
  home.file.".config/face.jpg".source = ../../config/face.jpg;
  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=Ubuntu
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';

  # Install & Configure Git
  programs.lazygit.enable = true;
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Styling Options
  stylix.targets.waybar.enable = false;
  stylix.targets.rofi.enable = false;
  stylix.targets.hyprland.enable = false;
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
  };
  qt = {
    enable = true;
    style.name = lib.mkDefault "adwaita-dark";
    platformTheme.name = lib.mkDefault "gtk3";
  };

  # Scripts
  home.packages = [
    (import ../../scripts/emopicker9000.nix { inherit pkgs; })
    (import ../../scripts/task-waybar.nix { inherit pkgs; })
    (import ../../scripts/squirtle.nix { inherit pkgs; })
    (import ../../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ../../scripts/wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ../../scripts/web-search.nix { inherit pkgs; })
    (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../scripts/screenshootin.nix { inherit pkgs; })
    (import ../../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
    # aagl-gtk-on-nix.an-anime-game-launcher
  ];

  services = {
    hypridle = {
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  programs = {
    home-manager.enable = true;
    firefox.enable = true;
    zed-editor.enable = true;
    gh.enable = true;
    btop = {
      enable = true;
      settings = { vim_keys = true; };
    };
    kitty = {
      font.size = lib.mkForce 14.25;
      enable = true;
      package = pkgs.kitty;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold
      '';
    };
    starship = {
      enable = true;
      package = pkgs.starship;
    };
    bash.enable = true;
    fish = {
      enable = true;
      shellInit = ''
        export PNPM_HOME="/home/sena/.local/share/pnpm"
        export PATH="$PNPM_HOME:$PATH"
      '';
      interactiveShellInit = ''
        zoxide init fish | source
        fastfetch
      '';
      shellAliases = {
        sv = "sudo nvim";
        fr = "nh os switch --hostname ${host} /home/${username}/senaOS";
        fu =
          "nh os switch --hostname ${host} --update /home/${username}/senaOS";
        zu =
          "sh <(curl -L https://gitlab.com/aryasena0/senaOS/-/raw/main/install.sh)";
        ncg =
          "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        vide = "neovide";
        cat = "bat";
        ls = "eza --icons";
        ll = "eza -lh --icons --grid --group-directories-first";
        la = "eza -lah --icons --grid --group-directories-first";
        l = "la";
        md = "mkdir -p";
        cd = "z";
        ".." = "cd ..";
      };
      plugins = [{
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = false;
    };
    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 10;
          hide_cursor = true;
          no_fade_in = false;
        };
        background = lib.mkForce [{
          path = "/home/${username}/Pictures/Wallpapers/lainix.png";
          blur_passes = 3;
          blur_size = 8;
        }];
        image = [{
          path = "/home/${username}/.config/face.jpg";
          size = 150;
          border_size = 4;
          border_color = "rgb(0C96F9)";
          rounding = -1; # Negative means circle
          position = "0, 200";
          halign = "center";
          valign = "center";
        }];
        input-field = lib.mkForce [{
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(CFE6F4)";
          inner_color = "rgb(657DC2)";
          outer_color = "rgb(0D0E15)";
          outline_thickness = 5;
          placeholder_text = "Password...";
          shadow_passes = 2;
        }];
      };
    };
  };
}
