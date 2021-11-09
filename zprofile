#!/bin/zsh

emulate sh -c 'source /etc/profile';

$(\
    cat "${HOME}/.config/user-dirs.dirs" \
  | sed 's/^/export /' \
  | sed 's/$/;/' \
);

export CARGO_HOME="${HOME}/.opt/cargo";
export EDITOR="nvim";
export PATH="${HOME}/.local/bin:${PATH}";
export RUSTUP_HOME="${HOME}/.opt/rustup";
export WINEPREFIX="${HOME}/.opt/wine";

[[ -e "${HOME}/.env" ]] && $(
    cat "${HOME}/.env" \
  | sed 's/^/export /' \
  | sed 's/$/;/' \
);

[[ -z "${SKIP_LOGIN_MESSAGE}" ]] && source /etc/zsh/login.sh;

