# ========================================
#| description     : bash profile         |
#| author          : Ramanpreet Singh     |
# ========================================


# Source local definitions
if [[ -f ~/.bashrc ]]; then
  . ~/.bashrc
fi

# ssh agent
if [[ "$(ps -u $USER | grep ssh-agent | wc -l)" -lt "1" || ! -S $HOME/.ssh/ssh_auth_sock ]]; then
  find /tmp -maxdepth 1 -type d -name "ssh-*" -exec rm -rv {} \;
  eval $(ssh-agent -s)
  ln -sf "$SSH_AUTH_SOCK" $HOME/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
ssh-add -l >/dev/null || ssh-add $(ls $HOME/.ssh/*.pub | sed 's/.pub//')
