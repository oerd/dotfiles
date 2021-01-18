if test ! $(which powerline-go)
then
  if test $(which go)
  then
    go get -u github.com/justjanne/powerline-go
  fi
fi
