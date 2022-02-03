{ config, pkgs, ... }:
let
    unstable = import <unstable> { config = { allowUnfree = true; }; };
in {
	environment.systemPackages = with pkgs; [
		unstable.neovim
		wget
		google-chrome
		git
		python3
		qutebrowser
		mpv
		xorg.xbacklight
		youtube-dl
		sxhkd
		alacritty
		polybar
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
		docker
		docker-compose
		fzf
		htop
		xclip
		nodePackages.npm
		nodejs
	];
	programs.zsh.enable = true;
	programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

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
