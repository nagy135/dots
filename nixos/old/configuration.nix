{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

# Use the systemd-boot EFI boot loader.
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

networking = {
  hostName = "nixos"; # Define your hostname.

# Enable NetworkManager with iwd
networkmanager = {
  enable = true;
  wifi.backend = "iwd";
};

# The global useDHCP flag is deprecated, therefore explicitly set to false here.
# Per-interface useDHCP will be mandatory in the future, so this generated config
# replicates the default behaviour.
useDHCP = false;
interfaces.wlp1s0.useDHCP = true;
    };

# Select internationalisation properties.
i18n.defaultLocale = "en_US.UTF-8";
console = {
  font = "Lat2-Terminus16";
  keyMap = "us";
};

# Set your time zone.
time.timeZone = "Europe/Bratislava";

# fonts 
fonts.fonts = with pkgs; [
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  liberation_ttf
  fira-code
  fira-code-symbols
  mplus-outline-fonts
  dina-font
  proggyfonts
  pkgs.powerline-fonts
  pkgs.font-awesome
];

# List packages installed in system profile. To search, run:
# $ nix search wget
environment.systemPackages = with pkgs; [
  wget
  chromium
  alacritty
  zsh
  git
  python3
  powerline-fonts
  neofetch
  lazygit
  qutebrowser
  font-awesome
  mpv
  youtube-dl
  xorg.xbacklight
];

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
#   pinentryFlavor = "gnome3";
# };

programs.zsh.enable = true;

# List services that you want to enable:

# Enable the OpenSSH daemon.
services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# Enable CUPS to print documents.
# services.printing.enable = true;

# Enable sound.
sound.enable = true;
hardware.pulseaudio.enable = true;

# Enable the X11 windowing system.
services.xserver.enable = true;
services.xserver.layout = "us";
services.xserver.xkbOptions = "eurosign:e";

# Enable touchpad support.
services.xserver.libinput = {
  enable = true;
  naturalScrolling = true;
};

# Enable the XFCE Desktop Environment.
services.xserver = {
  displayManager.lightdm.enable = true;
    # desktopManager.xfce.enable = true;
    desktopManager.xterm.enable = true;
    # windowManager.bspwm.enable = true;
  };

# Define a user account. Don't forget to set a password with ‘passwd’.
users.users.infiniter = {
  isNormalUser = true;
  shell = pkgs.zsh;
  extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
};

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
system.stateVersion = "20.03"; # Did you read the comment?

}
