# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
setopt histignoredups

setopt noincappendhistory
setopt nosharehistory
setopt appendhistory

# man colors

bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/infiniter/.zshrc'

bindkey '^R' history-incremental-search-backward

# edit command in vim <C-X><C-E> or <C-X>E
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
bindkey "^XE" edit-command-line

source $HOME/.aliases
source $HOME/.functions
source $HOME/.zsh_completions

[[ ! -f /etc/zsh-fzf-tab/fzf-tab.plugin.zsh ]] \
    || source /etc/zsh-fzf-tab/fzf-tab.plugin.zsh

export HISTFILE=$HOME/.zsh_history

[[ ! -f ~/Clones/z.lua/z.lua ]] \
    || eval "$(lua ~/Clones/z.lua/z.lua --init zsh)"

# lsx
[[ ! -f ~/.config/lsx/lsx.sh ]] || source ~/.config/lsx/lsx.sh

# broot
[[ ! -f /home/infiniter/.config/broot/launcher/bash/br ]] \
    || source /home/infiniter/.config/broot/launcher/bash/br

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ] && source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[ -f /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme ] && source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
