#!/bin/zsh

function daemonize {
  nohup ${@} < /dev/null 1> /dev/null 2> /dev/null & ;
}

