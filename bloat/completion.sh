#!/bin/zsh

[[ -z "${XDG_CACHE_HOME}" ]] && XDG_CACHE_HOME="${HOME}/.cache";

[[ ! -e "${XDG_CACHE_HOME}/zsh" ]] && mkdir -p "${XDG_CACHE_HOME}/zsh";

autoload bashcompinit; bashcompinit -d "${XDG_CACHE_HOME}/zsh/bashcompdump";
autoload compinit; compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump";

zstyle ':completion:*:*:*:*:*' menu select;
zstyle ':completion:*' list-colors;

unsetopt menu_complete;
unsetopt flowcontrol;

setopt auto_menu;
setopt complete_in_word;
setopt always_to_end;

