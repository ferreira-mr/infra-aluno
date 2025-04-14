Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  # Redirecionamento de portas — acesso via localhost
  config.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh"
  config.vm.network "forwarded_port", guest: 80, host: 8080, id: "http"
  config.vm.network "forwarded_port", guest: 443, host: 8443, id: "https"
  config.vm.network "forwarded_port", guest: 3306, host: 33060, id: "mysql"

  # Configuração de hardware
  config.vm.provider "virtualbox" do |vb|
    vb.name = "servidor-ubuntu-php"
    vb.memory = "2048"
    vb.cpus = 2
  end

  # Provisionamento: ambiente PHP + Laravel, ZSH, banco e ajustes
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y apache2 mariadb-server sudo curl php libapache2-mod-php php-mysql php-cli php-mbstring php-xml php-bcmath php-tokenizer php-zip unzip git zsh

    # Instalar Composer
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer

    # Instalar Laravel globalmente
    composer global require laravel/installer

    # Configurar PATH para o laravel
    echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> /etc/skel/.bashrc
    echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> /home/aluno/.bashrc

    # Instalar Oh My Zsh para root e para aluno
    apt-get install -y git
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    useradd -m -s /bin/zsh aluno
    echo "aluno:senai914" | chpasswd
    usermod -aG sudo aluno

    sudo -u aluno sh -c "sh -c '\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)' "" --unattended"

    # Plugins do Oh My Zsh
    sudo -u aluno git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/home/aluno/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sudo -u aluno git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-/home/aluno/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    # Ativar plugins no .zshrc
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' /home/aluno/.zshrc
    chown aluno:aluno /home/aluno/.zshrc

    # Configurar MariaDB para aceitar conexões externas
    sed -i "s/^bind-address\\s*=.*$/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
    systemctl restart mariadb

    # Criar usuário aluno no banco de dados
    mysql -u root -e "
      CREATE USER IF NOT EXISTS 'aluno'@'%' IDENTIFIED BY 'senai914';
      ALTER USER 'aluno'@'%' IDENTIFIED BY 'senai914';
      GRANT ALL PRIVILEGES ON *.* TO 'aluno'@'%' WITH GRANT OPTION;
      FLUSH PRIVILEGES;
    "

    # Configurar SSH para aceitar o usuário aluno
    echo "Match User aluno" >> /etc/ssh/sshd_config
    echo "  PasswordAuthentication yes" >> /etc/ssh/sshd_config
    systemctl restart ssh

    # Copiar arquivos da pasta /vagrant/www para /var/www/html
    if [ -d "/vagrant/www" ]; then
      rm -rf /var/www/html/*
      cp -r /vagrant/www/. /var/www/html/
      chown -R aluno:www-data /var/www/html
      chmod -R 755 /var/www/html
    fi
  SHELL

  # Mostrar informações de acesso no terminal sempre que iniciar
  config.vm.provision "shell", inline: <<-SHELL, run: "always"
    echo ""
    echo "#############################################################"
    echo " Máquina Ubuntu para Desenvolvimento PHP - Laravel Ready! "
    echo "-------------------------------------------------------------"
    echo " Apache: http://localhost:8080"
    echo " MySQL: Host=localhost | Porta=33060"
    echo " SSH:    ssh aluno@localhost -p 2222 (senha: senai914)"
    echo " SFTP:   Host=localhost | Porta=2222 | Usuário=aluno | Senha=senai914"
    echo "-------------------------------------------------------------"
    echo " Pronto para usar! Bons estudos! "
    echo "#############################################################"
  SHELL
end
