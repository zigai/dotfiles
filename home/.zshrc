
[[ -o interactive ]] || return


# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=2000000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_GLOB
setopt AUTO_CD
unsetopt BG_NICE

# less + term sizing
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# debian chroot marker (used in prompt/title)
if [[ -z "${debian_chroot:-}" && -r /etc/debian_chroot ]]; then
  debian_chroot="$(< /etc/debian_chroot)"
fi

autoload -Uz colors && colors
setopt PROMPT_SUBST

PROMPT='${debian_chroot:+($debian_chroot)}%F{green}%n@%m%f:%F{blue}%~%f$ '
RPROMPT=''

# set terminal title on supported terms
function _set_title_precmd() {
  case "$TERM" in
    xterm*|rxvt*|screen*|tmux*)
      print -Pn "\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a"
      ;;
  esac
}
function _set_title_preexec() {
  case "$TERM" in
    xterm*|rxvt*|screen*|tmux*)
      print -Pn "\e]0;${debian_chroot:+($debian_chroot)}%n@%m: $1\a"
      ;;
  esac
}
precmd_functions+=(_set_title_precmd)
preexec_functions+=(_set_title_preexec)

if command -v dircolors >/dev/null 2>&1; then
  if [[ -r ~/.dircolors ]]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


# “alert” helper
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e "s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//")"'

# source extra aliases
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
# [[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

# completion (zsh)
autoload -Uz compinit
compinit -u
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zmodload zsh/complist

extract() {
  for archive in "$@"; do
    if [[ -f "$archive" ]]; then
      case "$archive" in
        *.tar.bz2)   tar xvjf "$archive"   ;;
        *.tar.gz)    tar xvzf "$archive"   ;;
        *.bz2)       bunzip2 "$archive"    ;;
        *.rar)       rar x "$archive"      ;;
        *.gz)        gunzip "$archive"     ;;
        *.tar)       tar xvf "$archive"    ;;
        *.tbz2)      tar xvjf "$archive"   ;;
        *.tgz)       tar xvzf "$archive"   ;;
        *.zip)       unzip "$archive"      ;;
        *.Z)         uncompress "$archive" ;;
        *.7z)        7z x "$archive"       ;;
        *)           echo "Can't extract '$archive'..." ;;
      esac
    else
      echo "'$archive' is not a valid file!"
    fi
  done
}

sysinfo() {
  if command -v inxi &>/dev/null; then
    inxi -Fxz "$@"
  else
    uname -a
    lscpu 2>/dev/null || true
  fi
}

export LS_COLORS="${LS_COLORS}:ow=1;34:"

alias sudo='sudo ' # allow alias after sudo
if command -v duf &>/dev/null; then alias df='duf'; fi
if command -v bat &>/dev/null; then alias cat='bat --paging=never --plain --theme="Visual Studio Dark+"'; fi
if command -v tokei &>/dev/null; then alias cloc='tokei -s lines'; fi

path() { print -l $path }

if command -v lsd &>/dev/null; then
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
  lt() { command -v tree &>/dev/null && tree "$@" || find "${1:-.}" -type d 2>/dev/null | head -20 }
fi

alias h='cd ~'
alias home='cd ~'
alias d='cd /mnt/d'
alias e='cd /mnt/e'
alias dw='cd ~/Downloads'
alias p='cd ~/Projects'
alias repos='cd ~/Repos'
alias ..='cd ..'
alias ...='cd ../..'
alias cd..='cd ..'
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

alias c='clear'
alias cl='clear'
alias cls='clear'

md5() { md5sum "$@"; }
sha1() { sha1sum "$@"; }
sha256() { sha256sum "$@"; }

pip() { python3 -m pip "$@"; }
alias python='python3'
alias py='python3'
alias py3='python3'
alias ipy='ipython3'

alias myip='curl http://ipecho.net/plain; echo'
alias edit-bashrc='code ~/.bashrc'
alias edit-fishrc='code ~/.config/fish/config.fish'
alias tmxa='tmux attach-session -t $1'
alias gpustats='watch -n 1 nvidia-smi'

if command -v btop &>/dev/null; then alias htop='btop'; fi

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


