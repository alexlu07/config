# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

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

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

autoload -Uz promptinit
promptinit
#prompt clint
prompt adam1 none green green

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
setopt histignorealldups sharehistory
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


#alias
alias rm="rm -i"
alias cp="cp -i"
slowleft() {command xdotool click --repeat 500000 --delay 1750 --window $(xdotool search --name "Minecraft") 1}
slowright() {command xdotool click --repeat 500000 --delay 5000 --window $(xdotool search --name "Minecraft") 3}
fastleft() {command xdotool click --repeat 500000 --delay 18 --window $(xdotool search --name "Minecraft") 1}
fastright() {command xdotool click --repeat 500000 --delay 18 --window $(xdotool search --name "Minecraft") 3}

restartaudio() {
  systemctl --user kill pulseaudio.socket;
  systemctl --user kill pulseaudio.service;
  systemctl --user kill pulseaudio.socket;
  pulseaudio -k;
  pulseaudio -D;
}

#fzf (fuzzy find)
#. ~/.fzf.key-bindings.zsh


# #fzf
# #We don't seem to have fzf-tmux installed
# export FZF_TMUX=0
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


cd ~/Documents

# set mouse speed
# xinput --set-prop 13 302 -0.9


# sudo logid

##################################################################333
#
#  .zshrc-custom
#    This file is loaded by ~/.zshrc, put your zsh customizations
#    in here
#
#    2012/1/25 - Initial Revision
#
export EDITOR='emacs'
export VISUAL='emacs'
set -o emacs

## Fancy colors for git prompt(clean/dirty)
#source /u/rushi/git/zsh-git-prompt/zshrc.sh

#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}%{CLEAN%G%}"
#ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[blue]%}"

# TODO: Commenting since this might be slowing dowm the command prompt
#function precmd {
#  PROMPT=%F{blue}%m%f:%B%(5~|...|)%5~%b$(git_super_status)\>
#}

PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_RED%n$PR_LIGHT_BLUE@$PR_GREEN%m(\
$PR_CYAN%$PR_PWDLEN<...<%~%<<$PR_GREEN)$PR_BLUE\
$PR_LIGHT_BLUE:%(!.$PR_RED.$PR_NO_COLOUR)%#\
$PR_NO_COLOUR
$ '

#umask 0007


# # JINA_CLI_BEGIN

# ## autocomplete
# if [[ ! -o interactive ]]; then
#     return
# fi

# compctl -K _jina jina

# _jina() {
#   local words completions
#   read -cA words

#   if [ "${#words}" -eq 2 ]; then
#     completions="$(jina commands)"
#   else
#     completions="$(jina completions ${words[2,-2]})"
#   fi

#   reply=(${(ps:\n:)completions})
# }

# # session-wise fix
# ulimit -n 4096
# export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export SHELL='/usr/bin/zsh'

# JINA_CLI_END

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/alexlu/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/alexlu/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/alexlu/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/alexlu/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<
