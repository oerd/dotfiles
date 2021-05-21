#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

brew_install() {
  local command=$1
  local command_with_options=$@

  echo "Command: $command"
  echo "Command with options: $command_with_options"

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
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  fi

fi

# Install `wget` with IRI support.
brew_install wget --with-iri
# Install GnuPG to enable PGP-signing commits.
brew_install gnupg
brew_install grep
brew_install openssh
brew_install screen
brew_install git
brew_install git-lfs
brew_install ssh-copy-id
brew_install asdf
brew_install starship

exit 0
