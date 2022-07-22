set nocompatible
filetype off

set mouse=a

set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4

set number
colorscheme darkblue
if &diff
    colorscheme blue
endif


" Check to see if vundle is installed.  If not, install it.
let vundle_already_installed=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
  echo "Installing Vundle..."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  let vundle_already_installed=0
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" jedi-vim Python autocompletion
" Plugin 'davidhalter/jedi-vim'

" Airline, gives status line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" All of your Plugins must be added before the following line
call vundle#end()

" If vundle wasn't installed, install it. Now install the plugins.
if vundle_already_installed == 0
  echo "Installing Bundles, please ignore key map error messages"
  echo ""
  :PluginInstall
endif

filetype plugin indent on
