
if [[ $(uname -p) = 'arm' ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
else
  export PAHTH="/usr/local/bin:$PATH"
fi