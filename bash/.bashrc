# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export BASH_PLUGINS_DIR=$HOME/.config/bash/plugins
source ".config/bash/bash_functions"

bash_add_plugin "rupa/z"

source ".config/bash/bash_exports"
source ".config/bash/bash_aliases"
source ".config/bash/bash_prompt"
source ".config/bash/bash_keybinds"

. "$HOME/.cargo/env"
