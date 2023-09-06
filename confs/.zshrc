# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"
#ZSH_THEME="robbyrussell"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

function charging_current() {
    state=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/state/ {print $2}')
    value=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E 'energy-rate|current' | awk '{print $2}')
    unit=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E 'energy-rate|current' | awk '{print $3}')

    if [[ $state == "charging" ]]; then
        sign="+"
    elif [[ $state == "fully-charged" ]]; then
        sign=""
        value="full"
    else
        sign="-"
    fi

    printf "%s%.1f %s\n" "$sign" "$value" "$unit"
}

function faha_uuid() {
  python -c "import uuid; print(uuid.uuid5(uuid.NAMESPACE_URL, 'constant://faha/database/'+'$1'))"
}

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  kube-ps1
)

#git clone git://github.com/gradle/gradle-completion ~/.zsh/gradle-completion
fpath=(/home/w/.zsh/gradle-completion $fpath)
#git clone https://github.com/esc/conda-zsh-completion ~/.zsh/conda-zsh-completion

fpath+=$HOME/.zsh/conda-zsh-completion

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias co="git checkout"
function disable_touchpad() {
	xinput --disable `xinput | grep "Synaptics TouchPad" | cut -d '=' -f2 | cut -f1`
}

function disable_touchscreen() {
	xinput --disable `xinput | grep "Wacom Pen and multitouch sensor Finger" | cut -d '=' -f2 | cut -f1`
}

function mkcddir() {
	mkdir -p $1
	cd $1
}

alias tmux="tmux -u"
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export PATH=/$HOME/bin:$PATH
export PATH=/$HOME/miniconda3/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
alias gitroot='cd "$(git rev-parse --show-cdup)"'

alias lint="./bark.sh --stage lint"
[[ /snap/bin/kubectl ]] && source <(kubectl completion zsh)

source $HOME/.profile



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/w/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/w/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/w/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/w/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/bin/aws_completer' aws

#export PYENV_ROOT="$HOME/.pyenv"
#command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"


# fnm
export PATH="/home/w/.local/share/fnm:$PATH"
eval "`fnm env`"

PROMPT='$(charging_current)|'${PROMPT}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
