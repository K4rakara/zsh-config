#!/bin/zsh

function 2gif {
  if [[ -z "${1}" ]]
  then
    cat <<EOF
Usage: 2gif <file>

Quickly convert the specified file into a gif, with pretty decent quality.
EOF
    return 0;
  fi
  
  if [[ ! -e "${1}" ]]
  then
    echo "The file '${1}' does not exist!";
    return 1;
  fi
  
  local PROBED="$(ffprobe -v quiet -print_format json -show_streams "${1}")";
  local WIDTH="$(echo "${PROBED}" | jq '.streams[0].width')";
  local HEIGHT="$(echo "${PROBED}" | jq '.streams[0].height')";
  
  ffmpeg \
    -i "${1}" \
    -vf "fps=10,scale=${WIDTH}:${HEIGHT}:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -loop 0 \
    "$(echo "${1}" | sed -r 's/\.[A-Za-z0-9]+$/.gif/')";
}

