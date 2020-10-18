# ========================================
#| title           :bash_profile          |
#| description     :personal bash profile |
#| author          :Ramanpreet Singh      |
#| bash_version    :4.2.46 or higher      |
# ========================================

# dotfiles directory location
DOTFILE_DIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}))

# source which_machine
if [[ -d $DOTFILE_DIR ]]; then
  . $DOTFILE_DIR/which_machine
fi

# Source global definitions
if [[ $thisMachine =~ ^(cmslpc)$ ]]; then
  if [[ -f /etc/bashrc ]]; then
    . /etc/bashrc
  fi
fi

# Source local definitions
if [[ $thisMachine =~ ^(cmslpc)$ ]]; then
  if [[ -f ~/.bashrc ]]; then
    . ~/.bashrc
  fi
fi

# locales
if [[ $thisMachine =~ ^(cmslpc)$ ]]; then
  export LANG=en_US.UTF-8
  export LANGUAGE=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
fi

# colorize PS1
if [[ $thisMachine =~ ^(cmslpc|lxplus)$ ]]; then
  export PS1="\[\e[33m\]$PS1\[\e[m\]"
fi

# TexLive
if [[ $thisMachine =~ ^(local|cmslpc|lxplus)$ ]]; then
  export TEXMFVAR=~/.texlive2017/
  export PATH=/cvmfs/sft.cern.ch/lcg/external/texlive/2017/bin/x86_64-linux:$PATH
fi

# cmssw commands
if [[ $thisMachine =~ ^(cmslpc|lxplus)$ ]]; then
  export CMSSW_GIT_REFERENCE=/cvmfs/cms.cern.ch/cmssw.git.daily
  if [[ $isInteractive = true ]]; then
    source /cvmfs/cms.cern.ch/cmsset_default.sh
  fi
fi

# poweline-go
# --------------
function _update_ps1() {
  PS1="$($HOME/go/bin/powerline-go -newline -modules "venv,user,host,cwd,perms,git,exit,root")"
}

if [[ $TERM != "linux" && -f $HOME/go/bin/powerline-go ]]; then
  PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
# --------------

# diff-so-fancy
if [[ -d ~/.diff-so-fancy ]]; then
  export PATH=~/.diff-so-fancy/:$PATH
fi

# fzf fuzzy finder
if [[ $thisMachine =~ ^(local|cmslpc|lxplus)$ ]]; then
  if [[ $isInteractive = true && -f ~/.fzf.bash ]]; then
    source ~/.fzf.bash
  fi
fi

# miniconda
if [[ $thisMachine =~ ^(cmslpc|lxplus)$ ]]; then
  if [[ $isInteractive = true ]]; then
    source ~/nobackup/miniconda3/etc/profile.d/conda.sh
  fi
fi

# singularity
if [[ $thisMachine =~ ^(cmslpc|lxplus)$ ]]; then
  if [[ $isInteractive = true ]]; then
    source /etc/bash_completion.d/singularity
  fi
fi

# EOS MGM URL
if [[ $thisMachine =~ ^(cmslpc)$ ]]; then
  export EOS_MGM_URL="root://cmseos.fnal.gov"
fi

# aliases
if [[ $thisMachine =~ ^(cmslpc|lxplus)$ ]]; then
  # crab
  alias crab3_source="source /cvmfs/cms.cern.ch/crab3/crab_standalone.sh"
  # jlab venv
  alias jlab_start="PATH=~/nobackup/miniconda3/envs/jupyterlab/bin/:$PATH jupyter lab"
  # setup LCG 97 python3
  alias setup_LCG97python3="source /cvmfs/sft.cern.ch/lcg/views/LCG_97python3/x86_64-centos7-gcc8-opt/setup.sh"
fi
