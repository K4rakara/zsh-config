#!/bin/zsh

function __in_git_directory {
  if [[ -e ".git" ]]
  then
    return 0;
  elif [[ "$(git rev-parse --is-inside-work-tree 2>&1)" != *"fatal"* ]]
  then
    return 0;
  else
    return 1;
  fi
}

function __prompt {
  __PROMPT_CONTEXT="";
  __PROMPT_SANDBOX="";
  __PROMPT_DIRECTORY="";
  __PROMPT_GIT="";
  
  function __prompt_context_setup {
    __PROMPT_CONTEXT=" %B%n%F{blue}@%M%f%b ";
  }
  
  function __prompt_sandbox_setup {
    [[ ! -z "${SANDBOX}" ]] \
      && __PROMPT_SANDBOX="%F{244}(sandbox:${SANDBOX})%f ";
  }
  
  function __prompt_directory_refresh {
    [[ "${PWD}" == "${HOME}" ]] \
      && __PROMPT_DIRECTORY="~" \
      || __PROMPT_DIRECTORY="${PWD##*/}";
    __PROMPT_DIRECTORY="%F{green}\"${__PROMPT_DIRECTORY}\"%f ";   
    
    if __in_git_directory
    then
      __PROMPT_GIT="%F{yellow}󰊢 %f ";
    else
      __PROMPT_GIT="";
    fi
    
    __prompt_refresh;
  }
  
  function __prompt_directory_setup {
    autoload add-zsh-hook;
    add-zsh-hook chpwd __prompt_directory_refresh;
    __prompt_directory_refresh;
  } 
  
  function __prompt_refresh {
    PROMPT="";
    PROMPT="${PROMPT}${__PROMPT_CONTEXT}";
    PROMPT="${PROMPT}${__PROMPT_SANDBOX}";
    PROMPT="${PROMPT}${__PROMPT_DIRECTORY}"
    PROMPT="${PROMPT}${__PROMPT_GIT}$ ";
  }
  
  __prompt_context_setup;
  __prompt_sandbox_setup;
  __prompt_directory_setup;
  __prompt_refresh;
}

__prompt;

