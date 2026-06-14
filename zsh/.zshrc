# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Vars
export PATH=$PATH:$HOME/.spicetify
export MANGOHUD=1
export MANGOHUD_DLSYM=1
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"

export PATH=$PATH:/home/kosse/.spicetify
export pcmac="9C:6B:00:B9:5C:82"

# Add POSH catppuccin theme
eval "$(oh-my-posh init zsh --config ~/.catppuccin_mocha.omp.json)"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light MichaelAquilina/zsh-you-should-use

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::command-not-found
zinit snippet OMZP::dirhistory

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=1000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Proxy toggle (127.0.0.1:2080)
proxyon() {
  export http_proxy="http://127.0.0.1:2080"
  export https_proxy="http://127.0.0.1:2080"
  export ftp_proxy="http://127.0.0.1:2080"
  export no_proxy="localhost,127.0.0.1"
  export HTTP_PROXY="$http_proxy"
  export HTTPS_PROXY="$https_proxy"
  export FTP_PROXY="$ftp_proxy"
  export NO_PROXY="$no_proxy"
}

proxyoff() {
  unset http_proxy https_proxy ftp_proxy no_proxy
  unset HTTP_PROXY HTTPS_PROXY FTP_PROXY NO_PROXY
}

proxystatus() {
  if [[ -n "${http_proxy:-}${HTTP_PROXY:-}" ]]; then
    echo "proxy: ON  (http_proxy=${http_proxy:-$HTTP_PROXY})"
  else
    echo "proxy: OFF"
  fi
}

# Aliases

# Stats
alias f="hyfetch"
alias age="stat / | grep Birth"
alias ram="cd ~/.config/fastfetch; chmod +x ./ram_modules.sh; sudo ./ram_modules.sh; cd"
alias myip="curl ipinfo.io"
alias wakeup="wakeonlan $pcmac"
alias sleepoff='sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target'
alias sleepon='sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target'
# DNF
alias up="sudo dnf upgrade --refresh --best --allowerasing -y && flatpak update -y && brew update && brew upgrade"
alias cc="sudo dnf autoremove && sudo dnf clean all && flatpak uninstall --unused -y && flatpak remove --delete-data && trash-empty && sudo journalctl --vacuum-time=1weeks && rm -rf ~/Downloads/* && rm -rf ~/Pictures/Screenshots/*"
alias c="clear"
alias dnfi="sudo dnf install"
alias dnfr="sudo dnf remove"
alias dnfs="dnf search"
# Homebrew
alias bi="brew install"
alias br="brew remove"
alias bup="brew upgrade"
alias bs="brew search"
alias bl="brew list"
# Dir utils
alias ls="lsd"
alias ll="lsd -1"
alias lla="lsd -1a"
alias lsa="lsd -a"
alias l="lsd --date '+%d.%m.%Y %H:%M' -lah"
alias cp="rsync -ah --info=progress2"
alias mv="mv -v"
alias rm="rm -v"
alias rd="rm -rf"
alias srd="sudo rm -rf"
alias untar="tar -zxvf"
alias cpwd="pwd && pwd | xclip -selection clipboard"
# Flatpak
alias fl="flatpak"
alias fli="flatpak install --noninteractive -y flathub"
alias flr="flatpak remove --noninteractive -y"
alias fll="flatpak list"
alias fls="flatpak search"
# Text Editor
alias gte="gnome-text-editor"
alias vi="nvim"
#alias vim="sudo nvim"
#alias vi="sudo nvim"
#alias v="sudo nvim"
# Other
alias lg="lazygit"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Yazi move to dir on exit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Alias to start nvm because it slows startup
# export NVM_DIR="$HOME/.nvm"
# alias NVM='[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
alias SDK='[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"'


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
