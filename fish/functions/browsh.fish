function browsh
  docker run --rm -it --dns 8.8.8.8 browsh/browsh $argv
end
