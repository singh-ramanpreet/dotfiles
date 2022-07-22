# ========================================
#| description     : bash profile         |
#| author          : Ramanpreet Singh     |
# ========================================

# this machine
THIS_MACHINE="wsl"

# Source local definitions
if [[ -f ~/.bashrc ]]; then
  . ~/.bashrc
fi

# set PATH so it includes user's private bin if it exists
if [[ -d ~/.local/bin ]]; then
  PATH=~/.local/bin:$PATH
fi

# history
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

# ssh agent
if [[ $THIS_MACHINE =~ (wsl) ]]; then
  if [[ "$(ps -u $USER | grep ssh-agent | wc -l)" -lt "1" || ! -S $HOME/.ssh/ssh_auth_sock ]]; then
    find /tmp -maxdepth 1 -type d -name "ssh-*" -exec rm -rv {} \;
    eval $(ssh-agent -s)
    ln -sf "$SSH_AUTH_SOCK" $HOME/.ssh/ssh_auth_sock
  fi
  export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
  ssh-add -l > /dev/null || ssh-add $HOME/.ssh/*_key
fi


# poweline-go
function _update_ps1() {
  PS1="$(~/.local/bin/powerline-go -newline -modules "venv,user,host,cwd,perms,git,exit,root")"
}
if [[ $TERM != "linux" && -f ~/.local/bin/powerline-go ]]; then
  PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi


# diff-so-fancy
if [[ -d ~/.diff-so-fancy ]]; then
  export PATH=~/.diff-so-fancy/:$PATH
fi


# fzf fuzzy finder
if [[ -f ~/.fzf.bash ]]; then
  source ~/.fzf.bash
fi


# miniconda
if [[ -f ~/miniconda3/etc/profile.d/conda.sh ]]; then
  source ~/miniconda3/etc/profile.d/conda.sh
fi
