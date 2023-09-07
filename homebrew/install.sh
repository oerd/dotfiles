#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

brew_install() {
  local command=$1
  local command_with_options=$@

  local result=$(which $command)
  if [ -z $result ]
  then
    brew install $command_with_options
  fi
}

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/HEAD/install.sh)"
  fi

fi

# Install `wget` with IRI support.
brew_install wget
brew_install fzf
# Install GnuPG to enable PGP-signing commits.
brew_install gnupg
brew_install grep
brew_install openssh
brew_install screen
brew_install git
brew_install git-lfs
brew_install gh
brew_install ssh-copy-id
brew_install pyenv
brew_install pipx
brew_install asdf
brew_install neovim
brew_install starship
brew_install volta
brew_install zsh
brew_install ne
brew_install jq
brew_install yq


# Install Casks
brew install --cask brave-browser
brew install --cask coconutbattery
brew install --cask docker
brew install --cask goland
brew install --cask intellij-idea
brew install --cask iterm2
brew install --cask lastpass
brew install --cask 1password
brew install --cask monitorcontrol
brew install --cask pycharm
brew install --cask rectangle
brew install --cask meetingbar
brew install --cask slack
brew install --cask sublime-text
brew install --cask visual-studio-code
brew install --cask postman
exit 0
