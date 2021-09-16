#!/bin/zsh

if [[ $(id -u) -ne 0 ]]
then
  echo "This script must be ran as root.";
  exit 1;
fi

printf "This will override /etc/zsh and all the files in it. If you use those \
files, back them up now.";

read;

printf "\x1b[1A\r\x1b[2K";

[[ -e '/etc/zsh' ]] && rm -rf /etc/zsh;

cp -r . /etc/zsh;

rm -rf /etc/zsh/.git;
rm /etc/zsh/*.md;
rm /etc/zsh/install.sh;

