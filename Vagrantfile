Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"

  # Configuração da rede pública (Bridged) para receber IP via DHCP
  config.vm.network "public_network"

  # Configuração de hardware da VM
  config.vm.provider "virtualbox" do |vb|
    vb.name = "competidor-01-v2"
    vb.memory = "1024"
    vb.cpus = 1
  end

  # Provisionamento para instalar VirtualBox Guest Additions
  config.vm.provision "shell", inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y build-essential dkms linux-headers-$(uname -r)
    mount -o loop /usr/share/virtualbox/VBoxGuestAdditions.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run --nox11
    umount /mnt
    systemctl restart vboxadd vboxadd-service
  SHELL

  # Sincronizar pasta do host com o diretório do Apache na VM
  config.vm.synced_folder "./competidor-01", "/var/www/html"

  # Provisionamento da VM (instalação do ambiente LAMP)
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y apache2 mariadb-server php libapache2-mod-php php-mysql sudo openssh-server
    chown -R competidor:www-data /var/www/html
    chmod -R 777 /var/www/html

    if ! id "competidor" &>/dev/null; then
        useradd -m -s /bin/bash competidor
        echo "competidor:competidor" | chpasswd
        usermod -aG sudo competidor
    fi

    sed -i "s/^#PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config
    systemctl restart ssh

    sed -i "s/^bind-address\s*=.*$/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
    systemctl restart mariadb

    mysql -u root -e "
    CREATE USER IF NOT EXISTS 'competidor'@'%' IDENTIFIED BY 'competidor';
    GRANT ALL PRIVILEGES ON *.* TO 'competidor'@'%' WITH GRANT OPTION;
    FLUSH PRIVILEGES;"
  SHELL

  # Exibir IP no terminal sempre que a VM for iniciada
  config.vm.provision "shell", inline: <<-SHELL
    echo '#!/bin/bash' > /etc/profile.d/show_ip.sh
    echo 'echo "##########################"' >> /etc/profile.d/show_ip.sh
    echo 'echo "IP do competidor-01:"' >> /etc/profile.d/show_ip.sh
    echo 'ip -4 addr show eth1 | grep -oP "(?<=inet\s)\d+(\.\d+){3}"' >> /etc/profile.d/show_ip.sh
    echo 'echo "##########################"' >> /etc/profile.d/show_ip.sh
    chmod +x /etc/profile.d/show_ip.sh
  SHELL
end