if command -v fzf &>/dev/null; then
  export FZF_DEFAULT_OPTS=$'
    --color=hl:red,fg:bright-white,header:red
    --color=info:magenta,pointer:white,marker:white
    --color=fg+:bright-white,prompt:magenta,hl+:red
    --color=border:bright-black
    --layout=reverse
    --cycle
    --scroll-off=5
    --border
    --height 70%
  '
  export FZF_CTRL_R_OPTS=$'
    --layout=reverse
    --height=40%
    --border
    --preview-window=hidden
  '
  export FZF_COMPLETION_TRIGGER="'"

  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  else
    export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/.git/*" -not -path "*/.*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='find . -type d -not -path "*/.git/*" -not -path "*/.*"'
  fi

  eval "$(fzf --zsh)"

  ff() {
    command -v fzf &>/dev/null || { echo "fzf not installed"; return 1; }
    local file
    file="$(eval "$FZF_DEFAULT_COMMAND" | fzf --preview 'bat --style=numbers --color=always --theme="Visual Studio Dark+" --line-range :300 {} 2>/dev/null || cat {} 2>/dev/null || echo "Binary file"' \
                    --preview-window=right,60%,border-left --layout=reverse --cycle --border --height 50%)" || return
    [[ -z "$file" ]] && return
    local extension="${file##*.}"
    case "$extension" in
      txt|md|json|yml|yaml|sh|py|js|cpp|c|ts|rs|go) ${EDITOR:-vi} "$file" ;;
      pdf)
        if command -v evince &>/dev/null; then nohup evince "$file" >/dev/null 2>&1 &
        elif command -v okular &>/dev/null; then nohup okular "$file" >/dev/null 2>&1 &
        else xdg-open "$file" 2>/dev/null || open "$file" 2>/dev/null; fi
        ;;
      *) xdg-open "$file" 2>/dev/null || open "$file" 2>/dev/null ;;
    esac
  }
  zle -N ff-widget ff
  for map in emacs viins vicmd; do bindkey -M $map '^E' ff-widget; done
fi

activate() {
  if [[ -d ".venv" ]]; then
    source .venv/bin/activate
  elif [[ -d "venv" ]]; then
    source venv/bin/activate
  else
    echo "No virtual environment found (.venv or venv directory)"
  fi
}

typeset -a PREPEND_PATH_DIRS=(
  "$HOME/.cargo/bin"
  "$HOME/.local/bin"
  "$HOME/Programs/llama.cpp"
  "$HOME/Programs/whisper.cpp"
)

typeset -a APPEND_PATH_DIRS=(
  "$HOME/.local/share/flatpak/exports/bin"
  "/var/lib/flatpak/exports/bin"
)

for dir in "${PREPEND_PATH_DIRS[@]}"; do
  [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]] && PATH="$dir:$PATH"
done

for dir in "${APPEND_PATH_DIRS[@]}"; do
  [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]] && PATH="$PATH:$dir"
done

export PATH

typeset -a OH_MY_POSH_CONFIGS=(
  /home/zigai/Projects/dotfiles/config/ohmyposh.json
  /mnt/c/Files/Projects/dotfiles/config/ohmyposh.json
)
if command -v oh-my-posh >/dev/null 2>&1; then
  for config_path in "${OH_MY_POSH_CONFIGS[@]}"; do
    if [[ -f "$config_path" ]]; then
      eval "$(oh-my-posh init zsh --config "$config_path")"
      break
    fi
  done
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 2>/dev/null
eval "$(fnm env --use-on-cd --shell zsh)" 2>/dev/null

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


if [[ -r "$HOME/.deno/env" ]]; then
  source "$HOME/.deno/env"
fi
if [[ $- == *i* ]] && command -v deno >/dev/null 2>&1; then
  if [[ -r "$HOME/.local/share/zsh/site-functions/_deno" ]]; then
    fpath=("$HOME/.local/share/zsh/site-functions" $fpath)
    autoload -Uz _deno
    compdef _deno deno
  else
    eval "$(deno completions zsh)"
  fi
fi

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh

ZSH_HIGHLIGHT_MAXLENGTH=2000

_zp_safe_paste() {
  local -a _old_hl=("${ZSH_HIGHLIGHT_HIGHLIGHTERS[@]}")
  local _old_ml="${ZSH_HIGHLIGHT_MAXLENGTH-}"

  ZSH_HIGHLIGHT_HIGHLIGHTERS=()
  ZSH_HIGHLIGHT_MAXLENGTH=0
  zle autosuggest-disable 2>/dev/null || true

  zle .bracketed-paste  

  zle autosuggest-enable 2>/dev/null || true
  ZSH_HIGHLIGHT_HIGHLIGHTERS=("${_old_hl[@]}")
  ZSH_HIGHLIGHT_MAXLENGTH="$_old_ml"
}
zle -N bracketed-paste _zp_safe_paste


# fzf-tab config
zstyle ':completion:*:git-checkout:*' sort false 
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview '{
  command -v lsd >/dev/null && exec lsd -1 --color=always $realpath
  exec ls -la $realpath
}'
# fzf-tab flags (plugin ignores FZF_DEFAULT_OPTS unless told)
zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept
# switch groups with < and >
zstyle ':fzf-tab:*' switch-group '<' '>'
# if command -v ftb-tmux-popup >/dev/null; then
#   zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# fi

bindkey -e
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# visible region
typeset -ga zle_highlight
zle_highlight+=(region:standout)

bindkey '^[[1;5D' backward-word # ctrl + left
bindkey '^[[1;5C' forward-word  # ctrl + right
