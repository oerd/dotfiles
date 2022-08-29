# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Pipenv (just ensures env var - no activation)
export PIPENV_VENV_IN_PROJECT=1

# Pipx-installed binaries
export PATH="$PATH:$HOME/.local/bin"

export PYENV_SHELL=zsh
PYENV_VER=$(pyenv --version | cut -d" " -f2)
source "/usr/local/Cellar/pyenv/${PYENV_VER}/libexec/../completions/pyenv.zsh"
command pyenv rehash 2>/dev/null
pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(pyenv "sh-$command" "$@")"
    ;;
  *)
    command pyenv "$command" "$@"
    ;;
  esac
}