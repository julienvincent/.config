#!/usr/bin/env sh

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  exit 0
fi

jj_log() {
  jj log --no-graph --ignore-working-copy -r "$1" -T "$2"
}

change_id() {
  jj_log "$1" 'change_id.shortest()'
}

dirty() {
  result=$(jj_log @ 'empty')
  if [ "$result" = "false" ]; then
    printf " (dirty)"
  fi
  printf ""
}

conflict() {
  result=$(jj_log @ 'conflict')
  if [ "$result" = "true" ]; then
    printf " [CONFLICT]"
  fi
  printf ""
}

current_change_id=$(change_id "@")
parent_change_id=$(change_id "@-")

gray="\033[0;37m"
bold_gray="\033[1;30m"
bold_purple="\033[1;35m"
yellow="\033[0;33m"
bold_yellow="\033[1;33m"
bold_red="\033[1;31m"
reset="\033[0m"

printf "${bold_gray}(${bold_purple}${current_change_id}${bold_gray})[${bold_yellow}${parent_change_id}${bold_gray}]${gray}$(dirty)${bold_red}$(conflict)${reset}"
