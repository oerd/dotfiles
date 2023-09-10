
if [[ $(uname -p) = 'arm' ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
else
  export PATH="/usr/local/bin:$PATH"
fi
