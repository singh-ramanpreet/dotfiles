#!/bin/bash

# ========================================
#| title           :package installer     |
#| description     :                      |
#| author          :Ramanpreet Singh      |
#| bash_version    :4.2.46 or higher      |
# ========================================

usage() {
  echo "Usage: $0 [ --machine NAME ] [ --force ] [ --reinstall ]" 1>&2
  echo ""
  echo "  --machine [NAME] Options: local, cmslpc, lxplus"
  echo "  --force          Do force remake of symbolic links. Default: false"
  echo "  --reinstall      Reinstall all packages. Default: false"
}

exit_abnormal() {
  usage
  exit 1
}

machine_=""
force_=false
reinstall_=false

while test -n "$1"; do
  case "$1" in
    --machine )
        machine_=$2
        shift 2
        ;;
    --force )
        force_=true
        shift 1
        ;;
    --reinstall )
        reinstall_=true
        shift 1
        ;;
    *)
      exit_abnormal
      ;;
  esac
done

if [[ $machine_ == "local" ]]; then
  echo "Symbolic Links"
  ln -s $($force_ && echo "-f") $(dirname $(readlink -f $0))/bash_profile $HOME/.bash_profile
  ln -s $($force_ && echo "-f") $(dirname $(readlink -f $0))/vimrc $HOME/.vimrc
  ln -s $($force_ && echo "-f") $(dirname $(readlink -f $0))/gitconfig $HOME/.gitconfig
  echo "... Done"
  echo "Packages"
  ./pkg-installer.sh $( $reinstall_ && echo "--reinstall" || echo "--install" ) diff-so-fancy
  ./pkg-installer.sh $( $reinstall_ && echo "--reinstall" || echo "--install" ) fzf
  ./pkg-installer.sh $( $reinstall_ && echo "--reinstall" || echo "--install" ) powerline-go
  #./pkg-installer.sh $( $reinstall_ && echo "--reinstall" || echo "--install" ) singularity
  ./pkg-installer.sh $( $reinstall_ && echo "--reinstall" || echo "--install" ) cvmfs
  echo "... Done"
else
  exit_abnormal
fi

exit 1