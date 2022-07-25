#!/bin/bash

# ========================================
#| description     : install bash .files  |
#| author          : Ramanpreet Singh     |
# ========================================

DOTFILES_DIR=$(dirname $(dirname $(readlink -f $0)))

echo "Making Symbolic Links"
rm -f ~/.profile
ln -s -f $DOTFILES_DIR/bash/profile.sh $HOME/.bash_profile
ln -s -f $DOTFILES_DIR/vimrc $HOME/.vimrc
ln -s -f $DOTFILES_DIR/gitconfig $HOME/.gitconfig
echo "... Done"


echo "Installing diff-so-fancy"
if [[ -d $HOME/.diff-so-fancy ]]; then
  rm -rf $HOME/.diff-so-fancy
fi
git clone https://github.com/so-fancy/diff-so-fancy.git $HOME/.diff-so-fancy
echo "... Done"


echo "Installing fzf"
if [[ -d $HOME/.fzf ]]; then
  rm -rf $HOME/.fzf
  rm $HOME/.fzf.*
fi
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc --no-zsh --no-fish
echo "... Done"


echo "Installing powerline-go"
if [[ -f $HOME/.local/bin/powerline-go ]]; then
  rm $HOME/.local/bin/powerline-go
fi
download_url=$(curl -s https://api.github.com/repos/justjanne/powerline-go/releases/latest | \
grep -E "browser_download_url.*linux-amd64" | cut -d ":" -f 2-)
mkdir -p $HOME/.local/bin
wget -O $HOME/.local/bin/powerline-go ${download_url//\"/}
chmod +x $HOME/.local/bin/powerline-go
echo "... Done"


exit 1
