export NVM_DIR="$HOME/.nvm"

# create nmv home if not exist
[ -d $NVM_DIR ] || mkdir -p $NVM_DIR

# Load nvm
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"

# Load nvm bash_completion
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"