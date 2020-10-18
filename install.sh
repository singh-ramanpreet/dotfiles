#!/bin/bash

# ========================================
#| title           :dotfiles install      |
#| description     :                      |
#| author          :Ramanpreet Singh      |
#| bash_version    :4.2.46 or higher      |
# ========================================

# dotfiles directory location
DOTFILE_DIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}))

# source which_machine
if [[ -d $DOTFILE_DIR ]]; then
  . $DOTFILE_DIR/which_machine
fi

usage() {
  echo "Usage: $0 [ --all ] [ --only NAME ] [ --re-install ] [ --re-install-only NAME ]" 1>&2
  echo ""
  echo "  --all Install everything"
  echo "  --only Install only NAME"
  echo "  --re-install Remove and re-install everything"
  echo "  --re-install-only Remove and re-install everything"
}

exit_abnormal() {
  usage
  exit 1
}

install_this=""
reinstall_this=""

while test -n "$1"; do
  case "$1" in
    --all )
        install_this="all"
        shift 1
        ;;
    --only )
        install_this=$2
        shift 2
        ;;
    --re-install )
        reinstall_this="all"
        shift 1
        ;;
    --re-install-only )
        reinstall_this=$2
        shift 2
        ;;
    *)
      exit_abnormal
      ;;
  esac
done


echo "Installing diff-so-fancy"
PATTERN="^(diff-so-fancy|all)$"
if [[ $install_this =~ $PATTERN || $reinstall_this =~ $PATTERN ]]; then
  if [[ $reinstall_this =~ $PATTERN ]]; then
    echo "... cleaning up for re-installation"
    rm -rf $HOME/.diff-so-fancy
  fi

  if [[ -d $HOME/.diff-so-fancy ]]; then
    echo "... already installed, skipping."
  else
    git clone https://github.com/so-fancy/diff-so-fancy.git $HOME/.diff-so-fancy
  fi

  echo "Done"
fi

