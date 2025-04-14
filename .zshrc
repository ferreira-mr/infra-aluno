# História de comandos
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Ativa o compinit para auto-completar moderno
autoload -Uz compinit
compinit

# Personalização de autocompletar
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=long
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

# Cores para o kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# LS_COLORS baseado no dircolors
eval "$(dircolors -b)"

# Caminho padrão
export PATH=$HOME/.composer/vendor/bin:$HOME/.local/bin:$PATH

# PHP config
alias php='php -d memory_limit=-1'
alias artisan='php artisan'

# Laravel utils
alias serve='php artisan serve'
alias tinker='php artisan tinker'
alias migrate='php artisan migrate'
alias seed='php artisan db:seed'
alias fresh='php artisan migrate:fresh --seed'

# MariaDB acesso simplificado
alias mysql='mysql -u root -p'
alias mysqldump='mysqldump -u root -p'

# Atualiza Composer global
alias composer-update='composer global update'

# Git helpers
alias gs='git status'
alias gl='git log --oneline --graph --all --decorate'
alias gp='git pull'
alias gpush='git push'
alias gc='git commit -m'
alias gaa='git add .'

# Oh-My-Zsh plugins
plugins=(
  git
  composer
  laravel
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Fonte do tema
ZSH_THEME="robbyrussell"

# Ativa os plugins
source $ZSH/oh-my-zsh.sh

# Ativa autosuggestions e syntax highlighting
source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Prompt clean e moderno
export PROMPT='%F{green}%n@%m%f:%F{blue}%~%f %# '

# Sugestão de cor para autocomplete
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Aliases de Docker (caso use)
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

# Reload Zsh fácil
alias reload-zsh='source ~/.zshrc'
