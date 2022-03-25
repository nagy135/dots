# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./packages.nix
      ./pipewire.nix
      ./gpu.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager = {
    enable = true;
  };

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME = "\${HOME}/.local/bin";
    XDG_DATA_HOME = "\${HOME}/.local/share";
  };


  # Set your time zone.
  time.timeZone = "Europe/Bratislava";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp1s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # nerdfonts
    # meslo-lgs-nf
  ];
  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      localConf = ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
        <fontconfig>
         <alias>
            <family>serif</family>
            <prefer><family>JetBrainsMono Nerd Font</family></prefer>
          </alias>
          <alias>
            <family>sans-serif</family>
            <prefer><family>JetBrainsMono Nerd Font</family></prefer>
          </alias>
          <alias>
            <family>sans</family>
            <prefer><family>JetBrainsMono Nerd Font</family></prefer>
          </alias>
          <alias>
            <family>monospace</family>
            <prefer><family>JetBrainsMono Nerd Font</family></prefer>
          </alias>
        </fontconfig>
      '';
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  # Enable the Plasma 5 Desktop Environment.
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.windowManager.bspwm.enable = true;
  # services.xserver.windowManager.bspwm.configFile = null;
  # services.xserver.videoDrivers = [ "intel" ];
  # services.xserver.deviceSection = ''
  #     Option "DRI" "2"
  #     Option "TearFree" "true"
  #     '';


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # share password lock between terminals
  security.sudo.extraConfig = ''
    Defaults !tty_tickets
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.infiniter = {
    isNormalUser = true;
    shell = pkgs.zsh;
    initialPassword = "pass";
    extraGroups = [ "wheel" "docker" "video" ];
  };

  # Cron
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/5 * * * *      infiniter    XDG_RUNTIME_DIR=/run/user/$(id -u) subtube update --secret"
    ];
  };


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
