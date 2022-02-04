{ config, pkgs, ... }:
let
  unstable = import <unstable> { config = { allowUnfree = true; }; };
  wayland = true;
  basePackages = with pkgs; [
    unstable.neovim
    wget
    google-chrome
    git
    python3
    qutebrowser
    mpv
    youtube-dl
    lsd
    zsh
    zsh-powerlevel10k
    gcc
    zig
    killall
    lua
    stow
    dmenu
    vifm
    tmux
    sxiv
    ffmpeg
    docker
    docker-compose
    fzf
    htop
    nodePackages.npm
    nodejs
    pavucontrol
    yt-dlp
    zsh-fzf-tab
    rnix-lsp
    pipewire
    libnotify
    dunst
    sumneko-lua-language-server
    nodePackages.typescript
  ];
in
{
  environment.systemPackages = with pkgs;
    if wayland then basePackages ++ [
      foot
      sway
      waybar
    ] else basePackages ++ [
      polybar
      alacritty
      xorg.xbacklight
      xclip
      sxhkd
    ];
  services.pipewire.enable = true;

  environment.etc."zsh-fzf-tab/fzf-tab.plugin.zsh".source = "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh";

  programs.zsh.enable = true;
  programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

  programs.waybar.enable = true;

  programs.light.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
    ];
  };

  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
