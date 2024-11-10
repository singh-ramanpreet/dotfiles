# ========================================
#| description     : bash profile         |
#| author          : Ramanpreet Singh     |
# ========================================


# Source local definitions
if [[ -f ~/.bashrc ]]; then
  . ~/.bashrc
fi

# create the socket file on the host with keys
# example:
#   nc -U $HOME/.ssh/ssh_auth_sock -l -k &
#   kill -9 $(lsof -t -U $HOME/.ssh/ssh_auth_sock)

# check if socket file exists
# if it does, find the running ssh-agent and
# set the socket to the one in the file
# if it doesn't, start a new ssh-agent and
# clean up old sockets
if [[ -S $HOME/.ssh/ssh_auth_sock ]]; then
  if [[ "$(ps -u $USER | grep ssh-agent | wc -l)" -lt "1" ]] then
    find /tmp -maxdepth 1 -type d -name "ssh-*" -exec rm -rv {} \;
    eval $(ssh-agent -s)
    ln -sf "$SSH_AUTH_SOCK" $HOME/.ssh/ssh_auth_sock
  fi
  export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
fi

# if keys present, add them
if [[ -f $HOME/.ssh/id_rsa.pub ]]; then
  ssh-add -l >/dev/null || ssh-add $HOME/.ssh/id_rsa
fi
if [[ -f $HOME/.ssh/id_ed25519.pub ]]; then
  ssh-add -l >/dev/null || ssh-add $HOME/.ssh/id_ed25519
fi
