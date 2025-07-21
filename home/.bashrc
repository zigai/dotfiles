# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=2000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
    *)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# https://gist.github.com/zachbrowne/8bc414c9f30192067831fafebd14255c
# Extracts any archive(s) (if unp isn't installed)
extract () {
    for archive in $*; do
        if [ -f $archive ] ; then
            case $archive in
                *.tar.bz2)   tar xvjf $archive    ;;
                *.tar.gz)    tar xvzf $archive    ;;
                *.bz2)       bunzip2 $archive     ;;
                *.rar)       rar x $archive       ;;
                *.gz)        gunzip $archive      ;;
                *.tar)       tar xvf $archive     ;;
                *.tbz2)      tar xvjf $archive    ;;
                *.tgz)       tar xvzf $archive    ;;
                *.zip)       unzip $archive       ;;
                *.Z)         uncompress $archive  ;;
                *.7z)        7z x $archive        ;;
                *)           echo "Can't extract '$archive'..." ;;
            esac
        else
            echo "'$archive' is not a valid file!"
        fi
    done
}

alias sudo='sudo '

if command -v duf &> /dev/null; then
    alias df="duf"
fi

if command -v batcat &> /dev/null; then
    alias cat='batcat --paging=never --plain --theme="Visual Studio Dark+"'
fi

path() {
    echo "$PATH" | tr ':' '\n'
}

if command -v lsd &> /dev/null; then
    alias ls='lsd'
    alias l='lsd -a'
    alias a='lsd -la'
    alias la='lsd -a'
    alias ll='lsd -la'
    alias lt='lsd --tree'
else
    alias ls='ls --color=auto'
    alias l='ls -a --color=auto'
    alias a='ls -la --color=auto'
    alias la='ls -a --color=auto'
    alias ll='ls -la --color=auto'
    lt() { tree "$@" 2>/dev/null || find "${1:-.}" -type d | head -20; }
fi

alias h="cd ~"
alias home="cd ~"
alias d="cd /mnt/d"
alias e="cd /mnt/e"
alias dw="cd ~/Downloads"
alias p="cd ~/Projects"
alias repos="cd ~/Repos"
alias ..="cd .."
alias ...="cd .. && cd .."
alias cd..="cd .."
mkcd() { mkdir -p "$1" && cd "$1"; }

alias c='clear'
alias cl='clear'
alias cls='clear'

md5() { md5sum "$@"; }
sha1() { sha1sum "$@"; }
sha256() { sha256sum "$@"; }

pip() { python -m pip "$@"; }
alias python="python3"
alias py="python3"
alias py3="python3"
alias ipy="ipython3"

alias myip="curl http://ipecho.net/plain; echo"
alias edit-bashrc="code ~/.bashrc"
alias edit-fishrc="code ~/.config/fish/config.fish"
alias tmxa="tmux attach-session -t $1"
alias gpustats="watch -n 1 nvidia-smi"
alias sysinfo="inxi -Fxz"

alias gc='git commit -m'
alias gp='git push'
alias ga='git add .'
alias pal='git pull'
alias gd='git diff'
alias gs='git status -sb'
alias gb='git checkout'
alias branch='git checkout'

xd() {
    git add .
    git commit -m "update"
    git push
}

ff() {
    if ! command -v fzf &> /dev/null; then
        echo "fzf not installed"
        return 1
    fi
    
    local file=$(fzf --layout=reverse --cycle --border --preview-window=right,60%,border-left --height 50% --preview 'batcat --style=numbers --color=always --line-range :300 {} 2>/dev/null || cat {} 2>/dev/null || echo "Binary file"')
    
    if [ -n "$file" ]; then
        local extension="${file##*.}"
        case "$extension" in
            txt|md|json|yml|yaml|sh|py|js|cpp|c|ts|rs|go)
                $EDITOR "$file"
                ;;
            pdf)
                if command -v evince &> /dev/null; then
                    evince "$file" &
                elif command -v okular &> /dev/null; then
                    okular "$file" &
                else
                    xdg-open "$file" 2>/dev/null || open "$file" 2>/dev/null
                fi
                ;;
            *)
                xdg-open "$file" 2>/dev/null || open "$file" 2>/dev/null
                ;;
        esac
    fi
}

if command -v fzf &> /dev/null; then
    export FZF_DEFAULT_OPTS="
        --color=hl:red,fg:bright-white,header:red
        --color=info:magenta,pointer:white,marker:white
        --color=fg+:bright-white,prompt:magenta,hl+:red
        --color=border:bright-black
        --layout=reverse
        --cycle
        --scroll-off=5
        --border
        --height 70%
        --preview-window=right,60%,border-left
        --preview 'batcat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {} 2>/dev/null || echo \"Binary file\"'
    "

    export FZF_COMPLETION_TRIGGER="'" 
    
    if command -v fd &> /dev/null; then
        _fzf_compgen_path() {
            fd --hidden --follow --exclude ".git" . "$1"
        }
        _fzf_compgen_dir() {
            fd --type d --hidden --follow --exclude ".git" . "$1"
        }
    else
        _fzf_compgen_path() {
            find .  -not -path '*/.*' -not -path '*/.git/*' 2>/dev/null | sed 's|^\./||'
        }
        _fzf_compgen_dir() {
            find . -type d -not -path '*/.*' 2>/dev/null | sed 's|^\./||'
        }
    fi
    
    bind -x '"\C-e": ff'
    
    eval "$(fzf --bash)"

    _fzf_setup_completion path cat less more head tail bat vim nvim nano emacs code subl mv cp ln git python python3 node mpv
    _fzf_setup_completion dir cd pushd rmdir tree git cloc tokei
fi


activate() {
    if [ -d ".venv" ]; then
        source .venv/bin/activate
    elif [ -d "venv" ]; then
        source venv/bin/activate
    else
        echo "No virtual environment found (.venv or venv directory)"
    fi
}

export PATH="$HOME/.cargo/bin:$PATH"
LS_COLORS=$LS_COLORS:'ow=1;34:' ; export LS_COLORS

OH_MY_POSH_CONFIGS=(
    /home/zigai/Projects/dotfiles/config/ohmyposh.json
    /mnt/c/Files/Projects/dotfiles/config/ohmyposh.json
)
if command -v oh-my-posh >/dev/null 2>&1; then
    for config_path in "${OH_MY_POSH_CONFIGS[@]}"; do
        if [[ -f "$config_path" ]]; then
            eval "$(oh-my-posh init bash --config "$config_path")"
            break
        fi
    done
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
