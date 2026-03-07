#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# 1. Check for Homebrew, install if not present
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. Add Homebrew to PATH (needed for Apple Silicon)
# For Apple Silicon
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
# For Intel Mac
elif [ -f "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
# For Linux
elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Install CLI apps
brew install atuin
brew install bat
brew install fzf
brew install gh
brew install git
brew install gnupg
brew install grep
brew install hashicorp/tap/terraform
brew install jq
brew install mas
brew install ne
brew install neovim
brew install openssh
brew install screen
brew install ssh-copy-id
brew install starship
brew install wget
brew install uv
brew install yq
brew install zsh

# Install GUI apps on MacOS
if test "$(uname)" = "Darwin"
    brew insall 1password-cli
then
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
fi
exit 0
