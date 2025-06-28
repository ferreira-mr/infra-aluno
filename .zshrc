# ===================================================================
# ARQUIVO DE CONFIGURAÇÃO DO ZSH (.zshrc) PARA DESENVOLVIMENTO
# Foco: PHP, Laravel, Git, Docker e Produtividade no Terminal.
# ===================================================================

# -------------------------------------------------------------------
# 1. CONFIGURAÇÕES DO OH MY ZSH (OMZ)
# -------------------------------------------------------------------
# Caminho para a instalação do Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# TEMA: 'agnoster' é um tema popular que mostra o status do Git.
# Requer a instalação de uma fonte "Powerline" ou "Nerd Font" no seu terminal.
ZSH_THEME="agnoster"

# PLUGINS: Liste aqui os plugins que o OMZ deve carregar.
# Não é necessário carregar manualmente com 'source' depois.
plugins=(
  git           # Atalhos e funções para o Git
  composer      # Autocompletar para o Composer
  laravel       # Atalhos para o Laravel (ex: 'pa' para 'php artisan')
  sudo          # Adiciona 'sudo' ao início do comando com Esc+Esc
  docker        # Autocompletar para comandos Docker
  z             # Salta para diretórios visitados com frequência (ex: 'z www')
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Carrega o Oh My Zsh (deve ser a última coisa nesta seção)
source "$ZSH/oh-my-zsh.sh"

# -------------------------------------------------------------------
# 2. HISTÓRICO E PERFORMANCE
# -------------------------------------------------------------------
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS # Não salva comandos duplicados na sequência

# -------------------------------------------------------------------
# 3. VARIÁVEIS DE AMBIENTE E PATH
# -------------------------------------------------------------------
# Cores para o comando 'ls'
eval "$(dircolors -b)"

# Adiciona o diretório de binários do Composer ao PATH
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# -------------------------------------------------------------------
# 4. ALIASES (ATALHOS SIMPLES)
# -------------------------------------------------------------------
# Geral
alias ls='ls --color=auto'
alias l='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias reload-zsh='source ~/.zshrc && echo "Zsh recarregado!"'

# PHP & Laravel (o alias 'php' é ótimo para evitar limites de memória com composer)
alias php='php -d memory_limit=-1'
alias serve='php artisan serve'
alias tinker='php artisan tinker'

# Git (mantendo os seus ótimos atalhos)
alias gs='git status'
alias gsp='git status -sb' # Status mais curto e prático
alias gl='git log --oneline --graph --all --decorate'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gco='git checkout'
alias gp='git pull'
alias gpush='git push'

# Docker & Sail
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'
alias salti='sail tinker' # Atalho para o tinker do Sail
alias freshail='sail artisan migrate:fresh --seed'

# -------------------------------------------------------------------
# 5. FUNÇÕES (COMANDOS AVANÇADOS)
# -------------------------------------------------------------------

# Cria um diretório e entra nele imediatamente
take() {
  mkdir -p "$1"
  cd "$1"
}

# Roda migrate:fresh --seed com uma confirmação visual
freshdb() {
  echo "🔥 Recriando o banco de dados do zero..."
  php artisan migrate:fresh --seed
  echo "✅ Banco de dados recriado com sucesso!"
}

# Conecta no MariaDB com as credenciais do nosso ambiente Vagrant
# Usar -pSENHA (sem espaço) é conveniente para a VM, mas não faça isso em produção!
db() {
  mysql -u aluno -p"senai914"
}

# Cria um backup do banco de dados de um projeto Laravel
# Uso: backupdb nome_do_arquivo.sql
backupdb() {
    # Detecta o nome do banco de dados a partir do .env
    DB_NAME=$(grep DB_DATABASE .env | cut -d '=' -f2)
    if [ -z "$DB_NAME" ]; then
        echo "❌ Erro: Não foi possível encontrar DB_DATABASE no arquivo .env"
        return 1
    fi

    echo "💾 Fazendo backup do banco '$DB_NAME' para o arquivo '$1'..."
    mysqldump -u aluno -p"senai914" "$DB_NAME" > "$1"
    echo "✅ Backup concluído!"
}


# -------------------------------------------------------------------
# 6. CONFIGURAÇÕES VISUAIS E DE PLUGINS
# -------------------------------------------------------------------
# Cor cinza para as sugestões do zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Remove o "user@hostname" do prompt do Agnoser para um visual mais limpo
DEFAULT_USER=$USER