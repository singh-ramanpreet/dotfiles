# ========================================
#| description     : bash profile         |
#| author          : Ramanpreet Singh     |
# ========================================


# Source local definitions
if [[ -f ~/.bashrc ]]; then
  . ~/.bashrc
fi

# Note: Create $HOME/.ssh/ssh_auth_sock as symlink
#       to any file on the host with keys.
SSH_AUTH_TESTFILE=$HOME/.ssh/ssh_auth_sock


# Function to start ssh-agent and create socket
_start_ssh_agent() {
  # kill old ssh-agent
  killall -q ssh-agent
  # remove old symlink
  rm $SSH_AUTH_TESTFILE
  # start new ssh-agent
  eval $(ssh-agent -s)
  # create symlink to home socket
  ln -sf "$SSH_AUTH_SOCK" $SSH_AUTH_TESTFILE
}


# Check if socket file exists and manage ssh-agent
if [[ -S $SSH_AUTH_TESTFILE ]]; then
  export SSH_AUTH_SOCK=$SSH_AUTH_TESTFILE
  export SSH_AGENT_PID=$(readlink -f $SSH_AUTH_SOCK | cut -d. -f2)
else
  _start_ssh_agent
fi
# add keys to ssh-agent
ssh-add -l > /dev/null || ssh-add
