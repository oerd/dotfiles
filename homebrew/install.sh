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

# Brew is required
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

#
# Taps
#
brew tap FelixKratz/formulae # sketchybar
brew tap nikitabobko/tap     # aerospace

brew_install asdf
brew_install bat
brew_install fzf
brew_install gh
brew_install git
brew_install git-lfs
brew_install gnupg
brew_install grep
brew_install jq
brew_install mas
brew_install ne
brew_install neovim
brew_install openssh
brew_install pipx
brew_install pyenv
brew_install screen
brew_install ssh-copy-id
brew_install starship
brew_install terraform
# brew_install volta
brew_install wget
brew install uv
brew_install yq
brew_install zsh
brew install sketchybar
brew install aerospace

# Install Casks
brew install --cask 1password
brew install --cask brave-browser
brew install --cask coconutbattery
brew install --cask discord
brew install --cask ghostty
brew install --cask iterm2
brew install --cask jetbrains-toolbox
brew install --cask meetingbar
# brew install --cask monitorcontrol
brew install --cask orbstack
brew install --cask rectangle
brew install --cask secretive
brew install --cask slack
brew install --cask sublime-text
brew install --cask zed

## install fonts
brew_install font-anonymice-nerd-font
brew_install font-fira-code-nerd-font
brew_install font-fira-mono-for-powerline
brew_install font-jetbrains-mono-nerd-font
brew_install font-jetbrains-mono-nerd-font
brew_install font-sauce-code-pro-nerd-font
brew_install font-source-code-pro-for-powerline

## install apps via the Mac App Store
# requires mas-cli
if test ! $(which mas)
then
  echo "  Installing Mac App Store (mas) cli for you."
  brew_install mas
fi
mas install 882812218  #  Owly (example -- switched to Hammerspoon caffeine)

exit 0
