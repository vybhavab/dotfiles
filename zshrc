#if [ "$TMUX" = "" ]; then tmux; fi
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/vybhavb/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME=random
ZSH_THEME="oxide"
#ZSH_THEME=random
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
#ZSH_THEME_RANDOM_CANDIDATES=( "3den" "fino-time" "kiwi" "rkj-repos" "adben" "fino" "kolo" "rkj" "af-magic" "fishy" "kphoen" "robbyrussell" "afowler" "flazz" "lambda" "sammy" "agnoster" "fletcherm" "linuxonly" "simonoff" "alanpeabody" "fox" "lukerandall" "simple" "amuse" "frisk" "macovsky-ruby" "skaro" "apple" "frontcube" "macovsky" "smt" "arrow" "funky" "maran" "Soliah" "aussiegeek" "fwalch" "mgutz" "sonicradish" "avit" "gallifrey" "mh" "sorin" "awesomepanda" "gallois" "michelebologna" "sporty_256" "bira" "garyblessington" "mikeh" "steeef" "blinks" "gentoo" "miloshadzic" "strug" "bureau" "geoffgarside" "minimal" "sunaku" "candy-kingdom" "gianu" "mira" "sunrise" "candy" "gnzh" "mortalscumbag" "superjarin" "clean" "gozilla" "mrtazz" "suvash" "cloud" "half-life" "murilasso" "takashiyoshida" "crcandy" "humza" "muse" "terminalparty" "crunch" "imajes" "nanotech" "theunraveler" "cypher" "intheloop" "nebirhos" "tjkirch_mod" "dallas" "itchy" "nicoulaj" "tjkirch" "darkblood" "jaischeema" "norm" "tonotdo" "daveverwer" "jbergantine" "obraun" "trapd00r" "dieter" "jispwoso" "oxide" "wedisagree" "dogenpunk" "jnrowe" "peepcode" "wezm+" "dpoggi" "jonathan" "philips" "wezm" "dstufft" "josh" "pmcgee" "wuffers" "dst" "jreese" "pygmalion-virtualenv" "xiong-chiamiov-plus" "duellj" "jtriley" "pygmalion" "xiong-chiamiov" "eastwood" "juanghurtado" "re5et" "ys" "edvardm" "junkfood" "refined" "zhann" "emotty" "kafeitu" "rgm" "essembeh" "kardan" "risto" "evan" "kennethreitz" "rixius")
#ZSH_THEME_RANDOM_CANDIDATES=("oxide" "robbyrussell" "hyperzsh")
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
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
#ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

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
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  autojump
  last-working-dir
  git
  dotenv
  zsh-autosuggestions
  fast-syntax-highlighting
  thefuck
)

DEFAULT_USER=vybhavb
prompt_context(){}

source $ZSH/oh-my-zsh.sh

# User configuration

export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias uxssh="ssh vacharbh@unix.ucsc.edu"
alias gg="lazygit"
alias vi="nvim"
alias vim="nvim"
alias ud="cd ~/Documents/Programming"
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias open="xdg-open"
alias .="nvim"
autoload -Uz compinit
compinit
# Completion for kitty
kitty + complete setup zsh | source /dev/stdin
eval $(thefuck --alias)


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# nvm() {
#     unset -f nvm
#     export NVM_DIR=~/.nvm
#     [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
#     nvm "$@"
# }
# 
# node() {
#     unset -f node
#     export NVM_DIR=~/.nvm
#     [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
#     node "$@"
# }
# 
# npm() {
#     unset -f npm
#     export NVM_DIR=~/.nvm
#     [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
#     npm "$@"
# }
#
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
