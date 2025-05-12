#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

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

brew insall 1password-cli
brew install asdf
brew install bat
brew install fzf
brew install gh
brew install git
brew install git-lfs
brew install gnupg
brew install grep
brew install hashicorp/tap/terraform
brew install jq
brew install mas
brew install ne
brew install neovim
brew install openssh
brew install pyenv
brew install screen
brew install ssh-copy-id
brew install starship
brew install wget
brew install uv
brew install yq
brew install zsh

# Install Casks
brew install --cask 1password
brew install --cask brave-browser
brew install --cask coconutbattery
brew install --cask discord
brew install --cask ghostty
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
brew install font-anonymice-nerd-font
brew install font-fira-code-nerd-font
brew install font-fira-mono-for-powerline
brew install font-jetbrains-mono-nerd-font
brew install font-jetbrains-mono-nerd-font
brew install font-sauce-code-pro-nerd-font
brew install font-source-code-pro-for-powerline
# Monaspace from Github-Next includes nerd-fonts
brew install font-monaspace

## install apps via the Mac App Store
# requires mas-cli
if test ! $(which mas)
then
  echo "  Installing Mac App Store (mas) cli for you."
  brew_install mas
fi
mas install 882812218  #  Owly (example -- switched to Hammerspoon caffeine)

exit 0
