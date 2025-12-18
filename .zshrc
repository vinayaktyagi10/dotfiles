# ~/.zshrc - Optimized for DevOps Development

export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:$HOME/.local/bin:$HOME/.cargo/bin
export EDITOR=nvim
export TERM=kitty
# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Pyenv virtualenv
eval "$(pyenv virtualenv-init -)"

# Load Powerlevel10k instant prompt
[[ -f ~/.cache/wal/colors.sh ]] && source ~/.cache/wal/colors.sh

# Theme - using simple prompt with git info
ZSH_THEME=""
export PS1='[%n@%m %1~]$ '

# Oh My Zsh plugins
plugins=(
    git
    sudo
    zsh-autosuggestions
    zsh-syntax-highlighting
    colored-man-pages
    extract
    docker
    tmux
)

source $ZSH/oh-my-zsh.sh

# Editor settings
export EDITOR='nvim'
export VISUAL='nvim'

# ============================================================================
# DEVOPS & GIT ALIASES
# ============================================================================

# Git shortcuts
alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gb='git branch'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gl='git log --oneline -15'
alias gc='git commit -m'
alias gca='git commit --amend'
alias greset='git reset --hard HEAD'
# Note: gcb is defined as a function below, not as an alias

# Docker shortcuts
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drun='docker run'
alias dexec='docker exec -it'
alias dlogs='docker logs -f'
alias dcomp='docker-compose'
alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dclogs='docker-compose logs -f'

# Kubernetes shortcuts (if needed)
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgn='kubectl get nodes'
alias kdesc='kubectl describe'

# System shortcuts
alias ll='exa -lah'
alias la='exa -la'
alias l='exa -l'
alias ls='exa'
alias cat='bat'
alias grep='grep --color=auto'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ============================================================================
# TMUX INTEGRATION
# ============================================================================

# Auto-start tmux on shell login (optional)
if [ -z "$TMUX" ]; then
    if tmux has-session -t main 2>/dev/null; then
        exec tmux attach -t main
    fi
fi

# Quick tmux sessions
alias tm='tmux new-session -s'
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'



# DevLog venv activation
alias devlog='/home/tyagi/projects/DevLog/.venv/bin/devlog'

# virtualenvwrapper
alias virt-manager='PYENV_VERSION=system virt-manager'

# ============================================================================
# FUNCTIONS
# ============================================================================

# Create and navigate to directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Docker quick bash
dsh() {
    docker exec -it "$1" /bin/bash
}

# Docker quick logs with tail
dlf() {
    docker logs -f --tail 50 "$1"
}

# List all running services
services() {
    systemctl list-units --type=service --state=running
}

# Quick directory size
dsize() {
    du -sh "${1:-.}" | sort -h
}

# ============================================================================
# FZF INTEGRATION (if installed)
# ============================================================================

if command -v fzf &> /dev/null; then
    source <(fzf --zsh)

    # Ctrl+R for history search with fzf
    bindkey -r '^R'
    bindkey '^R' 'fzf-history-widget'
fi

# ============================================================================
# DIRENV (optional - for environment management)
# ============================================================================

if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# ============================================================================
# COMPLETION & PERFORMANCE
# ============================================================================

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
    compinit
else
    compinit -C
fi

# Faster completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''

# ============================================================================
# SSH AGENT
# ============================================================================

# Auto-start SSH agent
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
fi

# Auto-add your key on startup
ssh-add ~/.ssh/id_ed25519 2>/dev/null
export PATH="$HOME/.local/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/ricing/.lmstudio/bin"
# End of LM Studio CLI section


export PATH=$PATH:/home/ricing/.spicetify

alias ls="ls --color=auto"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


alias ls="eza --icons"
alias ll="eza -lah --icons"
alias grep="rg"
export PATH="$HOME/.npm-global/bin:$PATH"
