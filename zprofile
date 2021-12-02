#!/bin/zsh

emulate sh -c 'source /etc/profile';

if [[ ! -d /ish ]]
then
  [[ -e "${HOME}/.config/user-dirs.dirs" ]] && source <(\
      cat "${HOME}/.config/user-dirs.dirs" \
    | sed 's/^/export /' \
    | sed 's/$/;/' \
  );
else
  $(\
      cat "${HOME}/.config/user-dirs.dirs" \
    | sed 's/^/export /' \
    | sed 's/$/;/' \
  );
fi

export CARGO_HOME="${HOME}/.opt/cargo";
export EDITOR="nvim";
export PATH="${HOME}/.local/bin:${PATH}";
export RUSTUP_HOME="${HOME}/.opt/rustup";
export WINEPREFIX="${HOME}/.opt/wine";

if [[ ! -d /ish ]]
then
  [[ -e "${HOME}/.env" ]] && source <(\
      cat "${HOME}/.env" \
    | sed 's/^/export /' \
    | sed 's/$/;/' \
  );
else
  [[ -e "${HOME}/.env" ]] && $(\
      cat "${HOME}/.env" \
    | sed 's/^/export /' \
    | sed 's/$/;/' \
  );
fi

[[ -z "${SKIP_LOGIN_MESSAGE}" ]] && source /etc/zsh/login.sh;

