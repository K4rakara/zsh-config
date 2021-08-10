#!/bin/zsh

function archive {
  if [[ -z "${1}" ]]
  then
    echo "Usage: archive <archive name> [<file names>...]";
    return;
  fi
   
  local FILE="${1}";
  
  shift 1;
  
  case "${FILE}" in
    *.tar.bz2 ) tar cjf "${FILE}" ${@} ;;
    *.tar.gz ) tar czf "${FILE}" ${@} ;;
    *.bz2 ) bzip2 "${FILE}" ${@} ;;
    *.rar ) rar a "${FILE}" ${@} ;;
    *.gz ) gzip "${FILE}" ${@} ;;
    *.tar ) tar cf "${FILE}" ${@} ;;
    *.tbz2 ) tar cjf "${FILE}" ${@} ;;
    *.tgz ) tar czf "${FILE}" ${@} ;;
    *.zip ) zip "${FILE}" ${@} ;;
    *.7z ) 7z a "${FILE}" ${@} ;;
    * ) echo "'${FILE}' is not supported by archive." ;;
  esac
}

function unarchive {
  if [[ -z "${1}" ]]
  then
    echo "Usage: unarchive <archive name> [<file names>...]";
    return;
  elif [[ -f "${1}" ]]
  then
    case "${1}" in
      *.tar.bz2 ) tar xjf "${1}" ;;
      *.tar.gz ) tar xzf "${1}" ;;
      *.bz2 ) bunzip2 "${1}" ;;
      *.rar ) rar x "${1}" ;;
      *.gz ) gunzip "${1}" ;;
      *.tar ) tar xf "${1}" ;;
      *.tbz2 ) tar xjf "${1}" ;;
      *.tgz ) tar xzf "${1}" ;;
      *.zip ) unzip "${1}" ;;
      *.7z ) 7z x "${1}" ;;
      * ) echo "'${1}' is not supported by unarchive." ;;
    esac
  else
    echo "'${1}' is not a file.";
  fi
}

