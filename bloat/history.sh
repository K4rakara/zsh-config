#!/bin/zsh

mkdir -p /tmp/zsh;

HISTFILE="/tmp/zsh/history";
HISTSIZE="1000";
SAVEHIST="1000";

setopt hist_ignore_all_dups;
setopt hist_save_no_dups;
setopt hist_reduce_blanks;
setopt share_history;

