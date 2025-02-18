#
# .zshrc
#
# @author Jeff Geerling & Adrian Mace
#

# Colors.
unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Don't require escaping globbing characters in zsh.
unsetopt nomatch

# Nicer prompt.
export PS1=$'\n'"%F{green} %*%F %F{grey}%3~ %F{white}"$'\n'"$ "

# Enable plugins.
plugins=(git brew history kubectl zsh-autosuggestions zsh-completions zsh-syntax-highlighting history-substring-search)

# Find architecture-specific brew path(s)
if type brew &>/dev/null; then
    brew_dir="$(brew --prefix)"
    share_path="$brew_dir/share"
fi

# Custom $PATH with extra locations.
export PATH="$HOME/Library/Python/3.8/bin:$brew_dir/bin:/usr/local/sbin:$HOME/bin:$HOME/go/bin:/usr/local/git/bin:$brew_dir/opt/gnu-sed/libexec/gnubin:$PATH"

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# Include alias file (if present) containing aliases for ssh, etc.
if [ -f ~/.aliases ]
then
  source ~/.aliases
fi

# Allow history search via up/down keys.
source ${share_path}/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Git aliases.
alias gs='git status'
alias gc='git commit'
alias gp='git pull --rebase'
alias gcam='git commit -am'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Initiate zsh-completions
export FPATH="$brew_dir/share/zsh-completions:$FPATH"

# Initiate zsh-autosuggestions
source "$brew_dir/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Initiate zsh-syntax-highlighting
source "$brew_dir/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Completions.
autoload -Uz compinit && compinit
# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Enter a running Docker container.
function denter() {
 if [[ ! "$1" ]] ; then
     echo "You must supply a container ID or name."
     return 0
 fi

 docker exec -it $1 bash
 return 0
}

# Smarter git clone function (for HTTPS URLs only)
function clone () {
    sanitised="$(echo $1 | cut -d '/' -f-5)"
    folder="$(echo $sanitised | cut -d '/' -f 4)"
    repo="$(echo $sanitised | cut -d '/' -f 5)"
    mkdir -p "$HOME/Code/$folder" && cd "$HOME/Code/$folder"
    git clone "$sanitised" 2> /dev/null
    cd "~/Code/$folder/$repo"
    git checkout "$([ -f .git/refs/heads/main ] && echo main || echo master)"
    git pull
}

# Initiate fzf
if [[ ! "$PATH" == "*$brew_dir/opt/fzf/bin*" ]]; then
  export PATH="${PATH:+${PATH}:}$brew_dir/opt/fzf/bin"
fi
[[ $- == *i* ]] && source "$brew_dir/opt/fzf/shell/completion.zsh" 2> /dev/null
source "$brew_dir/opt/fzf/shell/key-bindings.zsh"

# Initiate zoxide
eval "$(zoxide init zsh)"
