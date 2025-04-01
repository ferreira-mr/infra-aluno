Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"

  # Configuração da rede privada com IP fixo
  config.vm.network "private_network", ip: "192.168.56.10"

  # Configuração de hardware da VM
  config.vm.provider "virtualbox" do |vb|
    vb.name = "competidor-01-v2"
    vb.memory = "1024"
    vb.cpus = 1
  end

  # Sincronizar pasta do host com o diretório do Apache na VM
  config.vm.synced_folder "./competidor-01", "/var/www/html", type: "virtualbox", create: true

  # Provisionamento da VM (instalação do ambiente LAMP)
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y apache2 mariadb-server php libapache2-mod-php php-mysql sudo openssh-server

    # Criação do usuário competidor antes de alterar permissões
    if ! id "competidor" &>/dev/null; then
        useradd -m -s /bin/bash competidor
        echo "competidor:senai914" | chpasswd
        usermod -aG sudo competidor
    fi

    # Alterando permissões após criar o usuário
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

  # Exibir IP no terminal sempre que a VM for iniciada
  config.vm.provision "shell", inline: <<-SHELL
    echo '#!/bin/bash' > /etc/profile.d/show_ip.sh
    echo 'echo "##########################"' >> /etc/profile.d/show_ip.sh
    echo 'echo "IP do competidor-01:"' >> /etc/profile.d/show_ip.sh
    echo 'ip -4 addr show eth1 | grep -oP "(?<=inet\\s)\\d+(\\.\\d+){3}"' >> /etc/profile.d/show_ip.sh
    echo 'echo "##########################"' >> /etc/profile.d/show_ip.sh
    chmod +x /etc/profile.d/show_ip.sh
  SHELL
end
