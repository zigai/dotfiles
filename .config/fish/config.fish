if status is-interactive
    # Commands to run in interactive sessions can go here
end
set fish_greeting ""



set -g theme_color_scheme terminal-dark

alias sudo 'sudo '

alias cd.. "cd .."
alias cd. "pwd"
alias h "cd ~"
alias home "cd ~"
alias d "cd /mnt/d"
alias e "cd /mnt/e"
alias dw "cd ~/Downloads"

alias ls 'lsd'
alias l 'ls -a'
alias la 'ls -a'
alias a 'ls -la'
alias ll "ls -la"
alias lt 'ls --tree'

alias c "clear"
alias cl "clear"
alias cls "clear"

alias python "python3"
alias py "python3"
alias py3 "python3"
alias ipy "ipython3"

alias gp "git push"
alias ga "git add ."
alias gpl "git pull"
alias gs "git status -sb"
alias gc "git commit"
alias checkout "git checkout"

alias pir "pip install -r ./requirements.txt"
alias prq "pipreqs . --force"

alias myip "curl http://ipecho.net/plain; echo"
alias ai "sudo apt install $1"
alias bashrc "nvim ~/.bashrc"
alias cat 'batcat --paging=never --plain'
alias df "df -h"
alias ex "extract"
alias tmxa "tmux attach-session -t $1"