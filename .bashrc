# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions


# Git aliases
alias gitrebase='git rebase --interactive @{u}'
alias gitreset='git fetch origin -p && git reset --hard @{u} && git clean -xfd'

# This command is used ALOT both below and in daily life
alias k='kubectl'

# Apply a YML file
alias kaf='k apply -f'
alias kdf='k delete -f'

# Drop into an interactive terminal on a container
alias keti='k exec -ti'

# Manage configuration quickly to switch contexts between local, dev ad staging.
alias kcgc='k config get-contexts'
alias kcuc='k config use-context'
alias kcsc='k config set-context'
alias kcdc='k config delete-context'
alias kccc='k config current-context'
alias kgn='k get namespaces'

# Pod management.
alias kgp='k get pods'
alias kep='k edit pods'
alias kdp='k describe pods'
alias kdelp='k delete pods'

# Service management.
alias kgs='k get svc'
alias kes='k edit svc'
alias kds='k describe svc'
alias kdels='k delete svc'

# Ingress management
alias kgi='k get ingress'
alias kei='k edit ingress'
alias kdi='k describe ingress'
alias kdeli='k delete ingress'

# Secret management
alias kgsec='k get secret'
alias kdsec='k describe secret'
alias kdelsec='k delete secret'

# Deployment management.
alias kgd='k get deployment'
alias ked='k edit deployment'
alias kdd='k describe deployment'
alias kdeld='k delete deployment'
alias ksd='k scale deployment'
alias krsd='k rollout status deployment'

# Rollout management.
alias kgrs='k get rs'
alias krh='k rollout history'
alias kru='k rollout undo'

# Logs
alias kl='k logs'

# Terraform aliases
alias tfi='export http_proxy=http://172.25.49.99:3128; export https_proxy=http://172.25.49.99:3128; export no_proxy=*.googleapis.com; terraform init; unset http_proxy; unset https_proxy; unset no_proxy'
alias tfv='terraform validate'
alias tfp='terraform plan'
alias tfa='terraform apply -auto-approve'
alias tfws='terraform workspace select'
alias tff='terraform fmt -recursive'
alias tfo='terraform output'

alias dockerclean='docker kill $(docker ps -q) || true && docker rm $(docker ps -a -q) || true && docker rmi $(docker images -q -f dangling=true)'
alias dockercleanall='docker kill $(docker ps -q) || true && docker rm $(docker ps -a -q) || true && docker rmi $(docker images -q)'
alias dockerkillall='docker kill $(docker ps -q) || true && docker rm $(docker ps -a -q) || true'

#alias ping='prettyping --nolegend'
#alias man='tldr'

export PATH=$PATH:$HOME/.dotnet/tools

export DOCKER_HOST=tcp://localhost:2375
export KUBECONFIG=$HOME/.kube/config

if [ -d $USERPROFILE/scoop/apps/ssh-agent-wsl/2.5 ]; then
  eval $($USERPROFILE/scoop/apps/ssh-agent-wsl/2.5/ssh-agent-wsl -r)
fi

function _update_ps1() {
    eval "$(/usr/local/bin/powerline-go -error $? -shell bash -eval -colorize-hostname -newline -modules-right kube)"
}

if [ "$TERM" != "linux" ] && [ -f "/usr/local/bin/powerline-go" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

alias enable-proxy='export http_proxy=http://172.25.49.99:3128; export https_proxy=http://172.25.49.99:3128; export no_proxy=*.googleapis.com'
alias disable-proxy='unset http_proxy; unset https_proxy; unset no_proxy'