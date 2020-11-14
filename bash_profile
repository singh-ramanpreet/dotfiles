# ========================================
#| title           :bash_profile          |
#| description     :personal bash profile |
#| author          :Ramanpreet Singh      |
#| bash_version    :4.2.46 or higher      |
# ========================================

# dotfiles directory location
DOTFILE_DIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}))

# source which_machine
if [[ -d $DOTFILE_DIR ]]
then
  . $DOTFILE_DIR/which_machine
fi

# Source global definitions
if [[ $thisMachine =~ ^(cmslpc)$ ]]
then
  if [[ -f /etc/bashrc ]]
  then
    . /etc/bashrc
  fi
fi

# Source local definitions
if [[ -f ~/.bashrc ]]
then
  . ~/.bashrc
fi

# set PATH so it includes user's private bin if it exists
if [[ -d ~/.local/bin ]]
then
    PATH=~/.local/bin:$PATH
fi

# locales
if [[ $thisMachine =~ ^(cmslpc)$ ]]
then
  export LANG=en_US.UTF-8
  export LANGUAGE=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
fi

# history
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=1000000
export HISTSIZE=1000000
#shopt -s histappend
#export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

# display
if [[ $thisMachine =~ ^(local)$ ]]
then
  export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0
fi

# ssh agent
if [[ $thisMachine =~ ^(local)$ ]]
then
  if [[ "$(ps -u $USER | grep ssh-agent | wc -l)" -lt "1" || ! -S $HOME/.ssh/ssh_auth_sock ]]
  then
    find /tmp -maxdepth 1 -type d -name "ssh-*" -exec rm -rv {} \;
    eval $(ssh-agent -s)
    ln -sf "$SSH_AUTH_SOCK" $HOME/.ssh/ssh_auth_sock
  fi
  export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
  ssh-add -l > /dev/null || ssh-add $HOME/.ssh/*_rsa
fi

# Kerberos
if [[ $thisMachine =~ ^(local)$ ]]
then
  export KRB5CCNAME="DIR:/tmp"
  kinit -k -t ~/.ssh/singhr.keytab rsingh@FNAL.GOV
  kinit -k -t ~/.ssh/singhr.keytab singhr@CERN.CH
fi

# colorize PS1
if [[ $thisMachine =~ ^(cmslpc|lxplus)$ ]]
then
  export PS1="\[\e[33m\]$PS1\[\e[m\]"
fi

# TexLive
if [[ $thisMachine =~ ^(local|cmslpc|lxplus)$ ]]
then
  export TEXMFVAR=~/.texlive2017/
  export PATH=/cvmfs/sft.cern.ch/lcg/external/texlive/2017/bin/x86_64-linux:$PATH
fi

# cmssw commands
if [[ $thisMachine =~ ^(cmslpc|lxplus)$ ]]
then
  export CMSSW_GIT_REFERENCE=/cvmfs/cms.cern.ch/cmssw.git.daily
  if $isInteractive && [[ -f /cvmfs/cms.cern.ch/cmsset_default.sh ]]
  then
    source /cvmfs/cms.cern.ch/cmsset_default.sh
  fi
fi

# poweline-go
# --------------
function _update_ps1() {
  PS1="$(~/.local/bin/powerline-go -newline -modules "venv,user,host,cwd,perms,git,exit,root")"
}

if [[ $TERM != "linux" && -f ~/.local/bin/powerline-go ]]
then
  PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
# --------------

# diff-so-fancy
if [[ -d ~/.diff-so-fancy ]]
then
  export PATH=~/.diff-so-fancy/:$PATH
fi

# fzf fuzzy finder
if $isInteractive && [[ -f ~/.fzf.bash ]]
then
  source ~/.fzf.bash
fi

# miniconda
if [[ $thisMachine =~ ^(cmslpc|lxplus)$ ]]
then
  MINICONDA3_=~/nobackup/miniconda3
elif [[ $thisMachine =~ ^(local)$ ]]
then
  MINICONDA3_=~/miniconda3
fi
if $isInteractive && [[ -f $MINICONDA3_/etc/profile.d/conda.sh ]]
then
  source $MINICONDA3_/etc/profile.d/conda.sh
fi

# singularity
export SINGULARITY_SHELL="/bin/bash/"
if [[ $thisMachine =~ ^(cmslpc|lxplus)$ ]]
then
  if $isInteractive && [[ -f /etc/bash_completion.d/singularity ]]
  then
    source /etc/bash_completion.d/singularity
  fi
elif [[ $thisMachine =~ ^(local)$ ]]
then
  export PATH=/opt/singularity/bin:$PATH
  if $isInteractive && \
    [[ -f /opt/singularity/etc/bash_completion.d/singularity ]]
  then
    source /opt/singularity/etc/bash_completion.d/singularity
  fi
fi

# EOS MGM URL
if [[ $thisMachine =~ ^(cmslpc)$ ]]
then
  export EOS_MGM_URL="root://cmseos.fnal.gov"
fi

# aliases
if [[ $thisMachine =~ ^(cmslpc|lxplus)$ ]]
then
  # crab
  alias crab3_source="source /cvmfs/cms.cern.ch/crab3/crab_standalone.sh"
  # jlab venv
  alias jlab_start="PATH=~/nobackup/miniconda3/envs/jupyterlab/bin/:$PATH jupyter lab"
  # setup LCG 97 python3
  alias setup_LCG97python3="source /cvmfs/sft.cern.ch/lcg/views/LCG_97python3/x86_64-centos7-gcc8-opt/setup.sh"
fi
