# ========================================
#| description     : bash profile         |
#| author          : Ramanpreet Singh     |
# ========================================


# Source local definitions
if [[ -f ~/.bashrc ]]; then
  . ~/.bashrc
fi

# ssh agent
# clean up old sockets 
# start ssh-agent if not running
if [[ "$(ps -u $USER | grep ssh-agent | wc -l)" -lt "1" || ! -S $HOME/.ssh/ssh_auth_sock ]]; then
  find /tmp -maxdepth 1 -type d -name "ssh-*" -exec rm -rv {} \;
  eval $(ssh-agent -s)
  ln -sf "$SSH_AUTH_SOCK" $HOME/.ssh/ssh_auth_sock
fi

# set the socket
export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock

# if keys present, add them
if [[ -f $HOME/.ssh/id_rsa.pub ]]; then
  ssh-add -l >/dev/null || ssh-add $HOME/.ssh/id_rsa
fi
if [[ -f $HOME/.ssh/id_ed25519.pub ]]; then
  ssh-add -l >/dev/null || ssh-add $HOME/.ssh/id_ed25519
fi
