#!/bin/zsh

function systemctl { sudo /usr/bin/systemctl ${@}; }

function shutdown { sudo /usr/bin/systemctl poweroff; }

function reboot { sudo /usr/bin/systemctl reboot; }

if [[ "$(cat /etc/os-release 2>/dev/null)" == *"archlinux"* ]]
then
  function pacman {
    local CONTAINED_VERSION_FLAG="false";
    local CONTAINED_HELP_FLAG="false";
    for FLAG in ${@}
    do
      [[ "${FLAG}" == "--version" ]] \
        && local CONTAINED_VERSION_FLAG="true";
      [[ "${FLAG}" == "--help" ]] \
        && local CONTAINED_HELP_FLAG="true";
    done
    if [[ "${CONTAINED_VERSION_FLAG}" == "true" ]]
    then
      /usr/bin/pacman --version;
      echo "                       $(paru --version)";
      echo;
    elif [[ "${CONTAINED_HELP_FLAG}" == "true" ]]
    then
      /usr/bin/paru --help | sed 's/paru/pacman/g';
    else
      /usr/bin/paru ${@};
    fi
  }

  function pacmode {
    case "${1}" in
      "home"* ) sudo sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf ;;
      "mobile"* ) sudo sed -i 's/ParallelDownloads/#ParallelDownloads/' /etc/pacman.conf ;;
      * )
  cat <<EOF
Usage: pacmode <mode>

Modes:
  pacmode home
  pacmode mobile

Change the "mode" of pacman. In "home" mode, pacman will use parallel downloads, whereas in "mobile" mode it will not in order to conserve bandwidth.
EOF
        ;;
    esac
  }
fi

