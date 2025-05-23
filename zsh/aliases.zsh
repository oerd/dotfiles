alias reload!='. ~/.zshrc'

alias cls='clear' # Good 'ol Clear Screen command
alias zshconfig="code ~/.zshrc"

alias lt=tree
alias cat=bat

# These make things like `cd ...` go up three directories.
alias -g      ...=../..
alias -g     ....=../../..
alias -g    .....=../../../..
alias -g   ......=../../../../..
alias -g  .......=../../../../../..
alias -g ........=../../../../../../..

# This alias opens your current directory in Finder.
alias f='open -a Finder ./'

# This function means `cdf` changes directory to that of your frontmost Finder window.
cdf() {
    target=`osascript -e 'tell application "Finder" to get POSIX path of (target of front Finder window as text)'`
    cd "$target"
}

alias pycharm=/Applications/PyCharm.app/Contents/MacOS/pycharm
