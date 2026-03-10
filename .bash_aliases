# ~/.bash_aliases — shared aliases, sourced by .bashrc / .zshrc
# Managed as a symlink from ~/software/dotfiles — edit there, not here.

# --- Navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# --- Listing ---
alias la='ls -laht'
alias ll='ls -lh'
alias l='ls -CF'

# --- Safety nets ---
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# --- Disk / memory ---
alias df='df -h'
alias du='du -h --max-depth=1'
alias free='free -h'

# --- Grep with colour ---
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# --- Git shortcuts ---
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# --- Process / network ---
alias j='jobs -l'
alias ports='ss -tulanp'
alias myip='curl -s ifconfig.me && echo'

# --- Misc ---
alias h='history'
alias path='echo "$PATH" | tr ":" "\n"'
alias reload='source ~/.bashrc'
alias mkd='mkdir -p'
alias which='type -a'
