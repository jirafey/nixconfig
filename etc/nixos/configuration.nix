# configuration.nix
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # <home-manager/nixos>
      ./hardware-configuration.nix
    # <nixos-hardware/lenovo/ideapad/16ach6>
    ];
environment.systemPackages = with pkgs; [
  python311Packages.pip
  lz4 
  gnome.gnome-tweaks
  xclip # cat file | xclip -selection clipboard
  unzip
  calibre
  qbittorrent
  protonvpn-cli_2
  thunderbird-unwrapped
  mullvad-browser
  zoxide
  git
  dmidecode
  python3
  glxinfo
  gnumake
  neovim
  wget
  
  firefox-devedition
  neofetch
  mpv-unwrapped
  ffsend
  brave
  grim # screenshot functionality
  slurp # screenshot functionality
  wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
  mako # notification system developed by swaywm maintainer
  gnome3.adwaita-icon-theme
  gnomeExtensions.settingscenter
  pulseaudio
  ];
 nix.settings.experimental-features = [ "nix-command" "flakes" ];
programs.neovim = {
  enable = true;
  defaultEditor = true;
};



# it was defined somewhere in store before
# users.users.user.isNormalUser = true;
home-manager.users.user = { pkgs, ... }: {
  home.packages = [ pkgs.atool pkgs.httpie ];
  programs.bash.enable = true;

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
};


  hardware.opengl = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-ed93a8e1-032f-4dd1-a7d5-a1bb9037aa24".device = "/dev/disk/by-uuid/ed93a8e1-032f-4dd1-a7d5-a1bb9037aa24";
  networking.hostName = "hostname"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  programs.light.enable = true;

  security.polkit.enable = true;
#disabling for home-manager
  #programs.waybar.enable = true;

  services.xserver = {
    enable = true;  
    exportConfiguration = true;
    displayManager.gdm = {
      enable = true;  
      wayland = true; 
    };
    desktopManager.gnome.enable = true; 
  };

    systemd.packages = with pkgs.gnome3; [ gnome-session gnome-shell];

  services.libinput.touchpad.naturalScrolling = false	;

  environment.gnome.excludePackages = (with pkgs; [
  gnome-photos
  gnome-tour
]) ++ (with pkgs.gnome; [
  cheese # webcam tool
  gnome-music
  gnome-terminal
  epiphany # web browser
  geary # email reader
  evince # document viewer
  gnome-characters
  totem # video player
  tali # poker game
  iagno # go game
  hitori # sudoku game
  atomix # puzzle game
]);

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,pl";
    variant = "";
    options = "grp:win_space_toggle,caps:none";
  };

	  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" "light" "video" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  # programs.firefox.package = pkgs.latest.firefox-devedition-unwrapped;# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm-password.enableGnomeKeyring = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05"; 


}
