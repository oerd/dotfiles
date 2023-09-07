
if test ! $(which powerline-go)
then
  if test ! $(which go)
  then
    brew install go
  else
    go get -u github.com/justjanne/powerline-go
  fi
fi
