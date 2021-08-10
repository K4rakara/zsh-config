#!/bin/zsh

autoload bashcompinit; bashcompinit;
autoload compinit; compinit;

zstyle ':completion:*:*:*:*:*' menu select;
zstyle ':completion:*' list-colors;

unsetopt menu_complete;
unsetopt flowcontrol;

setopt auto_menu;
setopt complete_in_word;
setopt always_to_end;

