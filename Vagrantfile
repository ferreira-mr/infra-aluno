Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"

  # Configuração da rede privada com IP fixo, apenas a maquina onde roda a VM terá acesso
  config.vm.network "private_network", ip: "192.168.56.10"

  # Configuração da rede pública com DHCP, descomente esta linha caso queira que a máquina seja acessivel na rede local, lembre-se se comentar a linha de rede privada, utilize esta opção apenas se for necessário acessar a máquina virtual na rede local
  # Atente-se ao fato que será solicita, no terminal, qual interface de rede deverá ser utilizada e o IP "192.168.56.10" utilizado nos exemplos deverá ser alterado.
  # config.vm.network "public_network"

  # Configuração de hardware da VM
  config.vm.provider "virtualbox" do |vb|
    vb.name = "servidor-sp-skills"
    vb.memory = "1024"
    vb.cpus = 1
  end

  # Sincronizar pasta do host com o diretório do Apache na VM
  config.vm.synced_folder "./www-vm", "/var/www/html", type: "virtualbox", create: true

  # Instalação do ambiente LAMP
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y apache2 mariadb-server sudo openssh-server curl
    # apt-get install -y php libapache2-mod-php php-mysql php-cli php-mbstring php-xml php-bcmath php-tokenizer php-zip unzip curl sudo openssh-server

    /bin/bash -c "$(curl -fsSL https://php.new/install/linux/8.4)"

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
  IP=$(ip -4 addr show eth1 | grep -oP '(?<=inet\\s)\\d+(\\.\\d+){3}')
  echo ""
  echo "##############################################################################"
  echo "Acessos ao Servidor SP Skills"
  echo ""
  echo "Apache (navegador web): http://$IP"
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
  echo ""
  echo "Acesso ao Banco de Dados:"
  echo "  Host: $IP"
  echo "  Usuário: competidor"
  echo "  Senha: senai914"
  echo "  Porta: 3306"
  echo "##############################################################################"
  echo ""
SHELL

  # Habilitar autenticação SSH ao usuário competidor
  config.vm.provision "shell", inline: <<-SHELL
    echo "Match User competidor" >> /etc/ssh/sshd_config
    echo "  PasswordAuthentication yes" >> /etc/ssh/sshd_config
    systemctl restart ssh
  SHELL

end