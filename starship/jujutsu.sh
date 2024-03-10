#!/usr/bin/env sh

inside_repo=false

dir="$PWD"
while [ "$dir" != "/" ]; do
  if [ -d "$dir/.jj" ]; then
    inside_repo=true
    break
  fi
  dir=$(dirname "$dir")
done

if [ "$inside_repo" = false ]; then
  exit 0
fi

jj_log() {
  jj log --no-graph --ignore-working-copy -r "$1" -T "$2"
}

dirty_text() {
  if [ "$1" = "false" ]; then
    printf "~"
  fi
  printf ""
}

conflict_text() {
  if [ "$1" = "true" ]; then
    printf " [CONFLICT]"
  fi
  printf ""
}

template='empty ++ " " ++ conflict ++ " " ++ change_id.shortest() ++ " " ++ parents.map(|c| c.change_id().shortest()).join(",")'

set -- $(jj_log @ "${template}")

dirty=$(dirty_text "${1}")
conflicted=$(conflict_text "${2}")
current_change_id="${3}"
parent_change_ids="${4}"

gray="\033[0;37m"
bold_gray="\033[1;30m"
bold_purple="\033[1;35m"
yellow="\033[0;33m"
bold_yellow="\033[1;33m"
bold_red="\033[1;31m"
reset="\033[0m"

printf "${bold_gray}(${bold_purple}${current_change_id}${bold_gray})[${bold_yellow}${parent_change_ids}${bold_gray}]${gray}${dirty}${bold_red}${conflicted}${reset}"
