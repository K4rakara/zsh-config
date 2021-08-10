#!/bin/zsh

echo "WARNING: this will override your current zsh configuration. Back it up. Press enter to continue.";

read;
printf "\r\x1b[2A\x1b[2K\x1b[1B";

export ZPROFILE="${HOME}/.zprofile";
export ZSHRC="${HOME}/.zshrc";
export BLOAT_DIR="${HOME}/.config/zsh";

source ./install.sh;

