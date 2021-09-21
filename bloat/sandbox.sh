#!/bin/zsh

function sandbox {
  local ID='';
  local ROOT='';
  local NO_REUSE_ROOT=false;
  local BINDS=();
  local TAKEOVER=false;
  local DISPLAY=false;
  local PROGRAM='';
  
  while true
  do
    if [[ ! -z "${1}" ]]
    then
      case "${1}" in
        '--help' )
          cat <<EOF
Usage: sandbox [OPTIONS] <PROGRAM>

Places PROGRAM inside of a FILESYSTEM sandbox. This allows you to take full control over where programs save their files, even if the program does not support doing that.

Options:
  --root <SRC>: Specify where on the host the sandbox should be. Defaults to an automatically generated directory in XDG_RUNTIME_DIR.
  --no-reuse-root: Disallow sandbox from reusing one of the automatically generated root directories for the same executable.
  --bind <SRC> <DST>: Bind SRC on the host to DST in the sandbox.
  --takeover: Use the exec command to dissolve the zsh process once bwrap has been run.
  --display: display the generated bwrap command intead of executing it. Mutually exclusive with --takeover.
EOF
          return 0;
          ;;
        '--root' )
          shift 1;
          (( ${#} < 1 )) && return 1;
          ROOT="${1}";
          ;;
        '--no-reuse-root' )
          NO_REUSE_ROOT=true;
          ;;
        '--bind' )
          shift 1;
          (( ${#} < 2 )) && return 1;
          BINDS+=("${1}" "${2}"); 
          shift 1;
          ;;
        '--takeover' )
          TAKEOVER=true;
          ;;
        '--display' )
          DISPLAY=true;
          ;;
        '--'* )
          echo "Unrecognized option '${1}'.";
          return 1;
          ;;
        * )
          PROGRAM="${1}";
          while true
          do
            (( ${#} < 1 )) && break;
            shift 1;
            PROGRAM+=" ${1}";
          done
          ;;
      esac
    fi
    
    (( ${#} < 1 )) && break;
    shift 1;
  done
  
  if [[ ${TAKEOVER} == true ]] \
  && [[ ${DISPLAY} == true ]]
  then
    echo "--takeover and --display are mutually exclusive.";
    return 1;
  fi
  
  if [[ -z "${ROOT}" ]]
  then
    [[ -z "${XDG_RUNTIME_DIR}" ]] \
      && XDG_RUNTIME_DIR="/run/user/$(id -u)";

    if [[ ! -e "${XDG_RUNTIME_DIR}/sandbox" ]]
    then
      mkdir -p "${XDG_RUNTIME_DIR}/sandbox";
    fi
    
    if [[ ! ${NO_REUSE_ROOT} == true ]]
    then
      local PROGRAM_EXECUTABLE="$(which $(echo "${PROGRAM}" | awk '{print $1;}'))";
      
      if [[ "${PROGRAM_EXECUTABLE}" == *'not found'* ]]
      then
        echo "Couldn't find ${PROGRAM}. Make sure its in PATH on the host.";
        return 1;
      fi
      
      if [[ -e "${XDG_RUNTIME_DIR}/sandbox/existing" ]]
      then
        cat "${XDG_RUNTIME_DIR}/sandbox/existing" | while read -r LINE
        do
          [[ ! "${LINE}" == *'%'* ]] && continue;
          
          local TMP=();
          
          local IFS='%'; read -rA TMP <<< "${LINE}";
          
          if [[ "${PROGRAM_EXECUTABLE}" == "${TMP[1]}" ]]
          then
            ID="${TMP[2]}";
            break;
          fi
        done
      fi
      
      if [[ -z "${ID}" ]]
      then
        ID="$(\
            cat '/dev/urandom' \
          | tr -dc 'a-zA-Z0-9' \
          | fold -w 8 \
          | head -n 1 \
        )";
        printf "${PROGRAM_EXECUTABLE}%%${ID}\n" >> "${XDG_RUNTIME_DIR}/sandbox/existing";
      fi
      
      ROOT="${XDG_RUNTIME_DIR}/sandbox/${ID}"; 
    else
      echo "--no-reuse-root cannot be used without also specifying --root.";
      return 1;
    fi
  fi
  
  if [[ ! -e "${ROOT}" ]]
  then
    mkdir -p "${ROOT}";
    mkdir -p "${ROOT}/home";
    mkdir -p "${ROOT}/tmp";
    mkdir -p "${ROOT}/usr";
    mkdir -p "${ROOT}/var";
    
    ln -sf /usr/bin "${ROOT}/bin";
    ln -sf /usr/lib "${ROOT}/lib";
    ln -sf /usr/lib64 "${ROOT}/lib64";
    ln -sf /usr/sbin "${ROOT}/usr/sbin";
    
    mkdir -p "${ROOT}/home/${USER}";
    mkdir -p "${ROOT}/home/${USER}/.config";
  fi
  
  local COMMAND='bwrap';
  COMMAND+=" --die-with-parent";
  [[ ! -z "${ID}" ]] \
    && COMMAND+=" --setenv 'SANDBOX' '${ID}'" \
    || COMMAND+=" --setenv 'SANDBOX' '${ROOT##*/}'";
  COMMAND+=" --bind '${ROOT}' /";
  COMMAND+=" --ro-bind /usr /usr";
  COMMAND+=" --ro-bind /etc /etc";
  COMMAND+=" --bind /run /run";
  COMMAND+=" --proc /proc";
  COMMAND+=" --dev /dev";
  COMMAND+=" --ro-bind '/home/${USER}/.config/gtk-3.0' '/home/${USER}/.config/gtk-3.0'";
  COMMAND+=" --ro-bind '/home/${USER}/.env' '/home/${USER}/.env'";
  COMMAND+=" --ro-bind '/home/${USER}/.zshrc' '/home/${USER}/.zshrc'";
  COMMAND+=" --ro-bind '/home/${USER}/.zprofile' '/home/${USER}/.zprofile'";
  
  for (( I=1; I<${#BINDS[@]}; I+=2 ))
  do
    COMMAND+=" --bind '${BINDS[${I}]}' '${BINDS[$((${I} + 1))]}'";
  done
  
  if [[ ${DISPLAY} == true ]]
  then
    echo "${COMMAND} ${PROGRAM}";
    return 0;
  fi
  
  [[ ${TAKEOVER} == true ]] \
    && eval exec ${COMMAND} ${PROGRAM} \
    || eval ${COMMAND} ${PROGRAM};
}

