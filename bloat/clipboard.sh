#!/bin/zsh

function copy {
  local COMMAND="$([[ "${XDG_SESSION_TYPE}" == "wayland" ]] \
    && echo "wl-copy" \
    || echo "xclip -selection c")";
  if [[ ! -z "${1}" ]]
  then
    if [[ -e "${1}" && -f "${1}" ]]
    then
      cat "${1}" | ${COMMAND};
    else
      printf "${@}" | ${COMMAND};
    fi
  else
    cat | ${COMMAND};
  fi
}

function paste {
  [[ "${XDG_SESSION_TYPE}" == "wayland" ]] \
    && wl-paste \
    || xclip -out;
}

