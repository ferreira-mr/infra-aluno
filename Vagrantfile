# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variáveis de Configuração para facilitar a manutenção
VM_IP = "192.168.50.10" # IP Fixo para a Máquina Virtual
VM_MEMORY = "4096"
VM_CPUS = 2
USER_NAME = "aluno"
USER_PASS = "senai914"

Vagrant.configure("2") do |config|
  config.vm.box = "alvistack/ubuntu-24.04"
  config.vm.hostname = "servidor-local"

  config.vm.network "private_network", ip: VM_IP

  config.vm.provider "virtualbox" do |vb|
    vb.name = "servidor-local"
    vb.memory = VM_MEMORY
    vb.cpus = VM_CPUS
  end

  config.vm.provision "shell", inline: <<-SHELL
    # Exporta as variáveis do Ruby para serem usadas no script Shell
    export USER_NAME=#{USER_NAME}
    export USER_PASS=#{USER_PASS}
    export DEBIAN_FRONTEND=noninteractive
    export VM_IP=#{VM_IP}

    echo ">>> Iniciando provisionamento do servidor..."
    
    # 1. PRÉ-CONFIGURAÇÃO DO PHPMYADMIN
    echo ">>> Pré-configurando o PhpMyAdmin..."
    debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"

    # 2. INSTALAÇÃO DE PACOTES E ADIÇÃO DO PPA DO PHP
    echo ">>> Atualizando pacotes e instalando dependências..."
    apt-get update
    apt-get install -y software-properties-common
    add-apt-repository ppa:ondrej/php -y
    apt-get update && apt-get install -y \
      apache2 mariadb-server phpmyadmin sudo curl \
      php8.4 libapache2-mod-php8.4 php8.4-bcmath php8.4-cli php8.4-ctype php8.4-curl \
      php8.4-fileinfo php8.4-gd php8.4-mbstring php8.4-mysql \
      php8.4-sqlite3 php8.4-tokenizer php8.4-xml php8.4-zip \
      unzip git zsh

    # 3. CONFIGURAÇÃO DO USUÁRIO 'ALUNO'
    echo ">>> Configurando o usuário '$USER_NAME'..."
    id -u $USER_NAME &>/dev/null || useradd -m -s /bin/zsh $USER_NAME
    echo "$USER_NAME:$USER_PASS" | chpasswd
    usermod -aG sudo $USER_NAME

    # 4. INSTALAÇÃO DO COMPOSER E LARAVEL
    echo ">>> Instalando Composer e Laravel Installer..."
    if ! command -v composer &> /dev/null; then
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    fi
    sudo -u $USER_NAME composer global require laravel/installer

    # 5. CONFIGURAÇÃO DO AMBIENTE ZSH (OH MY ZSH)
    echo ">>> Instalando e configurando Oh My Zsh para o usuário '$USER_NAME'..."
    ZSH_DIR="/home/$USER_NAME/.oh-my-zsh"
    if [ ! -d "$ZSH_DIR" ]; then
        sudo -u $USER_NAME sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # INSTALA PLUGINS CUSTOMIZADOS DO ZSH
    echo ">>> Instalando plugins zsh-autosuggestions e zsh-syntax-highlighting..."
    ZSH_CUSTOM_PLUGINS="/home/$USER_NAME/.oh-my-zsh/custom/plugins"

    if [ ! -d "${ZSH_CUSTOM_PLUGINS}/zsh-autosuggestions" ]; then
        sudo -u $USER_NAME git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM_PLUGINS}/zsh-autosuggestions
    fi

    if [ ! -d "${ZSH_CUSTOM_PLUGINS}/zsh-syntax-highlighting" ]; then
        sudo -u $USER_NAME git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM_PLUGINS}/zsh-syntax-highlighting
    fi

    # Copia o arquivo .zshrc personalizado
    ZSHRC_PATH="/home/$USER_NAME/.zshrc"
    COMPOSER_PATH='export PATH="$PATH:$HOME/.config/composer/vendor/bin"'
    grep -qF "$COMPOSER_PATH" "$ZSHRC_PATH" || echo "$COMPOSER_PATH" >> "$ZSHRC_PATH"
    if [ -f "/vagrant/.zshrc" ]; then
        cp /vagrant/.zshrc /home/$USER_NAME/.zshrc
        chown $USER_NAME:$USER_NAME /home/$USER_NAME/.zshrc
    fi

    # 6. CONFIGURAÇÃO DO BANCO DE DADOS (MARIADB)
    echo ">>> Configurando MariaDB..."
    sed -i "s/^bind-address\\s*=.*$/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
    mysql -u root -e "CREATE USER IF NOT EXISTS '$USER_NAME'@'%' IDENTIFIED BY '$USER_PASS';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$USER_NAME'@'%' WITH GRANT OPTION;"
    mysql -u root -e "FLUSH PRIVILEGES;"
    systemctl restart mariadb

    # 7. CONFIGURAÇÃO DO SERVIDOR WEB E SSH
    echo ">>> Configurando Apache e SSH..."
    sed -i "/^PasswordAuthentication/c\PasswordAuthentication yes" /etc/ssh/sshd_config.d/50-cloud-init.conf
    systemctl restart ssh
    if [ -d "/vagrant/www" ]; then
      rm -rf /var/www/html/*
      cp -r /vagrant/www/. /var/www/html/
      chown -R $USER_NAME:www-data /var/www/html
      chmod -R 775 /var/www/html
    fi

    # 8. PERSONALIZAÇÃO DA PÁGINA INICIAL
    echo ">>> Personalizando o index.php com informações dinâmicas..."
    INDEX_FILE="/var/www/html/index.php"
    if [ -f "$INDEX_FILE" ]; then
        sed -i "s/__VM_IP__/${VM_IP}/g" "$INDEX_FILE"
        sed -i "s/__USER_NAME__/${USER_NAME}/g" "$INDEX_FILE"
        sed -i "s/__USER_PASS__/${USER_PASS}/g" "$INDEX_FILE"
    fi

    # 9. CRIAÇÃO DE ATALHO PARA O ALUNO
    echo ">>> Criando atalho para a pasta www na home do usuário..."
    ln -sfn /var/www/html /home/$USER_NAME/www
    chown -h $USER_NAME:$USER_NAME /home/$USER_NAME/www

    # 10. MENSAGEM DE BOAS-VINDAS (MOTD)
    echo ">>> Criando mensagem de boas-vindas..."
    ACCESS_INFO="""
#############################################################
#                                                           #
#          Servidor Local para Desenvolvimento              #
#                                                           #
#############################################################

  Seja bem-vindo(a) ao seu ambiente de estudos! (PHP 8.4)

  Acessos disponíveis via IP Fixo: ${VM_IP}
  -----------------------------------------------------------
  » Web:      http://${VM_IP}
  » PMA:      http://${VM_IP}/phpmyadmin
  » SSH:      ssh $USER_NAME@${VM_IP}
  
  Credenciais (usuário e banco de dados):
  -----------------------------------------------------------
  » Usuário:  $USER_NAME
  » Senha:    $USER_PASS

  Dados para conexão com o Banco (de fora da VM):
  -----------------------------------------------------------
  » Host:     ${VM_IP}
  » Porta:    3306 (porta padrão)

  Atalho rápido dentro da VM:
  -----------------------------------------------------------
  » cd ~/www (leva direto para a pasta do site)

#############################################################
"""
    echo -e "$ACCESS_INFO" > /etc/motd

    echo ">>> Provisionamento concluído com sucesso!"
  SHELL
end