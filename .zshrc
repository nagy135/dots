#          _
#  _______| |__  _ __ ___
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__
# /___|___/_| |_|_|  \___|
#

if [[ -f ~/.zplugin/bin/zplugin.zsh ]]; then
    source ~/.zplugin/bin/zplugin.zsh
else
    mkdir ~/.zplugin
    git clone https://github.com/psprint/zplugin.git ~/.zplugin/bin
    source ~/.zplugin/bin/zplugin.zsh
fi

autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

# source common configs
for file in $ZSH_HOME/common/*.zsh; do
    source "$file"
done

# source os-specific configs
if [[ -f "/etc/os-release" || -f "/usr/lib/os-release" ]]; then

    # Source the os-release file
    for file in /etc/os-release /usr/lib/os-release; do
        source "$file" 2>/dev/null && break
    done

    if [[ -d "$ZSH_HOME/os/$ID" ]]; then
        for file in $ZSH_HOME/os/$ID/*.zsh; do
            source "$file"
        done
    fi

fi

# source host specific config
if [[ -d "$ZSH_HOME/host/$(hostname)" ]]; then
    for file in $ZSH_HOME/host/$(hostname)/*.zsh; do
        source "$file"
    done
fi

source $ZSH_HOME/plugins
source $HOME/.aliases
source $HOME/.functions


# enable vim mode on commmand line
bindkey -v

# no delay entering normal mode
# https://coderwall.com/p/h63etq
# https://github.com/pda/dotzsh/blob/master/keyboard.zsh#L10
# 10ms for key sequences
KEYTIMEOUT=1

# show vim status
# http://zshwiki.org/home/examples/zlewidgets
function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# add missing vim hotkeys
# http://zshwiki.org/home/zle/vi-mode
bindkey -a u undo
bindkey -a '^T' redo
bindkey '^?' backward-delete-char  #backspace

# history search in vim mode
# http://zshwiki.org./home/zle/bindkeys#why_isn_t_control-r_working_anymore
# ctrl+r to search history
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

source ~/.zsh/keybinds.zsh

export VISUAL=nvim
export EDITOR=nvim
export XDG_CONFIG_HOME=/home/infiniter/.config
export PATH="$HOME/Code/scripts:$PATH"
export PATH="$HOME/go/bin:$PATH"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
