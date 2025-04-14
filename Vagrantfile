Vagrant.configure("2") do |config|
  config.vm.box = "alvistack/ubuntu-24.04"
  config.vm.hostname = "servidor-local"

  # Redirecionamento de portas — acesso via localhost
  config.vm.network "forwarded_port", guest: 22, host: 8022, id: "ssh"
  config.vm.network "forwarded_port", guest: 80, host: 8080, id: "http"
  config.vm.network "forwarded_port", guest: 443, host: 8043, id: "https"
  config.vm.network "forwarded_port", guest: 3306, host: 8060, id: "mysql"

  # Configuração de hardware
  config.vm.provider "virtualbox" do |vb|
    vb.name = "servidor-local"
    vb.memory = "8192"
    vb.cpus = 4
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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
    useradd -m -s /bin/zsh aluno
    echo "aluno:senai914" | chpasswd
    usermod -aG sudo aluno

    sudo -u aluno sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended

    # Plugins do Oh My Zsh
    sudo -u aluno git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/home/aluno/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sudo -u aluno git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-/home/aluno/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

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
      cp -r /vagrant/.zshrc /home/aluno/.zshrc
      chown aluno:aluno /home/aluno/.zshrc
    fi
    # Mostrar informações de acesso no terminal sempre que iniciar
    ACCESS_INFO="\\n#############################################################\\n Servidor Local para Desenvolvimento \\n-------------------------------------------------------------\\n Apache: http://localhost:8080\\n SSH:    Host=localhost | Porta=8022 | Usuário=aluno | Senha=senai914\\n MySQL:  Host=localhost | Porta=8060 | Usuário=aluno | Senha=senai914\\n SFTP:   Host=localhost | Porta=8022 | Usuário=aluno | Senha=senai914\\n-------------------------------------------------------------\\n Pronto para usar! Bons estudos! \\n#############################################################\\n"
    echo -e "$ACCESS_INFO" > /etc/motd

    echo "Provisionamento concluído!"
    SHELL
end
