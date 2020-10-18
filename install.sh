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


PATTERN="^(diff-so-fancy|all)$"
if [[ $install_this =~ $PATTERN || $reinstall_this =~ $PATTERN ]]; then
echo "Installing diff-so-fancy"
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


PATTERN="^(fzf|all)$"
if [[ $install_this =~ $PATTERN || $reinstall_this =~ $PATTERN ]]; then
echo "Installing fzf"
  if [[ $reinstall_this =~ $PATTERN ]]; then
    echo "... cleaning up for re-installation"
    rm -rf $HOME/.fzf
  fi

  if [[ -d $HOME/.fzf ]]; then
    echo "... already installed, skipping."
  else
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc --no-zsh --no-fish
  fi

  echo "Done"
fi


PATTERN="^(powerline-go|all)$"
if [[ $install_this =~ $PATTERN || $reinstall_this =~ $PATTERN ]]; then
echo "Installing powerline-go"
  if [[ $reinstall_this =~ $PATTERN ]]; then
    echo "... cleaning up for re-installation"
    rm $HOME/.local/bin/powerline-go
  fi

  if [[ -d $HOME/.local/bin/powerline-go ]]; then
    echo "... already installed, skipping."
  else
    download_url=$(curl -s https://api.github.com/repos/justjanne/powerline-go/releases/latest | \
    grep -E "browser_download_url.*linux-amd64" | \
    cut -d ":" -f 2-)
    mkdir -p $HOME/.local/bin
    wget -O $HOME/.local/bin/powerline-go ${download_url//\"/}
    chmod +x $HOME/.local/bin/powerline-go
  fi

  echo "Done"
fi
