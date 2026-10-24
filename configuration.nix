{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Hostname
  networking.hostName = "nixos";

  # Timezone & Locale
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages (Steam, etc.)
  nixpkgs.config.allowUnfree = true;

  # Bootloader (Legacy BIOS for Sony VAIO)
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  # boot.loader.systemd-boot.enable = true;  # UEFI only
  # boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Sound (PipeWire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # X Server and bspwm
  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;

    # Nouveau driver (open-source, works for GT 425M)
    videoDrivers = [ "nouveau" ];
  };

  # Display manager
  services.displayManager = {
    defaultSession = "none+bspwm";
  };
  services.xserver.displayManager.lightdm.enable = true;

  # Enable nix-ld for running non-NixOS binaries
  programs.nix-ld.enable = true;

  # Steam (without Millennium for now)
  programs.steam = {
    enable = true;
  };

  # ArtCraft packages (imported from ./pkgs/artcraft/)
  nixpkgs.overlays = [
    (final: prev: {
      gridcraft = final.callPackage ./pkgs/artcraft/gridcraft.nix {};
      wordcraft = final.callPackage ./pkgs/artcraft/wordcraft.nix {};
      pdfcraft = final.callPackage ./pkgs/artcraft/pdfcraft.nix {};
      photocraft = final.callPackage ./pkgs/artcraft/photocraft.nix {};
    })
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    # ArtCraft suite (TODO: fix URLs in pkgs/artcraft/*.nix)
    # gridcraft
    # wordcraft
    # pdfcraft
    # photocraft

    # Core utilities
    git
    wget
    curl
    vim
    neovim
    htop
    btop

    # GUI apps
    obsidian
    qbittorrent

    # Terminal tools
    yazi

    # Music
    mpd
    rmpc

    # Other
    rnote
    # loaf  # Package doesn't exist in nixpkgs

    # bspwm ecosystem
    bspwm
    sxhkd
    polybar
    rofi
    dunst
    picom
    alacritty
    feh  # wallpaper setter
    xsetroot
    xclip
    xdotool
    flameshot  # screenshots
    redshift  # screen temperature

    # Additional utilities from the rice
    lsd  # ls replacement
    ranger  # file manager
    fish  # shell
    zathura  # pdf viewer
    networkmanagerapplet  # network tray icon
  ];

  # User account
  users.users.spdmrf = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Optional: zram swap (useful for laptops with limited RAM)
  zramSwap.enable = true;

  # System version (don't change)
  system.stateVersion = "24.05";
}
