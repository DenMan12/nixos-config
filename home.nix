{ config, pkgs, ... }:

{
  # Home Manager needs to know your home directory
  home.username = "spdmrf";
  home.homeDirectory = "/home/spdmrf";

  # Packages specific to this user
  home.packages = with pkgs; [
    # Browsers (TODO: verify zen-browser exists or use firefox/chromium)
    # zen-browser
    firefox
  ];

  # bspwm configuration
  xsession.windowManager.bspwm = {
    enable = true;
    settings = {
      border_width = 5;
      window_gap = 17;
      split_ratio = 0.52;
      borderless_monocle = true;
      gapless_monocle = false;
      focus_follows_pointer = true;
      pointer_modifier = "mod4";
      pointer_action1 = "move";
      pointer_action2 = "resize_side";
      pointer_action3 = "resize_corner";
    };
    rules = {
      "feh" = { state = "floating"; };
    };
    extraConfig = ''
      bspc config focused_border_color "#7899FA"
      bspc config normal_border_color "#1f222b"
      bspc config active_border_color "#bd93f9"
      bspc config presel_feedback_color "#6272a4"

      # fix pointer
      xsetroot -cursor_name left_ptr

      # Load Xresources
      xrdb merge ~/.Xresources

      # Random Wallpaper (if bin/random_wallpaper exists)
      [ -f ~/bin/random_wallpaper ] && sh ~/bin/random_wallpaper &

      # Launch polybar
      ~/.config/polybar/launch.sh &

      # Launch notification daemon
      dunst -config ~/.config/bspwm/dunstrc &

      # Launch compositor
      picom --config ~/.config/picom/picom.conf &

      # Redshift
      pgrep -x redshift > /dev/null || redshift &

      # Flameshot
      pkill flameshot; flameshot &
    '';
  };

  # sxhkd hotkey daemon
  services.sxhkd = {
    enable = true;
  };

  # Alacritty terminal
  programs.alacritty = {
    enable = true;
  };

  # Rofi launcher
  programs.rofi = {
    enable = true;
  };

  # Fish shell
  programs.fish = {
    enable = true;
  };

  # Noctalia configuration (keeping your original)
  programs.noctalia = {
    enable = true;
    settings = {
      # TODO: Copy your actual Noctalia settings from Arch
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user.name = "spdmrf";
      user.email = "spdmrf@example.com";  # TODO: Replace with your actual email
    };
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
  };

  # Yazi file manager
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };

  # btop system monitor
  programs.btop = {
    enable = true;
  };

  # MPD configuration
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
  };

  # Copy dotfiles to home directory
  home.file = {
    # bspwm config
    ".config/bspwm".source = ./dotfiles/bspwm;
    ".config/bspwm".recursive = true;

    # sxhkd config
    ".config/sxhkd".source = ./dotfiles/sxhkd;
    ".config/sxhkd".recursive = true;

    # polybar config
    ".config/polybar".source = ./dotfiles/polybar;
    ".config/polybar".recursive = true;

    # rofi config
    ".config/rofi".source = ./dotfiles/rofi;
    ".config/rofi".recursive = true;

    # dunst config
    ".config/dunst".source = ./dotfiles/dunst;
    ".config/dunst".recursive = true;

    # picom config
    ".config/picom".source = ./dotfiles/picom;
    ".config/picom".recursive = true;

    # alacritty config
    ".config/alacritty".source = ./dotfiles/alacritty;
    ".config/alacritty".recursive = true;

    # Scripts
    "bin".source = ./dotfiles/bin;
    "bin".recursive = true;

    # Wallpapers
    "Images".source = ./dotfiles/Images;
    "Images".recursive = true;

    # Xresources
    ".Xresources".source = ./dotfiles/Xresources;
  };

  # Make scripts executable
  home.activation = {
    makeScriptsExecutable = config.lib.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD chmod +x $HOME/bin/* 2>/dev/null || true
      $DRY_RUN_CMD chmod +x $HOME/.config/polybar/*.sh 2>/dev/null || true
      $DRY_RUN_CMD chmod +x $HOME/.config/bspwm/bspwmrc 2>/dev/null || true
    '';
  };

  # Home Manager version (don't change)
  home.stateVersion = "24.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
