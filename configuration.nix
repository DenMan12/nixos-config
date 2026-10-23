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

  # Bootloader (placeholder — adjust for your hardware)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # Niri (Wayland compositor)
  programs.niri.enable = true;

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
    # obsidian  # TODO: verify package name
    qbittorrent

    # Terminal tools
    # yazi  # TODO: verify package name

    # Music
    mpd
    # rmpc  # TODO: verify package name or use mpc instead

    # Other
    # rnote  # TODO: verify package name
    # loaf  # TODO: verify package name
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
