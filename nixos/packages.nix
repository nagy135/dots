{ config, pkgs, ... }:
let
  unstable = import <unstable> { config = { allowUnfree = true; }; };

  subtube = import ./subtube.nix;
  mpv_history = import ./mpv_history.nix;
  torque = import ./torque.nix;

  # import package from specific revision of nixpkgs
  #
  # myNixpkgs = import (builtins.fetchGit {
  #       name = "nixos-unstable-2022-04-18";
  #       url = https://github.com/nixos/nixpkgs/;
  #       rev = "33cf95ef36d9e2e7aec511297de9a845d6b729fe";
  #   }) {};



  # nixpkgs.overlays = [
  #   (self: super:
  #     {
  #       yarn = super.yarn.overrideAttrs (old: {
  #         nodejs = pkgs.nodejs-17_x;
  #       });
  #     })
  # ];
  #
  #
  # overridenFuzzel = unstable.fuzzel.overrideAttrs (oldAttrs: rec {
  #   version = "1.7.x";

  #   src = pkgs.fetchFromGitea {
  #     domain = "codeberg.org";
  #     owner = "dnkl";
  #     repo = "fuzzel";
  #     rev = "8e09393463a00fd233b8d3b2ac316c2cfea6c791";
  #     sha256 = "1ywknv374yca0w862njlyn3bzcvigw3fskpa34ak8hycm05s2jfm";
  #   };

  # });

  # overridenLazygit = unstable.lazygit.overrideAttrs (oldAttrs: rec {
  #   src = pkgs.fetchFromGitHub {
  #     owner = "jesseduffield";
  #     repo = "lazygit";
  #     rev = "09bc6f2aef2bc0c0d76d0b12498ec8976c822ff2";
  #     sha256 = "sha256-LJXXS+nfQvdesRC3+WU1MVRm3nhrUcTTOF3jKzCHLpE=";
  #   };
  #
  # });

  personalPackages = with pkgs; [
    subtube
    mpv_history
    torque
  ];

  wayland = true;
  work = false;

  my-python-packages = python-packages: with python-packages; [
    numpy
    pillow
  ];
  python-with-my-packages = pkgs.python3.withPackages my-python-packages;

  basePackages = with pkgs; [
    unstable.neovim
    unstable.lazygit
    unstable.yarn
    gammastep
    fuzzel
    rofi-wayland
    sxiv
    wget
    google-chrome
    git
    qutebrowser
    gopls
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
    neofetch
    dmenu
    vifm
    tmux
    ffmpeg
    docker
    docker-compose
    fzf
    htop
    nodePackages.npm
    nodePackages.prettier
    nodejs-17_x
    pavucontrol
    yt-dlp
    zsh-fzf-tab
    rnix-lsp
    pipewire
    libnotify
    dunst
    spotify
    pamixer
    postman
    transmission
    ripgrep
    z-lua
    jq
    nix-prefetch-scripts
    steam
    stig
    zip
    unzip
    file
    sumneko-lua-language-server
  ];

  waylandSwitch = with pkgs;
    if wayland then [
      foot
      sway
      waybar
      grim
      slurp
      wf-recorder
    ] else [
      polybar
      alacritty
      xorg.xbacklight
      xclip
      sxhkd
      xdo
    ];

  workSwitch = with pkgs;
    if !work then [ ] else [
      jetbrains.datagrip
      slack
    ];
in
{
  environment.systemPackages = basePackages
    ++ personalPackages
    ++ [python-with-my-packages]
    ++ waylandSwitch
    ++ workSwitch;

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
    ];
  };
  services.transmission = {
    enable = true;

    settings.download-dir = "${config.users.users.infiniter.home}/Videos/Movies";
    user = "infiniter";
    settings = {
      script-torrent-done-enabled = true;
      script-torrent-done-filename = "${config.users.users.infiniter.home}/.scripts/torrent_done";
    };
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
