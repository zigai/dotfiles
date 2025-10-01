set fish_greeting

function reload-profile
    source ~/.config/fish/config.fish
end

function mkcd
    mkdir -p $argv && cd $argv
end

function sysinfo
    if command -v inxi >/dev/null 2>&1
        inxi -Fxz $argv
    else
        uname -a
        if command -v lscpu >/dev/null 2>&1
            lscpu
        end
    end
end

function xd
    git add .
    git commit -m "update"
    git push
end

function tmxa
    tmux attach-session -t $argv
end

function fzf_history
    history merge
    set command (history | fzf --layout=reverse --height 40% --border)
    if test $status = 0
        commandline "$command"
    end
    commandline -f repaint
end


function ff
    set file (fzf --layout=reverse --cycle --border --preview-window=right,60%,border-left --height 50% --preview "bat --style=numbers --color=always --theme="Visual Studio Dark+" --line-range :300 {} 2>/dev/null || cat {} 2>/dev/null || echo \"Binary file\"")
    if test -n "$file"
        set ext (string lower (path extension "$file"))
        switch $ext
            case '.txt' '.md' '.json' '.yml' '.yaml' '.fish' '.sh' '.py' '.js' '.cpp' '.c' '.hx' '.ts'
                code $file
            case '.pdf'
                xdg-open $file
            case '*'
                xdg-open $file
        end
    end
end

set -gx FZF_DEFAULT_OPTS "\
    --color=hl:#f38ba8,fg:#cdd6f4,header:#f38ba8 \
    --color=info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc \
    --color=fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=border:#585b70 \
    --layout=reverse \
    --cycle \
    --scroll-off=5 \
    --border \
    --height 70%"

if command -v fzf >/dev/null 2>&1
    set -gx FZF_DEFAULT_OPTS "\
        --color=hl:red,fg:bright-white,header:red \
        --color=info:magenta,pointer:white,marker:white \
        --color=fg+:bright-white,prompt:magenta,hl+:red \
        --color=border:bright-black \
        --layout=reverse \
        --cycle \
        --scroll-off=5 \
        --border \
        --height 70%"
    
    set -gx FZF_COMPLETION_TRIGGER "'"
    
    if command -v fd >/dev/null 2>&1
        function _fzf_compgen_path
            fd --hidden --follow --exclude ".git" . $argv[1]
        end
        
        function _fzf_compgen_dir
            fd --type d --hidden --follow --exclude ".git" . $argv[1]
        end
    else
        function _fzf_compgen_path
            find . -not -path '*/.*' -not -path '*/.git/*' 2>/dev/null | sed 's|^\./||'
        end
        
        function _fzf_compgen_dir
            find . -type d -not -path '*/.*' 2>/dev/null | sed 's|^\./||'
        end
    end
    
    bind \ce ff
    fzf --fish | source
end

alias sudo='sudo '

if command -v duf >/dev/null 2>&1
   alias df="duf"
end

if command -v bat >/dev/null 2>&1
   alias cat='bat --paging=never --plain --theme="Visual Studio Dark+"'
end

function path
   echo $PATH | tr ':' '\n'
end

if command -v lsd >/dev/null 2>&1
   alias ls='lsd'
   alias l='lsd -a'
   alias a='lsd -la'
   alias la='lsd -a'
   alias ll='lsd -la'
   alias lt='lsd --tree'
   alias tree='lsd --tree'
else
   alias ls='ls --color=auto'
   alias l='ls -a --color=auto'
   alias a='ls -la --color=auto'
   alias la='ls -a --color=auto'
   alias ll='ls -la --color=auto'
   function lt
       tree $argv 2>/dev/null || find (test -n "$argv[1]"; and echo $argv[1]; or echo ".") -type d | head -20
   end
end

if command -v tokei >/dev/null 2>&1
    alias cloc="tokei -s lines"
end

if command -v btop >/dev/null 2>&1
    alias htop="btop"
end

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

function mkcd
   mkdir -p $argv[1] && cd $argv[1]
end

alias c='clear'
alias cl='clear'
alias cls='clear'

function md5
   md5sum $argv
end

function sha1
   sha1sum $argv
end

function sha256
   sha256sum $argv

end

function pip
   python3 -m pip $argv
end

function activate
    set -l envdir
    if test -d ".venv"
        set envdir ".venv"
    else if test -d "venv"
        set envdir "venv"
    else
        echo "No virtual environment found (.venv)"
        return 1
    end

    if test -f "$envdir/bin/activate.fish"
        source "$envdir/bin/activate.fish"
    else
        echo "Not found: $envdir/bin/activate.fish"
        return 1
    end
end

alias python="python3"
alias py="python3"
alias py3="python3"
alias ipy="ipython3"
alias myip="curl http://ipecho.net/plain; echo"
alias edit-bashrc="code ~/.bashrc"
alias edit-fish-config="code ~/.config/fish/config.fish"
alias tmxa="tmux attach-session -t"
alias gpustats="watch -n 1 nvidia-smi"
alias gc='git commit -m'
alias gp='git push'
alias ga='git add .'
alias pal='git pull'
alias gd='git diff'
alias gs='git status -sb'
alias gb='git checkout'
alias branch='git checkout'

begin
    set -l path_dirs \
        $HOME/.cargo/bin \
        $HOME/.local/bin \
        $HOME/projects/ubuntu-install/bin \
        $HOME/Bin/whisper.cpp/

    for dir in $path_dirs
        if test -d $dir
            fish_add_path $dir
        end
    end
end

fnm env --use-on-cd --shell fish | source

set OH_MY_POSH_CONFIGS \
    /home/zigai/Projects/dotfiles/config/ohmyposh.json \
    /mnt/c/Files/Projects/dotfiles/config/ohmyposh.json

if command -v oh-my-posh >/dev/null 2>&1
    for config_path in $OH_MY_POSH_CONFIGS
        if test -f "$config_path"
            oh-my-posh init fish --config "$config_path" | source
            break
        end
    end
end

bind -e \cr
bind \cr fzf_history
