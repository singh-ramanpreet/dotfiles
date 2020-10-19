#!/bin/bash

# ========================================
#| title           :package installer     |
#| description     :                      |
#| author          :Ramanpreet Singh      |
#| bash_version    :4.2.46 or higher      |
# ========================================

usage() {
  echo "Usage: $0 [ --install NAME ] [ --reinstall NAME ] " 1>&2
  echo ""
  echo "  --install Package Name"
  echo "  --reinstall Package Name"
}

exit_abnormal() {
  usage
  exit 1
}

install_=""
reinstall_=""

while test -n "$1"; do
  case "$1" in
    --install )
        install_=$2
        shift 2
        ;;
    --reinstall )
        reinstall_=$2
        shift 2
        ;;
    *)
      exit_abnormal
      ;;
  esac
done


PATTERN="^(diff-so-fancy)$"
if [[ $install_ =~ $PATTERN || $reinstall_ =~ $PATTERN ]]; then
echo "Installing diff-so-fancy"
  if [[ $reinstall_ =~ $PATTERN ]]; then
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


PATTERN="^(fzf)$"
if [[ $install_ =~ $PATTERN || $reinstall_ =~ $PATTERN ]]; then
echo "Installing fzf"
  if [[ $reinstall_ =~ $PATTERN ]]; then
    echo "... cleaning up for re-installation"
    rm -rf $HOME/.fzf
    rm $HOME/.fzf.*
  fi

  if [[ -d $HOME/.fzf ]]; then
    echo "... already installed, skipping."
  else
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc --no-zsh --no-fish
  fi

  echo "Done"
fi


PATTERN="^(powerline-go)$"
if [[ $install_ =~ $PATTERN || $reinstall_ =~ $PATTERN ]]; then
echo "Installing powerline-go"
  if [[ $reinstall_ =~ $PATTERN ]]; then
    echo "... cleaning up for re-installation"
    rm $HOME/.local/bin/powerline-go
  fi

  if [[ -f $HOME/.local/bin/powerline-go ]]; then
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


PATTERN="^(singularity)$"
if [[ $install_ =~ $PATTERN || $reinstall_ =~ $PATTERN ]]; then
echo "Installing singularity"
  if [[ $reinstall_ =~ $PATTERN ]]; then
    echo "... cleaning up for re-installation"
    sudo rm -rf /opt/singularity
  fi

  if [[ -d /opt/singularity ]]; then
    echo "... already installed, skipping."
  else
    echo "... installing dependencies"
    sudo apt-get update
    sudo apt-get install -y \
      golang
      build-essential \
      uuid-dev \
      libgpgme-dev \
      squashfs-tools \
      libseccomp-dev \
      wget \
      pkg-config \
      git \
      cryptsetup-bin
    echo "..."
    echo "... dependencies installed"
    (
      cd /tmp
      export VERSION=3.6.4
      echo "... singularity version to be installed $VERSION"
      wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz
      tar -xzf singularity-${VERSION}.tar.gz
      cd singularity
      echo "... building config"
      ./mconfig --prefix=/opt/singularity
      make -C ./builddir
      sudo make -C ./builddir install
      echo "... removing temp files"
      cd ..
      rm -rf singularity*
    )
  fi

  echo "Done"
fi
