export SSH_AUTH_SOCK=~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

# Better less intrusive way would be to put this in ~/.ssh/config (using an install script)
# echo "Host *\n  IdentityAgent \"~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh\""" >> ~/.ssh/config
