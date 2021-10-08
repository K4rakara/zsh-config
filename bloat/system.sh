#!/bin/zsh

function systemctl { sudo /usr/bin/systemctl ${@}; }

function shutdown { sudo /usr/bin/systemctl poweroff; }

function reboot { sudo /usr/bin/systemctl reboot; }

function flatpak {
  if [[ "${1}" == "install" ]] \
  || [[ "${1}" == "uninstall" ]] \
  || [[ "${1}" == "update" ]]
  then
    sudo /usr/bin/flatpak ${@};
  else
    /usr/bin/flatpak ${@};
  fi
}

if [[ "$(cat /etc/os-release 2>/dev/null)" == *"archlinux"* ]]
then
  function pacman {
    local CONTAINED_VERSION_FLAG=false;
    local CONTAINED_HELP_FLAG=false;
    local CONTAINED_FULL_UPGRADE_FLAGS=false;
    local CONTAINED_RESTORE_FLAG=false;
    
    for FLAG in ${@}
    do
      [[ "${FLAG}" == '--version' ]] \
      || [[ "${FLAG}" == '-V' ]] \
      && CONTAINED_VERSION_FLAG=true;
      
      [[ "${FLAG}" == '--help' ]] \
      || [[ "${FLAG}" == '-H' ]] \
      && CONTAINED_HELP_FLAG=true;
      
      [[ "${FLAG}" == '-'*'S'* ]] \
      && [[ "${FLAG}" == '-'*'y'* ]] \
      && [[ "${FLAG}" == '-'*'u'* ]] \
      && CONTAINED_FULL_UPGRADE_FLAGS=true;
      
      [[ "${FLAG}" == "-Z"* ]] \
      && CONTAINED_RESTORE_FLAG=true;
    done
    
    if [[ ${CONTAINED_VERSION_FLAG} == true ]]
    then
      /usr/bin/pacman --version;
      echo "                       $(paru --version)";
      echo;
    elif [[ ${CONTAINED_HELP_FLAG} == true ]]
    then
      /usr/bin/paru --help \
        | sed 's/paru/pacman/g' \
        | sed 's/\(.*getpkgbuild.*\)/\1\n    pacman {-Z --restore}     [options] [package(s)]/';
    elif [[ ${CONTAINED_FULL_UPGRADE_FLAGS} == true ]]
    then
      /usr/bin/paru -Qm > "${HOME}/.cache/paru/prev-aur-package-versions";
      
      /usr/bin/paru ${@};
    elif [[ ${CONTAINED_RESTORE_FLAG} == true ]]
    then
      local RESTORE="${HOME}/.cache/paru/prev-aur-package-versions";
      if [[ ! -e "${RESTORE}" ]]
      then
        cat /dev/null > "${RESTORE}";
      fi
      
      local PKGS=();
      local FLAGS=();
      local ARGS=();
      
      for ARG in ${@}
      do
        if [[ "${ARG}" != '-'* ]]
        then
          PKGS+=("${ARG}");
        elif [[ "${ARG}" != '-Z' ]] \
        || [[ "${ARG}" == '-Z'* ]]
        then
          FLAGS+=("${ARG:2}");
        else
          ARGS+=("${ARG}");
        fi
      done
      
      local RESTORE_ARCHIVES=();
      
      for PKG in ${PKGS}
      do
        local PKG_VER="$(cat "${RESTORE}" | grep -oP "(?<=${PKG}\s).*")";
        echo "${PKG_VER}";
        if [[ -z "${PKG_VER}" ]]
        then
          echo "error: ${PKG} does not have a previous version to restore to";
          return 1;
        fi
        RESTORE_ARCHIVES+=("${HOME}/.cache/paru/clone/${PKG}/${PKG}-${PKG_VER}-x86_64.pkg.tar.zst");
      done
      
      /usr/bin/paru "-U${FLAGS[@]}" ${ARGS} ${RESTORE_ARCHIVES};
    elif (( ${#} > 0 ))
    then
      /usr/bin/paru ${@};
    else
      /usr/bin/pacman;
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

