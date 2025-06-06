# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"


plugins=(
  git
  kube-ps1
  kubectx
  python
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"


export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export PATH=/$HOME/Android/Sdk/platform-tools:$PATH
export PATH=/$HOME/bin:$PATH
export PATH=/$HOME/miniconda3/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

#
# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/w/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/w/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/w/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/w/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

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

    printf "%s%.1f %s" "$sign" "$value" "$unit"
}

# Function to get the current Terraform workspace
tf_workspace() {
    if [ -d ".terraform" ]; then
        # Retrieve the workspace name and apply cyan color
        local workspace=$(terraform workspace show 2>/dev/null)
        echo "𝑇%F{cyan}$workspace%f|"
    else
        echo ""
    fi

}

# Function to get the current Kubernetes context and namespace
kube_context() {
    local context namespace
    context=$(kubectl config current-context 2>/dev/null)
    namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)

    # Check if context is set
    if [[ -n $context ]]; then
        # Display Kubernetes context and namespace in green
        echo "𝐾%F{green}$context%f/%F{blue}${namespace:-default}%f|"
    else
        echo ""
    fi
}

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

# Function to update RPROMPT before each prompt display
update_rprompt() {
    VKA_VARS="$(kube_context)$(tf_workspace)$(charging_current)"
}

#precmd_functions+=(update_rprompt)

prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
      print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
      print -n "%{%k%}"
  fi

  print -n "%{%f%}"
  CURRENT_BG=''

  print -n "\n%{%f%b%k%}>"
}


autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit
complete -C '/usr/local/bin/aws_completer' aws


fpath=($fpath ~/.zsh/completion)

export CDPATH="$HOME:$HOME/projects/sima"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"


tf() {
  if [ "$#" -lt 1 ]; then
    echo "Usage: tf <command> [args...]"
    return 1
  fi

  local cmd="$1"
  shift

  local ws
  ws=$(terraform workspace show)
  echo "Using workspace '${ws}'"

  local var_file
  var_file=$(find workspace-tfvars -type f -name "${ws}.tfvars" -print -quit 2>/dev/null)

  if [ -z "$var_file" ]; then
    echo "No variable file found for workspace '${ws}' in 'workspace-tfvars'" >&2
    return 1
  fi

  terraform "$cmd" -var-file="$var_file" "$@"
}

tfns() {
  if [ ! -d workspace-tfvars ]; then
    echo "Directory 'workspace-tfvars' does not exist" >&2
    return 1
  fi

  find workspace-tfvars -maxdepth 1 -type f -name "*.tfvars" -exec basename {} .tfvars \;
}
alias tfapply='tf apply'
alias tfdestroy='tf destroy'
alias tfplan='tf plan'
alias tfimport='tf import'

alias fs="./fhmakew.sh --setup"
alias gitroot='cd "$(git rev-parse --show-cdup)"'
alias tmux="tmux -u"
alias xsc="xclip -selection clipboard"
alias git_deletemergedbranches='git fetch -p && for branch in $(git branch -vv | grep ": gone]" | awk "{print $1}"); do git branch -D $branch; done'

source <(kubectl completion zsh)
PROMPT="%(?..%F{red}%B(%?%)%b%f)${PROMPT}"
PROMPT='$(kube_context)$(tf_workspace)$(charging_current)'${PROMPT}
