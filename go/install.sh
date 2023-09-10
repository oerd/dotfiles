
if test ! $(which powerline-go)
then
  if test ! $(which go)
  then
    brew install go
  fi
  go install github.com/justjanne/powerline-go@latest
fi
