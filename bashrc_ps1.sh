#!/bin/bash
# shellcheck disable=SC2034
        RED="\[\033[0;31m\]"
# shellcheck disable=SC2034
     YELLOW="\[\033[1;33m\]"
# shellcheck disable=SC2034
      GREEN="\[\033[0;32m\]"
# shellcheck disable=SC2034
       BLUE="\[\033[1;34m\]"
# shellcheck disable=SC2034
  LIGHT_RED="\[\033[1;31m\]"
# shellcheck disable=SC2034
LIGHT_GREEN="\[\033[1;32m\]"
# shellcheck disable=SC2034
      WHITE="\[\033[1;37m\]"
# shellcheck disable=SC2034
 LIGHT_GRAY="\[\033[0;37m\]"
# shellcheck disable=SC2034
 COLOR_NONE="\[\e[0m\]"
function is_git_repository {
   git branch > /dev/null 2>&1
 }

 function set_git_branch {
   # Set the final branch string
   BRANCH=" ($(parse_git_branch))"
   local TIME
   # shellcheck disable=SC2034
   TIME=$(fmt_time) # format time for prompt string
 }

 function parse_git_branch() {
   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
 }

 function parse_git_dirty() {
   [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
 }

 fmt_time () { #format time just the way I likes it
     if [ "$(date +%p)" = "PM" ]; then
         meridiem="pm"
     else
         meridiem="am"
     fi
     date +"%l:%M:%S$meridiem"|sed 's/ //g'
 }

 # Return the prompt symbol to use, colorized based on the return value of the
 # previous command.
 function set_prompt_symbol () {
   if test "${1}" -eq 0 ; then
       PROMPT_SYMBOL="\$"
   else
       PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
   fi
 }

 # Determine active Python virtualenv details.
 function set_virtualenv () {
   if test -z "$VIRTUAL_ENV" ; then
       PYTHON_VIRTUALENV=""
   else
       PYTHON_VIRTUALENV=" [$(basename "${VIRTUAL_ENV}")]"
   fi
 }

 # Set the full bash prompt.
 function set_bash_prompt () {
   # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
   # return value of the last command.
   set_prompt_symbol $?

   # Set the PYTHON_VIRTUALENV variable.
   set_virtualenv

   # Set the BRANCH variable.
   if is_git_repository ; then
     set_git_branch
   else
     BRANCH=''
   fi



   # Set the bash prompt variable.
   PS1="${GREEN}\u@\h${COLOR_NONE}${YELLOW}${PYTHON_VIRTUALENV}${COLOR_NONE}:${BLUE}\w${COLOR_NONE}${LIGHT_GRAY}${BRANCH}${COLOR_NONE} ${PROMPT_SYMBOL} "
 }

 # Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt