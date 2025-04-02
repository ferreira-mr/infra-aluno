Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"

  # Configuração da rede privada com IP fixo
  config.vm.network "private_network", ip: "192.168.56.10"

  # Configuração de hardware da VM
  config.vm.provider "virtualbox" do |vb|
    vb.name = "servidor-sp-skills"
    vb.memory = "1024"
    vb.cpus = 1
  end

  # Sincronizar pasta do host com o diretório do Apache na VM
  config.vm.synced_folder "./competidor-01", "/var/www/html", type: "virtualbox", create: true

  # Instalação do ambiente LAMP
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y apache2 mariadb-server php libapache2-mod-php php-mysql sudo openssh-server

    # Criação do usuário competidor
    if ! id "competidor" &>/dev/null; then
      useradd -m -s /bin/bash competidor
      echo "competidor:senai914" | chpasswd
      usermod -aG sudo competidor
    fi

    # Alterando permissões do diretório do Apache
    chown -R competidor:www-data /var/www/html
    chmod -R 755 /var/www/html

    # Habilitar conexões remotas no MariaDB
    sed -i "s/^bind-address\\s*=.*$/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
    systemctl restart mariadb

    # Criação ou alteração da senha do usuário no MariaDB
    mysql -u root -e "
    CREATE USER IF NOT EXISTS 'competidor'@'%' IDENTIFIED BY 'senai914';
    ALTER USER 'competidor'@'%' IDENTIFIED BY 'senai914';
    GRANT ALL PRIVILEGES ON *.* TO 'competidor'@'%' WITH GRANT OPTION;
    FLUSH PRIVILEGES;"
  SHELL

  # Exibir IP no terminal (sempre que a máquina for iniciada)
  config.vm.provision "shell", inline: <<-SHELL, run: "always"
    echo ""
    echo "##############################################################################"
    echo "Acesso ao Servidor SP Skills"
    echo ""
    IP=$(ip -4 addr show eth1 | grep -oP '(?<=inet\\s)\\d+(\\.\\d+){3}')
    echo "Acesso ao Apache (navegador web): http://$IP"
    echo ""
    echo "Conexão SFTP:"
    echo "  Host: $IP"
    echo "  Usuário: competidor"
    echo "  Senha: senai914"
    echo "  Porta: 22"
    echo ""
    echo "Conexão SSH:"
    echo "  Host: $IP"
    echo "  Usuário: competidor"
    echo "  Senha: senai914"
    echo "  Para conectar, use o comando: ssh competidor@$IP"
    echo "##############################################################################"
    echo ""
  SHELL

  # Habilitar autenticação SSH por senha apenas para o usuário competidor
  config.vm.provision "shell", inline: <<-SHELL
    echo "Match User competidor" >> /etc/ssh/sshd_config
    echo "  PasswordAuthentication yes" >> /etc/ssh/sshd_config
    systemctl restart ssh
  SHELL

end