{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

  subtube = import ./subtube.nix;
  mpv_history = import ./mpv_history.nix;
  torque = import ./torque.nix;

  overridenFuzzel = unstable.fuzzel.overrideAttrs (oldAttrs: rec {
    version = "1.7.x";

    src = pkgs.fetchFromGitea {
      domain = "codeberg.org";
      owner = "dnkl";
      repo = "fuzzel";
      rev = "8e09393463a00fd233b8d3b2ac316c2cfea6c791";
      sha256 = "1ywknv374yca0w862njlyn3bzcvigw3fskpa34ak8hycm05s2jfm";
    };

  });

  overridenNeovim = unstable.neovim.overrideAttrs (oldAttrs: rec {
    version = "0.6.1";
    vimAlias = true;

    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "4e5e0076cb643b52d762f226b27f22c8fb837567";
      sha256 = "1bzvg0a8sj9y8js68x0djb9njz3rhmy25cz3f39b9db7llggc1pk";
    };

  });

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
    overridenNeovim
    overridenFuzzel
    sxiv
    wget
    google-chrome
    git
    python3
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
    yarn
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
    lazygit
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
