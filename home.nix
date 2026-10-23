{ config, pkgs, ... }:

{
  # Home Manager needs to know your home directory
  home.username = "spdmrf";
  home.homeDirectory = "/home/spdmrf";

  # Packages specific to this user
  home.packages = with pkgs; [
    # Browsers (TODO: verify zen-browser exists or use firefox/chromium)
    # zen-browser
  ];

  # Noctalia configuration
  programs.noctalia = {
    enable = true;
    settings = {
      # TODO: Copy your actual Noctalia settings from Arch
      # For now, minimal config to get it running
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "spdmrf";
    userEmail = "spdmrf@example.com";  # TODO: Replace with your actual email
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Yazi file manager
  programs.yazi = {
    enable = true;
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

  # Home Manager version (don't change)
  home.stateVersion = "24.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
