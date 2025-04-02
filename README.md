# Guia Técnico de Instalação e Utilização da VM com VirtualBox e Vagrant

Este guia detalha a instalação do VirtualBox e Vagrant, bem como os procedimentos para executar e gerenciar uma máquina virtual definida pelo arquivo Vagrantfile fornecido. O objetivo é fornecer instruções precisas e técnicas para usuários que necessitam utilizar esta VM para desenvolvimento ou testes.

## Pré-requisitos

- **Conexão com a internet** para download dos softwares e da imagem da VM.
- **Privilégios de administrador** no sistema operacional hospedeiro.

## Passo 1: Instalação do VirtualBox

O VirtualBox atuará como o hipervisor para nossa máquina virtual.

### Download do VirtualBox

1. Acesse o site oficial: [VirtualBox](https://www.virtualbox.org).
2. Clique em "Download VirtualBox".
3. Selecione o instalador correspondente ao seu sistema operacional (Windows, macOS ou Linux).

### Execução do Instalador

1. Localize o arquivo baixado e execute-o.
2. Siga as instruções do assistente de instalação. **Recomenda-se manter as configurações padrão**, a menos que haja uma necessidade específica de alteração.
3. Durante a instalação, poderão ser solicitadas permissões para instalar drivers de rede. **Conceda essas permissões** para o correto funcionamento do VirtualBox.

### Verificação da Instalação

1. Após a conclusão, procure por "VirtualBox" no menu de aplicativos do seu sistema operacional e execute-o.
2. Se o aplicativo abrir sem erros, a instalação foi bem-sucedida.

## Passo 2: Instalação do Vagrant

O Vagrant será utilizado para automatizar a criação e o gerenciamento do ciclo de vida da máquina virtual.

### Download do Vagrant

1. Acesse o site oficial: [Vagrant](https://www.vagrantup.com).
2. Clique em "Download".
3. Escolha o instalador compatível com o seu sistema operacional.

### Execução do Instalador

1. Execute o arquivo de instalação baixado.
2. Siga as instruções apresentadas na tela para completar a instalação.

### Verificação da Instalação

1. Abra o terminal (Prompt de Comando no Windows ou Terminal no macOS/Linux).
2. Execute o seguinte comando para verificar a versão do Vagrant instalada:

   ```bash
   vagrant --version
   ```

3. Se a saída exibir o número da versão do Vagrant, a instalação foi bem-sucedida.

## Passo 3: Inicializando a Máquina Virtual

Com o VirtualBox e Vagrant instalados, podemos iniciar a máquina virtual definida pelo Vagrantfile.

### Navegação até o Diretório do Vagrantfile

Utilize o terminal para navegar até o diretório onde o arquivo Vagrantfile está localizado. Por exemplo:

```bash
cd /caminho/para/o/diretorio/do/vagrantfile
```

Certifique-se de que o arquivo Vagrantfile fornecido esteja presente neste diretório.

### Inicialização da VM

No terminal, dentro do diretório do Vagrantfile, execute o seguinte comando para criar e iniciar a máquina virtual:

```bash
vagrant up
```

Este comando irá:

- **Verificar** a existência da box especificada (`debian/bookworm64`). Se não existir localmente, o Vagrant fará o download da imagem.
- **Criar** a máquina virtual no VirtualBox com as configurações definidas no Vagrantfile.
- **Configurar** a rede privada com o IP `192.168.56.10`.
- **Alocar** os recursos de hardware especificados (1024MB de memória e 1 CPU).
- **Sincronizar** a pasta local `./competidor-01` com o diretório `/var/www/html` na VM.
- **Executar** o script de provisionamento para instalar o ambiente LAMP (Apache2, MariaDB, PHP) e criar o usuário `competidor`.
- **Exibir** informações de acesso ao servidor no terminal.

## Passo 4: Gerenciando o Ciclo de Vida da Máquina Virtual

O Vagrant oferece diversos comandos para gerenciar o estado da máquina virtual.

- **Iniciar uma VM parada:**
  ```bash
  vagrant up
  ```
- **Pausar a VM:**
  ```bash
  vagrant suspend
  ```
  Para retomar:
  ```bash
  vagrant up
  ```
- **Desligar a VM:**
  ```bash
  vagrant halt
  ```
- **Reiniciar a VM:**
  ```bash
  vagrant reload
  ```
- **Destruir a VM:**
  ```bash
  vagrant destroy
  ```

## Passo 5: Acessando a Máquina Virtual

- **Via navegador (Apache):**
  ```
  http://192.168.56.10
  ```
- **Via SFTP:**
  - **Host:** `192.168.56.10`
  - **Usuário:** `competidor`
  - **Senha:** `senai914`
  - **Porta:** `22`
- **Via SSH:**
  ```bash
  ssh competidor@192.168.56.10
  ```
  **Senha:** `senai914`
  

## Passo 6: Informações Adicionais e Troubleshooting

### Erro "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!"

Esse erro ocorre quando a chave SSH do servidor remoto (neste caso, a máquina virtual) mudou em relação à chave armazenada localmente no arquivo `~/.ssh/known_hosts`. Isso pode acontecer nos seguintes cenários:

- A máquina virtual foi destruída (`vagrant destroy`) e recriada (`vagrant up`), resultando em uma nova identidade SSH.
- A box base da VM foi atualizada, gerando um novo par de chaves.
- O endereço IP configurado para a VM foi utilizado anteriormente por outra máquina com uma chave SSH diferente.

Quando isso acontece, o SSH bloqueia a conexão para evitar possíveis ataques man-in-the-middle. Para corrigir o problema, remova a entrada antiga da chave SSH associada ao IP da VM com o seguinte comando:

```bash
ssh-keygen -R 192.168.56.10
```

Isso limpará a chave antiga armazenada no seu computador, permitindo que uma nova conexão SSH seja estabelecida sem conflitos.

## Conclusão

Este guia forneceu os passos necessários para instalar e utilizar a máquina virtual definida pelo Vagrantfile. Utilize os comandos do Vagrant para controlar o ciclo de vida da VM de acordo com suas necessidades.

